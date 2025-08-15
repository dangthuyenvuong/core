import 'package:carousel_slider/carousel_slider.dart';
import 'package:flutter/material.dart';

class Carousel extends StatefulWidget {
  final List<Widget> children;
  final bool autoPlay;
  final Duration autoPlayInterval;
  final Curve autoPlayCurve;
  final Function(int, CarouselPageChangedReason)? onPageChanged;
  final bool enableInfiniteScroll;
  final double viewportFraction;
  final bool enableAutoPlay;
  final bool paginate;
  final bool padEnds;
  final double? height;
  final double? aspectRatio;

  Carousel({
    required this.children,
    this.autoPlay = true,
    this.autoPlayInterval = const Duration(seconds: 3),
    this.autoPlayCurve = Curves.fastOutSlowIn,
    this.enableInfiniteScroll = true,
    this.viewportFraction = 1,
    this.enableAutoPlay = true,
    this.paginate = true,
    this.onPageChanged,
    this.padEnds = false,
    this.height,
    this.aspectRatio,
  });

  @override
  State<Carousel> createState() => _CarouselState();
}

class _CarouselState extends State<Carousel> {
  int currentIndex = 0;

  void setCurrentIndex(int index) {
    setState(() {
      currentIndex = index;
    });
  }

  void callbackFunction(int index, CarouselPageChangedReason reason) {
    setCurrentIndex(index);
  }

  @override
  Widget build(BuildContext context) {
    return Stack(
      children: [
        CarouselSlider(
          options: CarouselOptions(
            height: widget.height,
            viewportFraction: widget.viewportFraction,
            enableInfiniteScroll: widget.enableInfiniteScroll,
            autoPlay: widget.autoPlay,
            autoPlayInterval: widget.autoPlayInterval,
            autoPlayCurve: widget.autoPlayCurve,
            onPageChanged: callbackFunction,
            padEnds: widget.padEnds,
            aspectRatio: widget.aspectRatio ?? 2.0,
          ),
          items: widget.children.map((e) {
            return Builder(
              builder: (BuildContext context) {
                return Container(
                    width: MediaQuery.of(context).size.width,
                    // margin: EdgeInsets.symmetric(horizontal: 5.0),
                    // decoration: BoxDecoration(color: Colors.amber),
                    child: e);
              },
            );
          }).toList(),
        ),
        widget.paginate
            ? Positioned(
                bottom: 15,
                left: 0,
                right: 0,
                child: Wrap(
                    alignment: WrapAlignment.center,
                    spacing: 5,
                    children: widget.children
                        .asMap()
                        .entries
                        .map((
                          e,
                        ) =>
                            AnimatedContainer(
                              duration: Duration(milliseconds: 300),
                              height: 10,
                              width: currentIndex == e.key ? 30 : 10,
                              decoration: BoxDecoration(
                                  borderRadius: BorderRadius.circular(10),
                                  color: Color(0xFF51F0BA).withOpacity(
                                      currentIndex == e.key ? 1 : 0.3),
                                  gradient: currentIndex == e.key
                                      ? LinearGradient(
                                          colors: [
                                            Color(0xFF51F0BA),
                                            Color(0xFF1EC28B)
                                          ],
                                          begin: Alignment.topCenter,
                                          end: Alignment.bottomCenter,
                                        )
                                      : null),
                            ))
                        .toList()),
              )
            : SizedBox()
      ],
    );
  }
}
