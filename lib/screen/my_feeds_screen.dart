import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus_test/features/feeds/presentation/controllers/my_feeds_controller.dart';
import 'package:novindus_test/features/home/domain/entities/home_entity.dart';
import 'package:novindus_test/core/utils/app_theme.dart';
import 'package:novindus_test/core/widgets/video_player_widget.dart';
import 'package:novindus_test/core/widgets/custom_snack_bar.dart';

class MyFeedsScreen extends StatefulWidget {
  const MyFeedsScreen({super.key});

  @override
  State<MyFeedsScreen> createState() => _MyFeedsScreenState();
}

class _MyFeedsScreenState extends State<MyFeedsScreen> {
  final ScrollController _scrollController = ScrollController();

  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final controller = context.read<MyFeedsController>();
      controller.fetchMyFeeds(isRefresh: true);
      controller.addListener(_myFeedsListener);
    });

    _scrollController.addListener(() {
      if (_scrollController.position.pixels >=
          _scrollController.position.maxScrollExtent - 200) {
        context.read<MyFeedsController>().fetchMyFeeds();
      }
    });
  }

  void _myFeedsListener() {
    if (!mounted) return;
    final controller = context.read<MyFeedsController>();
    if (controller.errorMessage != null) {
      CustomSnackBar.showSnackBar(
        context,
        controller.errorMessage!,
        isError: true,
      );
      controller.resetError();
    }
  }

  @override
  void dispose() {
    try {
      context.read<MyFeedsController>().removeListener(_myFeedsListener);
    } catch (_) {}
    _scrollController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: IconButton(
          icon: Container(
            padding: const EdgeInsets.all(8),
            decoration: BoxDecoration(
              shape: BoxShape.circle,
              border: Border.all(color: Colors.white24),
            ),
            child: const Icon(
              Icons.arrow_back_ios_new,
              color: Colors.white,
              size: 16,
            ),
          ),
          onPressed: () => Navigator.pop(context),
        ),
        title: const Text(
          'My Feed',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
      ),
      body: Consumer<MyFeedsController>(
        builder: (context, state, _) {
          if (state.isLoading && state.feeds.isEmpty) {
            return const Center(child: CircularProgressIndicator());
          }

          return RefreshIndicator(
            onRefresh: () => state.fetchMyFeeds(isRefresh: true),
            child: state.feeds.isEmpty
                ? const Center(
                    child: Text(
                      "No feeds found",
                      style: TextStyle(color: Colors.white70),
                    ),
                  )
                : ListView.builder(
                    controller: _scrollController,
                    itemCount: state.feeds.length + (state.hasMore ? 1 : 0),
                    itemBuilder: (context, index) {
                      if (index == state.feeds.length) {
                        return const Padding(
                          padding: EdgeInsets.symmetric(vertical: 32),
                          child: Center(child: CircularProgressIndicator()),
                        );
                      }

                      final feed = state.feeds[index];
                      final isPlaying = state.playingFeedId == feed.id;

                      return _MyFeedItem(
                        key: ValueKey(feed.id),
                        feed: feed,
                        isPlaying: isPlaying,
                        onPlayRequested: () {
                          state.setPlayingFeed(feed.id);
                        },
                      );
                    },
                  ),
          );
        },
      ),
    );
  }
}

class _MyFeedItem extends StatelessWidget {
  final FeedEntity feed;
  final bool isPlaying;
  final VoidCallback onPlayRequested;

  const _MyFeedItem({
    super.key,
    required this.feed,
    required this.isPlaying,
    required this.onPlayRequested,
  });

  @override
  Widget build(BuildContext context) {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16.0, vertical: 12),
          child: Row(
            children: [
              CircleAvatar(
                radius: 20,
                backgroundColor: Colors.grey[800],
                backgroundImage: feed.user.profilePicture != null
                    ? NetworkImage(feed.user.profilePicture!)
                    : null,
                child: feed.user.profilePicture == null
                    ? const Icon(Icons.person, color: Colors.white)
                    : null,
              ),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    feed.user.name,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 15,
                    ),
                  ),
                  Text(
                    _formatDate(feed.createdAt),
                    style: TextStyle(
                      color: Colors.white.withOpacity(0.5),
                      fontSize: 12,
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        VideoPlayerWidget(
          videoUrl: feed.videoUrl,
          thumbnailUrl: feed.thumbnailUrl,
          shouldPlay: isPlaying,
          onPlay: onPlayRequested,
        ),
        _ExpandableDescription(description: feed.description),
        const Divider(color: AppTheme.borderColor),
      ],
    );
  }

  String _formatDate(String dateStr) {
    try {
      final dt = DateTime.parse(dateStr);
      final now = DateTime.now();
      final diff = now.difference(dt);
      if (diff.inDays > 0) return "${diff.inDays} days ago";
      if (diff.inHours > 0) return "${diff.inHours} hours ago";
      return "Just now";
    } catch (e) {
      return dateStr;
    }
  }
}

class _ExpandableDescription extends StatefulWidget {
  final String description;
  const _ExpandableDescription({required this.description});

  @override
  State<_ExpandableDescription> createState() => _ExpandableDescriptionState();
}

class _ExpandableDescriptionState extends State<_ExpandableDescription> {
  bool isExpanded = false;

  @override
  Widget build(BuildContext context) {
    final text = widget.description;
    final isLong = text.length > 100;

    return Padding(
      padding: const EdgeInsets.all(16.0),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.start,
        children: [
          RichText(
            text: TextSpan(
              children: [
                TextSpan(
                  text: !isExpanded && isLong
                      ? "${text.substring(0, 100)}..."
                      : text,
                  style: TextStyle(
                    color: Colors.white.withOpacity(0.8),
                    fontSize: 14,
                    height: 1.4,
                  ),
                ),
                if (isLong)
                  WidgetSpan(
                    alignment: PlaceholderAlignment.middle,
                    child: GestureDetector(
                      onTap: () => setState(() => isExpanded = !isExpanded),
                      child: Text(
                        isExpanded ? " Show Less" : " See More",
                        style: const TextStyle(
                          color: Colors.white,
                          fontWeight: FontWeight.bold,
                          fontSize: 14,
                        ),
                      ),
                    ),
                  ),
              ],
            ),
          ),
        ],
      ),
    );
  }
}
