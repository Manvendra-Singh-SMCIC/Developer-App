import 'dart:async';

import 'package:flutter/material.dart';

import 'package:video_player/video_player.dart';

import '../utils/constant.dart';

class VideoPlayerScreen extends StatefulWidget {
  const VideoPlayerScreen(
      {super.key, required this.videoUrl, required this.height});
  final double height;
  final String videoUrl;

  @override
  State<VideoPlayerScreen> createState() => _VideoPlayerScreenState();
}

class _VideoPlayerScreenState extends State<VideoPlayerScreen> {
  late VideoPlayerController _controller;
  late Future<void> _initializeVideoPlayerFuture;

  @override
  void initState() {
    super.initState();

    _controller = VideoPlayerController.network(
      widget.videoUrl,
    );

    _initializeVideoPlayerFuture = _controller.initialize();

    _controller.setLooping(true);
  }

  String nowTime = '';
  // void checkTimer() {
  //   if (_controller.value.position == _controller.value.duration) {
  //     setState(() {
  //       log('message');
  //       Duration duration = Duration(
  //           milliseconds: _controller.value.position.inMilliseconds.round());

  //       nowTime = [duration.inHours, duration.inMinutes, duration.inSeconds]
  //           .map((seg) => seg.remainder(60).toString().padLeft(2, '0'))
  //           .join(':');
  //       log(nowTime.toString());
  //     });
  //   }
  // }

  @override
  void dispose() {
    _controller.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      body: Stack(
        children: [
          SizedBox(
            height: height(context),
            child: FutureBuilder(
              future: _initializeVideoPlayerFuture,
              builder: (context, snapshot) {
                if (snapshot.connectionState == ConnectionState.done) {
                  return Container(
                    child: VideoPlayer(_controller),
                  );
                } else {
                  return const Center(
                    child: CircularProgressIndicator(),
                  );
                }
              },
            ),
          ),
          Positioned(
            top: height(context) * 0.09,
            left: width(context) * 0.31,
            child: Row(
              children: [
                Icon(
                  Icons.replay_10_outlined,
                  color: white,
                ),
                InkWell(
                  onTap: () {
                    setState(() {
                      if (_controller.value.isPlaying) {
                        _controller.pause();
                      } else {
                        _controller.play();
                      }
                    });
                  },
                  child: Container(
                    height: 50,
                    margin: EdgeInsets.all(10),
                    width: 50,
                    decoration: kFillBoxDecoration(
                      1,
                      black,
                      50,
                    ),
                    child: Center(
                      child: Icon(
                        _controller.value.isPlaying
                            ? Icons.pause
                            : Icons.play_arrow,
                        size: 30,
                        color: white,
                      ),
                    ),
                  ),
                ),
                Icon(
                  Icons.forward_10_rounded,
                  color: white,
                ),
              ],
            ),
          ),
          // Text(" Duration ${_controller.value.duration.toString()}")s
        ],
      ),
    );
  }

  // Widget buildVideo() => VideoPlayer(_controller);
}
