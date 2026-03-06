import 'package:flutter/material.dart';
import 'package:novindus_test/core/utils/app_theme.dart';
import 'package:novindus_test/core/widgets/custom_snack_bar.dart';
import 'package:provider/provider.dart';
import 'package:novindus_test/features/home/presentation/controllers/home_controller.dart';
import 'package:novindus_test/features/home/domain/entities/home_entity.dart';
import 'package:novindus_test/core/widgets/video_player_widget.dart';
import 'package:novindus_test/screen/add_feed_screen.dart';
import 'package:novindus_test/screen/my_feeds_screen.dart';

class HomeScreen extends StatefulWidget {
  final String? successMessage;
  const HomeScreen({super.key, this.successMessage});

  @override
  State<HomeScreen> createState() => _HomeScreenState();
}

class _HomeScreenState extends State<HomeScreen> {
  @override
  void initState() {
    super.initState();
    WidgetsBinding.instance.addPostFrameCallback((_) {
      final homeController = context.read<HomeController>();
      homeController.fetchInitialData();
      homeController.addListener(_homeListener);

      if (widget.successMessage != null) {
        CustomSnackBar.showSnackBar(context, widget.successMessage!);
      }
    });
  }

  void _homeListener() {
    if (!mounted) return;
    final homeController = context.read<HomeController>();
    if (homeController.errorMessage != null) {
      CustomSnackBar.showSnackBar(
        context,
        homeController.errorMessage!,
        isError: true,
      );
      homeController.resetError();
    }
  }

  @override
  void dispose() {
    try {
      if (mounted) {
        context.read<HomeController>().removeListener(_homeListener);
      }
    } catch (_) {}
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppTheme.backgroundColor,
      body: SafeArea(
        child: Consumer<HomeController>(
          builder: (context, homeState, _) {
            if (homeState.isLoading) {
              return const Center(child: CircularProgressIndicator());
            }

            if (homeState.errorMessage != null && homeState.feeds.isEmpty) {
              return Center(
                child: Column(
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                    Text(
                      "Error: ${homeState.errorMessage}",
                      style: const TextStyle(color: Colors.red),
                      textAlign: TextAlign.center,
                    ),
                    const SizedBox(height: 16),
                    ElevatedButton(
                      onPressed: () => homeState.fetchInitialData(),
                      child: const Text("Retry"),
                    ),
                  ],
                ),
              );
            }

            return CustomScrollView(
              slivers: [
                SliverToBoxAdapter(
                  child: Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.spaceBetween,
                      children: [
                        Column(
                          crossAxisAlignment: CrossAxisAlignment.start,
                          children: [
                            const Text(
                              'Hello Maria',
                              style: TextStyle(
                                color: Colors.white,
                                fontSize: 24,
                                fontWeight: FontWeight.bold,
                              ),
                            ),
                            Text(
                              'Welcome back to Section',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.7),
                                fontSize: 14,
                              ),
                            ),
                          ],
                        ),
                        GestureDetector(
                          onTap: () {
                            Navigator.push(
                              context,
                              MaterialPageRoute(
                                builder: (context) => const MyFeedsScreen(),
                              ),
                            );
                          },
                          child: const CircleAvatar(
                            radius: 25,
                            backgroundColor: Color(0xFF1E1E1E),
                            backgroundImage: AssetImage(
                              'asset/images/profile.jpg',
                            ),
                          ),
                        ),
                      ],
                    ),
                  ),
                ),
                SliverToBoxAdapter(
                  child: SizedBox(
                    height: 50,
                    child: Builder(
                      builder: (context) {
                        final allChips = [
                          ...homeState.categoryDict,
                          ...homeState.categories,
                        ];
                        return ListView.builder(
                          scrollDirection: Axis.horizontal,
                          padding: const EdgeInsets.symmetric(horizontal: 16),
                          itemCount: allChips.length,
                          itemBuilder: (context, index) {
                            final cat = allChips[index];
                            return _CategoryChip(
                              label: cat.name,
                              isSelected:
                                  homeState.selectedCategoryId == cat.id,
                              onSelected: () {
                                homeState.selectCategory(cat.id);
                              },
                            );
                          },
                        );
                      },
                    ),
                  ),
                ),
                const SliverToBoxAdapter(child: SizedBox(height: 16)),
                SliverList(
                  delegate: SliverChildBuilderDelegate((context, index) {
                    final feed = homeState.feeds[index];
                    final isPlaying = homeState.playingFeedId == feed.id;

                    return _FeedPostItem(
                      key: ValueKey(feed.id),
                      feed: feed,
                      isPlaying: isPlaying,
                      onPlayRequested: () {
                        homeState.setPlayingFeed(feed.id);
                      },
                    );
                  }, childCount: homeState.feeds.length),
                ),
              ],
            );
          },
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.push(
            context,
            MaterialPageRoute(builder: (context) => const AddFeedScreen()),
          );
        },
        backgroundColor: AppTheme.primaryColor,
        shape: const CircleBorder(),
        child: const Icon(Icons.add, color: Colors.white, size: 32),
      ),
    );
  }
}

class _CategoryChip extends StatelessWidget {
  final String label;
  final bool isSelected;
  final VoidCallback onSelected;

  const _CategoryChip({
    required this.label,
    required this.isSelected,
    required this.onSelected,
  });

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(right: 12.0),
      child: FilterChip(
        label: Text(label),
        selected: isSelected,
        onSelected: (_) => onSelected(),
        showCheckmark: false,
        labelStyle: TextStyle(
          color: isSelected ? Colors.white : Colors.white.withOpacity(0.7),
          fontSize: 13,
          fontWeight: isSelected ? FontWeight.w600 : FontWeight.normal,
        ),
        backgroundColor: Colors.transparent,
        selectedColor: AppTheme.activeChipBackground,
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(25),
          side: BorderSide(
            color: isSelected ? AppTheme.primaryColor : AppTheme.borderColor,
            width: 1,
          ),
        ),
      ),
    );
  }
}

class _FeedPostItem extends StatelessWidget {
  final FeedEntity feed;
  final bool isPlaying;
  final VoidCallback onPlayRequested;

  const _FeedPostItem({
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

        Padding(
          padding: const EdgeInsets.all(16.0),
          child: Text(
            feed.description,
            style: TextStyle(
              color: Colors.white.withOpacity(0.8),
              fontSize: 14,
              height: 1.4,
            ),
          ),
        ),

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
