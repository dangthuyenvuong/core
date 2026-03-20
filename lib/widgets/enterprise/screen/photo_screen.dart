import 'package:core/constants.dart';
import 'package:core/core.dart';
import 'package:core/utils/img.dart';
import 'package:flutter/material.dart';

class PhotoScreen extends StatelessWidget {
  const PhotoScreen({
    super.key,
    this.photoUrl,
    this.photoHeight = 0.5,
    this.infoHeight = 0.7,
    this.radius,
    this.bgColor,
    required this.child,
    this.topLeading,
    this.heroTag,
    this.image,
  }) : assert(photoUrl != null || image != null,
            "photoUrl or image must be provided");
  final String? photoUrl;
  final double photoHeight;
  final String? heroTag;
  final double infoHeight;
  final double? radius;
  final Color? bgColor;
  final Widget? topLeading;
  final Widget child;
  final Widget? image;

  @override
  Widget build(BuildContext context) {
    final height = MediaQuery.of(context).size.height;
    final bg = Theme.of(context).scaffoldBackgroundColor;
    final onSurface = Theme.of(context).colorScheme.onSurface;

    return Scaffold(
      resizeToAvoidBottomInset: true,
      body: CustomScrollView(
        slivers: [
          SliverAppBar(
            expandedHeight: height * photoHeight,
            // collapsedHeight: height * 0.5,
            // pinned: true,
            // toolbarHeight: height * 0.1,
            // collapsedHeight: height * 0.2,
            backgroundColor: Colors.transparent,
            // shadowColor: Colors.transparent,
            // foregroundColor: Colors.transparent,
            // surfaceTintColor: Colors.transparent,
            // pinned: false,
            leading: SizedBox.shrink(),
            stretch: true,
            // pinned: true,
            // flexibleSpace: FlexibleSpaceBar(
            //   collapseMode: CollapseMode.parallax,

            //   title: null,
            //   stretchModes: [StretchMode.zoomBackground],
            //   background: Image.network(
            //     "https://i.pravatar.cc/900",
            //     fit: BoxFit.cover,
            //   ),
            // ),
            flexibleSpace: LayoutBuilder(
              builder: (context, constraints) {
                return Stack(
                  fit: StackFit.expand,
                  children: [
                    Hero(
                      tag: heroTag ?? photoUrl ?? image ?? "",
                      child: image ??
                          Core.imgHost(
                            photoUrl!,
                            fit: BoxFit.cover,
                            errorBuilder: (context, error, stackTrace) {
                              return Container(
                                color: onSurface.withAlpha(20),
                                child: Icon(
                                  Icons.image_not_supported,
                                  color: onSurface.withAlpha(100),
                                  size: 20,
                                ),
                              );
                            },
                          ),
                      // child: Image.network(
                      //   photoUrl,
                      //   fit: BoxFit.cover,
                      //   errorBuilder: (context, error, stackTrace) {
                      //     return Container(
                      //       color: onSurface.withAlpha(20),
                      //       child: Icon(
                      //         Icons.image_not_supported,
                      //         color: onSurface.withAlpha(100),
                      //         size: 20,
                      //       ),
                      //     );
                      //   },
                      // ),
                    ),
                    if (topLeading != null)
                      Positioned(
                          bottom: 0,
                          left: 0,
                          right: 0,
                          child: Container(
                            padding: EdgeInsets.only(
                              left: Spacing.medium,
                              right: Spacing.medium,
                              bottom: Spacing.large + (radius ?? 0),
                              top: Spacing.large,
                            ),
                            decoration: BoxDecoration(
                              gradient: LinearGradient(
                                colors: [
                                  Colors.black.withAlpha(200),
                                  Colors.black.withAlpha(0)
                                ],
                                begin: Alignment.bottomCenter,
                                end: Alignment.topCenter,
                              ),
                            ),
                            child: topLeading,
                          )),
                    if (radius != null)
                      Positioned(
                        bottom: 0,
                        left: 0,
                        right: 0,
                        child: Container(
                          height: radius!,
                          alignment: Alignment.topCenter,
                          decoration: BoxDecoration(
                            color: bgColor ?? bg,
                            borderRadius: BorderRadius.vertical(
                              top: Radius.circular(radius!),
                            ),
                          ),
                          child: Container(
                            width: 50,
                            height: 4,
                            margin: EdgeInsets.only(
                              top: Spacing.small,
                            ),
                            decoration: BoxDecoration(
                              color: onSurface.withAlpha(100),
                              borderRadius: BorderRadius.circular(25),
                            ),
                          ),
                        ),
                      ),
                  ],
                );
              },
            ),
          ),
          SliverToBoxAdapter(
            child: Container(
              // height: height * 0.7,
              decoration: BoxDecoration(
                color: bgColor ?? bg,
              ),
              child: child,
            ),
          ),
        ],
      ),
    );
  }
}
