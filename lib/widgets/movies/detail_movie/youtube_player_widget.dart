import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/models/movie_model.dart';
import 'package:rabka_movie/provider/isVideoPlay_provider.dart';
import 'package:rabka_movie/utils/colors.dart';
import 'package:youtube_player_flutter/youtube_player_flutter.dart';

class YoutubePlayerWidget extends StatefulWidget {
  Map<String, dynamic>? videoMovieData;

  final int indexVideoMovie;

  YoutubePlayerWidget({
    super.key,
    required this.indexVideoMovie,
    required this.videoMovieData,
  });

  @override
  State<YoutubePlayerWidget> createState() => _YoutubePlayerWidgetState();
}

class _YoutubePlayerWidgetState extends State<YoutubePlayerWidget> {
  @override
  Widget build(BuildContext context) {
    final isVideoPlayProvider = Provider.of<IsVideoPlayProvider>(context);
    bool _isVidPlay = isVideoPlayProvider.isVideoPlay;

    return YoutubePlayerBuilder(
      onExitFullScreen: () {
        // Do something when exit full screen
      },
      player: YoutubePlayer(
        controller: YoutubePlayerController(
          initialVideoId: widget.videoMovieData?["results"]
              [widget.indexVideoMovie]["key"],
          flags: const YoutubePlayerFlags(
            mute: false,
            autoPlay: true,
            disableDragSeek: false,
            loop: false,
            isLive: false,
            forceHD: false,
            enableCaption: true,
          ),
        ),
        showVideoProgressIndicator: true,
        progressIndicatorColor: bgPrimaryColor,
        progressColors: const ProgressBarColors(
          handleColor: primaryColor,
          playedColor: primaryColor,
        ),
        topActions: <Widget>[
          Expanded(
            child: Row(
              mainAxisAlignment: MainAxisAlignment.spaceBetween,
              children: [
                IconButton(
                  icon: const Icon(
                    Icons.arrow_back_ios,
                    color: bgPrimaryColor,
                    size: 18.0,
                  ),
                  onPressed: () {
                    setState(() {
                      isVideoPlayProvider.setIsVideoPlay(_isVidPlay);
                    });
                  },
                ),
                Container(
                  width: MediaQuery.of(context).size.width * 0.8,
                  padding: const EdgeInsets.only(right: 8),
                  child: Text(
                    widget.videoMovieData?["results"][widget.indexVideoMovie]
                        ["name"],
                    overflow: TextOverflow.ellipsis,
                    maxLines: 1,
                    style: const TextStyle(
                      color: bgPrimaryColor,
                      fontSize: 18.0,
                      fontWeight: FontWeight.w500,
                    ),
                  ),
                ),
              ],
            ),
          ),
        ],
        onReady: () {
          // Do something when player is ready.
        },
        onEnded: (data) {
          // Do something when video ends.
        },
      ),
      builder: (context, player) {
        return player;
      },
    );
  }
}
