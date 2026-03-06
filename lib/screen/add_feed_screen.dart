import 'dart:io';
import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:novindus_test/features/feeds/presentation/controllers/feed_upload_controller.dart';
import 'package:novindus_test/features/home/presentation/controllers/home_controller.dart';
import 'package:novindus_test/screen/home_screen.dart';
import 'package:novindus_test/core/utils/app_theme.dart';
import 'package:novindus_test/core/widgets/custom_snack_bar.dart';
import 'package:video_player/video_player.dart';

class AddFeedScreen extends StatefulWidget {
  const AddFeedScreen({super.key});

  @override
  State<AddFeedScreen> createState() => _AddFeedScreenState();
}

class _AddFeedScreenState extends State<AddFeedScreen> {
  final TextEditingController _descController = TextEditingController();

  @override
  void dispose() {
    _descController.dispose();
    super.dispose();
  }

  void _handleShare() async {
    final notifier = context.read<FeedUploadController>();
    await notifier.upload(_descController.text);

    if (notifier.success) {
      notifier.reset();
      if (mounted) {
        Navigator.pushReplacement(
          context,
          MaterialPageRoute(
            builder: (context) =>
                HomeScreen(successMessage: "Feed uploaded successfully!"),
          ),
        );
      }
    } else if (notifier.errorMessage != null) {
      CustomSnackBar.showSnackBar(
        context,
        notifier.errorMessage!,
        isError: true,
      );
    }
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
          'Add Feeds',
          style: TextStyle(
            color: Colors.white,
            fontSize: 18,
            fontWeight: FontWeight.bold,
          ),
        ),
        actions: [
          Padding(
            padding: const EdgeInsets.only(right: 16.0),
            child: Consumer<FeedUploadController>(
              builder: (context, uploadState, _) {
                return TextButton(
                  onPressed: uploadState.isUploading ? null : _handleShare,
                  style: TextButton.styleFrom(
                    backgroundColor: AppTheme.primaryColor.withOpacity(0.15),
                    shape: RoundedRectangleBorder(
                      borderRadius: BorderRadius.circular(100),
                      side: BorderSide(
                        color: AppTheme.primaryColor.withOpacity(0.3),
                      ),
                    ),
                    padding: const EdgeInsets.symmetric(
                      horizontal: 24,
                      vertical: 8,
                    ),
                  ),
                  child: const Text(
                    'Share Post',
                    style: TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.w600,
                    ),
                  ),
                );
              },
            ),
          ),
        ],
      ),
      body: SingleChildScrollView(
        child: Consumer2<FeedUploadController, HomeController>(
          builder: (context, uploadState, homeState, _) {
            return Column(
              crossAxisAlignment: CrossAxisAlignment.stretch,
              children: [
                const SizedBox(height: 16),
                _PickerBox(
                  onTap: () => uploadState.pickVideo(),
                  child: uploadState.videoPath != null
                      ? _LocalVideoPreview(videoPath: uploadState.videoPath!)
                      : const _PickerPlaceholder(
                          imagePath: 'asset/images/Group 2363.png',
                          label: 'Select a video from Gallery',
                        ),
                ),
                const SizedBox(height: 16),
                _PickerBox(
                  onTap: () => uploadState.pickThumbnail(),
                  child: uploadState.imagePath != null
                      ? ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(uploadState.imagePath!),
                            fit: BoxFit.cover,
                            width: double.infinity,
                            height: double.infinity,
                          ),
                        )
                      : const _PickerPlaceholder(
                          imagePath: 'asset/images/Group 2357.png',
                          label: 'Add a Thumbnail',
                          isRow: true,
                        ),
                ),
                if (uploadState.isUploading)
                  Padding(
                    padding: const EdgeInsets.all(24.0),
                    child: Column(
                      children: [
                        ClipRRect(
                          borderRadius: BorderRadius.circular(10),
                          child: LinearProgressIndicator(
                            value: uploadState.uploadProgress,
                            backgroundColor: Colors.white10,
                            color: AppTheme.primaryColor,
                            minHeight: 8,
                          ),
                        ),
                        const SizedBox(height: 8),
                        Text(
                          "Uploading... ${(uploadState.uploadProgress * 100).toInt()}%",
                          style: const TextStyle(
                            color: Colors.white70,
                            fontSize: 12,
                          ),
                        ),
                      ],
                    ),
                  ),
                const SizedBox(height: 16),
                const Padding(
                  padding: EdgeInsets.symmetric(horizontal: 24.0),
                  child: Text(
                    'Add Description',
                    style: TextStyle(
                      color: Colors.white,
                      fontSize: 16,
                      fontWeight: FontWeight.bold,
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.all(24.0),
                  child: TextField(
                    controller: _descController,
                    maxLines: 4,
                    style: const TextStyle(color: Colors.white70),
                    decoration: InputDecoration(
                      hintText: 'Lorem ipsum dolor sit amet...',
                      hintStyle: TextStyle(
                        color: Colors.white.withOpacity(0.3),
                      ),
                      filled: true,
                      fillColor: Colors.transparent,
                      enabledBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white10),
                      ),
                      focusedBorder: const UnderlineInputBorder(
                        borderSide: BorderSide(color: Colors.white24),
                      ),
                    ),
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 24.0),
                  child: Row(
                    mainAxisAlignment: MainAxisAlignment.spaceBetween,
                    children: [
                      const Text(
                        'Categories This Project',
                        style: TextStyle(
                          color: Colors.white,
                          fontSize: 16,
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                      TextButton(
                        onPressed: () {},
                        child: Row(
                          mainAxisSize: MainAxisSize.min,
                          children: [
                            Text(
                              'View All',
                              style: TextStyle(
                                color: Colors.white.withOpacity(0.6),
                                fontSize: 12,
                              ),
                            ),
                            const SizedBox(width: 4),
                            Icon(
                              Icons.info_outline,
                              color: Colors.white.withOpacity(0.4),
                              size: 14,
                            ),
                          ],
                        ),
                      ),
                    ],
                  ),
                ),
                Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 20.0),
                  child: Wrap(
                    spacing: 8,
                    runSpacing: 4,
                    children: homeState.categories.map((cat) {
                      final isSelected = uploadState.selectedCategoryIds
                          .contains(cat.id);
                      return FilterChip(
                        label: Text(cat.name),
                        selected: isSelected,
                        onSelected: (_) => uploadState.toggleCategory(cat.id),
                        showCheckmark: false,
                        labelStyle: TextStyle(
                          color: isSelected ? Colors.white : Colors.white70,
                          fontSize: 12,
                        ),
                        backgroundColor: Colors.transparent,
                        selectedColor: AppTheme.primaryColor.withOpacity(0.2),
                        shape: RoundedRectangleBorder(
                          borderRadius: BorderRadius.circular(20),
                          side: BorderSide(
                            color: isSelected
                                ? AppTheme.primaryColor
                                : Colors.white12,
                          ),
                        ),
                      );
                    }).toList(),
                  ),
                ),
                const SizedBox(height: 40),
              ],
            );
          },
        ),
      ),
    );
  }
}

class _PickerBox extends StatelessWidget {
  final Widget child;
  final VoidCallback onTap;

  const _PickerBox({required this.child, required this.onTap});

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 24.0),
      child: GestureDetector(
        onTap: onTap,
        child: Container(
          height: 180,
          decoration: BoxDecoration(
            color: Colors.white.withOpacity(0.05),
            borderRadius: BorderRadius.circular(16),
            border: Border.all(color: Colors.transparent),
          ),
          child: CustomPaint(
            painter: _DashedRectPainter(color: Colors.white24),
            child: Center(child: child),
          ),
        ),
      ),
    );
  }
}

class _LocalVideoPreview extends StatefulWidget {
  final String videoPath;
  const _LocalVideoPreview({required this.videoPath});

  @override
  State<_LocalVideoPreview> createState() => _LocalVideoPreviewState();
}

class _LocalVideoPreviewState extends State<_LocalVideoPreview> {
  late VideoPlayerController _controller;
  bool _initialized = false;

  @override
  void initState() {
    super.initState();
    _initializeController();
  }

  @override
  void didUpdateWidget(_LocalVideoPreview oldWidget) {
    super.didUpdateWidget(oldWidget);
    if (oldWidget.videoPath != widget.videoPath) {
      _controller.dispose();
      _initialized = false;
      _initializeController();
    }
  }

  void _initializeController() {
    _controller = VideoPlayerController.file(File(widget.videoPath))
      ..initialize().then((_) {
        if (mounted) {
          setState(() => _initialized = true);
        }
      });
  }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    if (!_initialized) {
      return const Center(child: CircularProgressIndicator(strokeWidth: 2));
    }
    return ClipRRect(
      borderRadius: BorderRadius.circular(12),
      child: Stack(
        alignment: Alignment.center,
        children: [
          AspectRatio(
            aspectRatio: _controller.value.aspectRatio,
            child: VideoPlayer(_controller),
          ),
          Container(
            color: Colors.black26,
            child: const Icon(
              Icons.play_circle_outline,
              color: Colors.white,
              size: 48,
            ),
          ),
        ],
      ),
    );
  }
}

class _PickerPlaceholder extends StatelessWidget {
  final String imagePath;
  final String label;
  final bool isRow;

  const _PickerPlaceholder({
    required this.imagePath,
    required this.label,
    this.isRow = false,
  });

  @override
  Widget build(BuildContext context) {
    final iconWidget = Container(
      padding: const EdgeInsets.all(12),
      decoration: BoxDecoration(
        color: Colors.white.withOpacity(0.05),
        shape: BoxShape.circle,
      ),
      child: Image.asset(imagePath, width: 32, height: 32, fit: BoxFit.contain),
    );

    final textWidget = Text(
      label,
      style: const TextStyle(color: Colors.white, fontSize: 13),
    );

    if (isRow) {
      return Row(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [iconWidget, const SizedBox(width: 16), textWidget],
      );
    }

    return Column(
      mainAxisAlignment: MainAxisAlignment.center,
      children: [iconWidget, const SizedBox(height: 12), textWidget],
    );
  }
}

class _DashedRectPainter extends CustomPainter {
  final Color color;
  _DashedRectPainter({required this.color});

  @override
  void paint(Canvas canvas, Size size) {
    double dashWidth = 8, dashSpace = 4;
    final paint = Paint()
      ..color = color
      ..strokeWidth = 1
      ..style = PaintingStyle.stroke;

    Path path = Path();
    path.addRRect(
      RRect.fromLTRBR(0, 0, size.width, size.height, const Radius.circular(16)),
    );

    for (
      var i = 0.0;
      i < path.getBounds().width * 4;
      i += dashWidth + dashSpace
    ) {}

    _drawDashedLine(
      canvas,
      const Offset(16, 0),
      Offset(size.width - 16, 0),
      paint,
    );
    _drawDashedLine(
      canvas,
      Offset(size.width, 16),
      Offset(size.width, size.height - 16),
      paint,
    );
    _drawDashedLine(
      canvas,
      Offset(size.width - 16, size.height),
      Offset(16, size.height),
      paint,
    );
    _drawDashedLine(canvas, Offset(0, size.height - 16), Offset(0, 16), paint);

    canvas.drawArc(Rect.fromLTWH(0, 0, 32, 32), 3.14, 1.57, false, paint);
    canvas.drawArc(
      Rect.fromLTWH(size.width - 32, 0, 32, 32),
      4.71,
      1.57,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(size.width - 32, size.height - 32, 32, 32),
      0,
      1.57,
      false,
      paint,
    );
    canvas.drawArc(
      Rect.fromLTWH(0, size.height - 32, 32, 32),
      1.57,
      1.57,
      false,
      paint,
    );
  }

  void _drawDashedLine(Canvas canvas, Offset p1, Offset p2, Paint paint) {
    double dashWidth = 8, dashSpace = 4;
    double distance = (p2 - p1).distance;
    int count = (distance / (dashWidth + dashSpace)).floor();
    for (int i = 0; i < count; i++) {
      double start = i * (dashWidth + dashSpace);
      canvas.drawLine(
        p1 + (p2 - p1) * (start / distance),
        p1 + (p2 - p1) * ((start + dashWidth) / distance),
        paint,
      );
    }
  }

  @override
  bool shouldRepaint(CustomPainter oldDelegate) => false;
}
