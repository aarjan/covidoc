import 'package:flutter/material.dart';
import 'package:carousel_slider/carousel_slider.dart';
import 'package:cached_network_image/cached_network_image.dart';
import 'package:photo_view/photo_view.dart';
import 'package:photo_view/photo_view_gallery.dart';

class ImageSlider extends StatefulWidget {
  const ImageSlider({
    Key? key,
    required this.images,
  }) : super(key: key);

  final List<String?> images;

  @override
  _ImageSliderState createState() => _ImageSliderState();
}

class _ImageSliderState extends State<ImageSlider> {
  int _current = 0;

  @override
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.only(bottom: 10),
      child: Stack(
        alignment: Alignment.bottomCenter,
        children: [
          CarouselSlider.builder(
            itemCount: widget.images.length,
            options: CarouselOptions(
              enableInfiniteScroll: false,
              onPageChanged: (index, reason) {
                setState(() {
                  _current = index;
                });
              },
              viewportFraction: 1,
            ),
            itemBuilder: (context, index, realIndex) {
              return ClipRRect(
                borderRadius: BorderRadius.circular(16),
                child: SizedBox(
                  width: double.infinity,
                  child: CachedNetworkImage(
                      imageUrl: widget.images[index]!, fit: BoxFit.cover),
                ),
              );
            },
          ),
          Visibility(
            visible: widget.images.length > 1,
            child: Row(
              mainAxisAlignment: MainAxisAlignment.center,
              children: widget.images.map((url) {
                final index = widget.images.indexOf(url);
                return Container(
                  width: 8,
                  height: 8,
                  margin: const EdgeInsets.symmetric(
                      vertical: 10.0, horizontal: 2.0),
                  decoration: BoxDecoration(
                    shape: BoxShape.circle,
                    border: Border.all(color: Colors.grey[300]!),
                    color: _current == index
                        ? Colors.grey[300]
                        : Colors.transparent,
                  ),
                );
              }).toList(),
            ),
          ),
        ],
      ),
    );
  }
}

class ImageGallerySlider extends StatelessWidget {
  final List<String?>? images;

  const ImageGallerySlider({Key? key, this.images}) : super(key: key);

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      width: double.infinity,
      height: 300,
      child: PhotoViewGallery.builder(
        scrollPhysics: const BouncingScrollPhysics(),
        builder: (BuildContext context, int index) {
          return PhotoViewGalleryPageOptions(
            imageProvider: CachedNetworkImageProvider(
              images![index]!,
            ),
            initialScale: PhotoViewComputedScale.contained,
            maxScale: 2.0,
            heroAttributes: PhotoViewHeroAttributes(tag: images![index]!),
          );
        },
        itemCount: images!.length,
        loadingBuilder: (context, event) => Center(
          child: CircularProgressIndicator(
            value: event == null
                ? 0
                : event.cumulativeBytesLoaded / event.expectedTotalBytes!,
          ),
        ),
      ),
    );
  }
}
