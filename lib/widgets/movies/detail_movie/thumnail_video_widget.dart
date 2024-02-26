import 'package:flutter/material.dart';
import 'package:provider/provider.dart';
import 'package:rabka_movie/provider/isVideoPlay_provider.dart';
import 'package:rabka_movie/utils/colors.dart';

class ThumbnailVideoWidget extends StatefulWidget {
  final String keyVideo;

  const ThumbnailVideoWidget({super.key, required this.keyVideo});

  @override
  State<ThumbnailVideoWidget> createState() => _ThumbnailVideoWidgetState();
}

class _ThumbnailVideoWidgetState extends State<ThumbnailVideoWidget> {
  @override
  Widget build(BuildContext context) {
    final isVideoPlayProvider = Provider.of<IsVideoPlayProvider>(context);
    bool _isVidPlay = isVideoPlayProvider.isVideoPlay;

    return Stack(
      children: [
        Image.network(
          'https://img.youtube.com/vi/${widget.keyVideo}/0.jpg',
          fit: BoxFit.cover,
          width: double.infinity,
          height: double.infinity,
        ),
        Positioned(
          bottom: 20,
          right: 20,
          child: InkWell(
            onTap: () {
              setState(() {
                isVideoPlayProvider.setIsVideoPlay(_isVidPlay);
              });
            },
            child: Container(
              width: 50,
              height: 50,
              decoration: const BoxDecoration(
                shape: BoxShape.circle,
                color: primaryColor, // Sesuaikan warna sesuai kebutuhan
              ),
              child: const Icon(
                Icons.play_arrow,
                color: Colors.white, // Sesuaikan warna ikon sesuai kebutuhan
                size: 40, // Sesuaikan ukuran ikon sesuai kebutuhan
              ),
            ),
          ),
        )
      ],
    );
  }
}
