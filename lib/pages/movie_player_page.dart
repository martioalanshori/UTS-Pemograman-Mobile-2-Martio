import 'dart:async';

import 'package:flutter/material.dart';
import 'package:flutter/services.dart';
import 'package:video_player/video_player.dart';

class MoviePlayerPage extends StatefulWidget {
  const MoviePlayerPage({
    super.key,
    required this.movieTitle,
  });

  final String movieTitle;

  @override
  State<MoviePlayerPage> createState() => _MoviePlayerPageState();
}

class _MoviePlayerPageState extends State<MoviePlayerPage> {
  late VideoPlayerController _controller;
  bool _isUiVisible = true;
  bool _isFullScreen = false;
  double _volume = 0.8;
  bool _showSkipLeft = false;
  bool _showSkipRight = false;
  Timer? _skipIndicatorTimer;

  @override
  void initState() {
    super.initState();
    _controller = VideoPlayerController.asset('assets/movie.mp4')
      ..initialize().then((_) {
        setState(() {});
        _controller.play();
      });
    _controller.setVolume(_volume);
  }

  @override
  void dispose() {
    if (_isFullScreen) {
      _exitFullScreen();
    }
    _skipIndicatorTimer?.cancel();
    _controller.dispose();
    super.dispose();
  }

  void _togglePlay() {
    if (!_controller.value.isInitialized) return;
    setState(() {
      if (_controller.value.isPlaying) {
        _controller.pause();
      } else {
        _controller.play();
      }
    });
  }

  Future<void> _toggleFullScreen() async {
    if (_isFullScreen) {
      await _exitFullScreen();
    } else {
      await SystemChrome.setEnabledSystemUIMode(SystemUiMode.immersiveSticky);
      await SystemChrome.setPreferredOrientations(
        [DeviceOrientation.landscapeLeft, DeviceOrientation.landscapeRight],
      );
      setState(() {
        _isFullScreen = true;
      });
    }
  }

  Future<void> _exitFullScreen() async {
    await SystemChrome.setEnabledSystemUIMode(SystemUiMode.edgeToEdge);
    await SystemChrome.setPreferredOrientations(
      [DeviceOrientation.portraitUp, DeviceOrientation.portraitDown],
    );
    setState(() {
      _isFullScreen = false;
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: Colors.black,
      body: SafeArea(
        child: GestureDetector(
          behavior: HitTestBehavior.opaque,
          onTap: () => setState(() => _isUiVisible = !_isUiVisible),
          child: Stack(
            children: [
              Center(
                child: AspectRatio(
                  aspectRatio: _controller.value.isInitialized
                      ? _controller.value.aspectRatio
                      : 16 / 9,
                  child: _controller.value.isInitialized
                      ? VideoPlayer(_controller)
                      : const Center(
                          child: CircularProgressIndicator(
                            color: Color(0xFF5BE4FF),
                          ),
                        ),
                ),
              ),
              Positioned.fill(
                child: Row(
                  children: [
                    _SkipZone(
                      alignment: Alignment.centerLeft,
                      icon: '10',
                      isVisible: _showSkipLeft,
                      onDoubleTap: () => _handleSkip(isForward: false),
                    ),
                    _SkipZone(
                      alignment: Alignment.centerRight,
                      icon: '10',
                      isVisible: _showSkipRight,
                      onDoubleTap: () => _handleSkip(isForward: true),
                      isForward: true,
                    ),
                  ],
                ),
              ),
              _buildOverlay(context),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildOverlay(BuildContext context) {
    return IgnorePointer(
      ignoring: !_isUiVisible,
      child: AnimatedOpacity(
        opacity: _isUiVisible ? 1 : 0,
        duration: const Duration(milliseconds: 200),
        child: Container(
          decoration: BoxDecoration(
            gradient: LinearGradient(
              begin: Alignment.topCenter,
              end: Alignment.bottomCenter,
              colors: [
                Colors.black.withOpacity(0.8),
                Colors.transparent,
                Colors.black.withOpacity(0.9),
              ],
            ),
          ),
          child: Column(
            children: [
              _buildTopBar(context),
              const Spacer(),
              _buildBottomControls(),
            ],
          ),
        ),
      ),
    );
  }

  Widget _buildTopBar(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        children: [
          IconButton(
            onPressed: () => _handleBackTap(context),
            icon: const Icon(Icons.arrow_back, color: Colors.white),
          ),
          const SizedBox(width: 8),
          Expanded(
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Text(
                  widget.movieTitle,
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.bold,
                    fontSize: 18,
                  ),
                ),
                const Text(
                  'Streaming via CineFlow Player',
                  style: TextStyle(color: Colors.white70, fontSize: 12),
                ),
              ],
            ),
          ),
          IconButton(
            onPressed: () {},
            icon: const Icon(Icons.cast, color: Colors.white),
          ),
          IconButton(
            onPressed: _toggleFullScreen,
            icon: Icon(
              _isFullScreen ? Icons.fullscreen_exit : Icons.fullscreen,
              color: Colors.white,
            ),
          ),
        ],
      ),
    );
  }

  Future<void> _handleBackTap(BuildContext context) async {
    if (_isFullScreen) {
      await _exitFullScreen();
    }
    if (context.mounted) {
      Navigator.pop(context);
    }
  }

  IconData _volumeIcon(double volume) {
    if (volume == 0) return Icons.volume_off;
    if (volume < 0.5) return Icons.volume_down;
    return Icons.volume_up;
  }

  Widget _buildBottomControls() {
    final position = _controller.value.position;
    final duration = _controller.value.duration;
    final progress = duration.inMilliseconds == 0
        ? 0.0
        : position.inMilliseconds / duration.inMilliseconds;
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 20),
      child: Column(
        crossAxisAlignment: CrossAxisAlignment.stretch,
        children: [
          Padding(
            padding: const EdgeInsets.symmetric(horizontal: 8),
            child: SliderTheme(
              data: SliderTheme.of(context).copyWith(
                trackHeight: 3,
                activeTrackColor: const Color(0xFFFF2E2E),
                inactiveTrackColor: Colors.white24,
                thumbColor: const Color(0xFFFF2E2E),
              ),
              child: Slider(
                value: progress.clamp(0.0, 1.0),
                onChanged: (value) {
                  final target = Duration(
                    milliseconds: (value * duration.inMilliseconds).toInt(),
                  );
                  _controller.seekTo(target);
                },
              ),
            ),
          ),
          const SizedBox(height: 8),
          Container(
            decoration: BoxDecoration(
              color: Colors.black.withOpacity(0.55),
              borderRadius: BorderRadius.circular(40),
            ),
            padding: const EdgeInsets.symmetric(horizontal: 12, vertical: 6),
            child: Row(
              children: [
                _circleButton(
                  icon: _controller.value.isPlaying
                      ? Icons.pause
                      : Icons.play_arrow_rounded,
                  onTap: _togglePlay,
                ),
                const SizedBox(width: 8),
                _circleButton(
                  icon: _volume == 0
                      ? Icons.volume_off
                      : Icons.volume_up_rounded,
                  onTap: () {
                    setState(() {
                      _volume = _volume == 0 ? 0.8 : 0;
                    });
                    _controller.setVolume(_volume);
                  },
                ),
                const SizedBox(width: 12),
                Text(
                  '${_formatDuration(position)} / ${_formatDuration(duration)}',
                  style: const TextStyle(
                    color: Colors.white,
                    fontWeight: FontWeight.w600,
                  ),
                ),
                const SizedBox(width: 12),
                Expanded(
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                        horizontal: 12, vertical: 6),
                    decoration: BoxDecoration(
                      color: Colors.white12,
                      borderRadius: BorderRadius.circular(20),
                    ),
                    child: Text(
                      widget.movieTitle,
                      maxLines: 1,
                      overflow: TextOverflow.ellipsis,
                      style: const TextStyle(
                        color: Colors.white,
                        fontSize: 13,
                      ),
                    ),
                  ),
                ),
                const SizedBox(width: 12),
                _iconButton(Icons.closed_caption, onTap: () {}),
                _iconButton(Icons.settings_outlined, onTap: () {}),
                _iconButton(Icons.cast, onTap: () {}),
                _iconButton(
                  _isFullScreen
                      ? Icons.fullscreen_exit
                      : Icons.fullscreen_outlined,
                  onTap: _toggleFullScreen,
                ),
              ],
            ),
          ),
        ],
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return GestureDetector(
      onTap: onTap,
      child: Container(
        width: 36,
        height: 36,
        decoration: const BoxDecoration(
          color: Colors.white24,
          shape: BoxShape.circle,
        ),
        child: Icon(icon, color: Colors.white),
      ),
    );
  }

  Widget _iconButton(IconData icon, {required VoidCallback onTap}) {
    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 4),
      child: IconButton(
        icon: Icon(icon, color: Colors.white70),
        onPressed: onTap,
      ),
    );
  }

  void _handleSkip({required bool isForward}) {
    if (!_controller.value.isInitialized) return;
    final offset = const Duration(seconds: 10);
    final target = isForward
        ? _controller.value.position + offset
        : _controller.value.position - offset;
    final duration = _controller.value.duration;
    final bounded = target < Duration.zero
        ? Duration.zero
        : (target > duration ? duration : target);
    _controller.seekTo(bounded);
    _showSkipIndicator(isForward: isForward);
  }

  void _showSkipIndicator({required bool isForward}) {
    _skipIndicatorTimer?.cancel();
    setState(() {
      if (isForward) {
        _showSkipRight = true;
      } else {
        _showSkipLeft = true;
      }
    });
    _skipIndicatorTimer = Timer(const Duration(milliseconds: 700), () {
      if (!mounted) return;
      setState(() {
        if (isForward) {
          _showSkipRight = false;
        } else {
          _showSkipLeft = false;
        }
      });
    });
  }

  String _formatDuration(Duration duration) {
    final minutes = duration.inMinutes.remainder(60).toString().padLeft(2, '0');
    final seconds =
        duration.inSeconds.remainder(60).toString().padLeft(2, '0');
    return '${duration.inHours > 0 ? '${duration.inHours}:' : ''}$minutes:$seconds';
  }
}

class _SkipZone extends StatelessWidget {
  const _SkipZone({
    required this.onDoubleTap,
    required this.isVisible,
    required this.alignment,
    this.isForward = false,
    this.icon = '10',
  });

  final VoidCallback onDoubleTap;
  final bool isVisible;
  final Alignment alignment;
  final bool isForward;
  final String icon;

  @override
  Widget build(BuildContext context) {
    return Expanded(
      child: GestureDetector(
        behavior: HitTestBehavior.translucent,
        onDoubleTap: onDoubleTap,
        child: AnimatedOpacity(
          opacity: isVisible ? 1 : 0,
          duration: const Duration(milliseconds: 150),
          child: Align(
            alignment: alignment,
            child: Container(
              padding: const EdgeInsets.all(16),
              decoration: BoxDecoration(
                color: Colors.black45,
                borderRadius: BorderRadius.circular(40),
              ),
              child: Row(
                mainAxisSize: MainAxisSize.min,
                children: [
                  if (!isForward)
                    const Icon(Icons.fast_rewind,
                        color: Colors.white, size: 28),
                  Text(
                    icon,
                    style: const TextStyle(
                      color: Colors.white,
                      fontWeight: FontWeight.bold,
                      fontSize: 18,
                    ),
                  ),
                  if (isForward)
                    const Icon(Icons.fast_forward,
                        color: Colors.white, size: 28),
                ],
              ),
            ),
          ),
        ),
      ),
    );
  }
}

