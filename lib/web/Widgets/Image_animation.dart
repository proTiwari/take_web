import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:full_screen_image_null_safe/full_screen_image_null_safe.dart';

class ImageAnimation extends StatefulWidget {
  var detail;
  ImageAnimation(
    this.detail, {
    Key? key,
  }) : super(key: key);

  @override
  State<ImageAnimation> createState() => _ImageAnimationState();
}

class _ImageAnimationState extends State<ImageAnimation> {
  late PageController _pageController;

  List<dynamic> images = [];

  int activePage = 1;

  @override
  void initState() {
    images = widget.detail["propertyimage"];
    super.initState();
    _pageController = PageController(viewportFraction: 0.8, initialPage: 1);
  }

  @override
  Widget build(BuildContext context) {
    return Column(
      children: [
        SizedBox(
          width: MediaQuery.of(context).size.width,
          height: 350,
          child: PageView.builder(
              itemCount: widget.detail['propertyimage'].length,
              pageSnapping: true,
              controller: _pageController,
              onPageChanged: (page) {
                setState(() {
                  activePage = page;
                });
              },
              itemBuilder: (context, pagePosition) {
                bool active = pagePosition == activePage;
                return FullScreenWidget(
                    child: Container(
                  margin: EdgeInsets.all(10),
                  child: Image(
                    height: 200,
                    fit: BoxFit.cover,
                    image: CachedNetworkImageProvider(
                      widget.detail["propertyimage"][pagePosition],
                    ),
                  ),
                  // child: Image.network(
                  //   widget.detail["propertyimage"][pagePosition],
                  //   fit: BoxFit.cover,
                  // ),
                ));
              }),
        ),
        Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children:
                indicators(widget.detail["propertyimage"].length, activePage))
      ],
    );
  }
}

AnimatedContainer slider(images, pagePosition, active) {
  double margin = active ? 10 : 20;

  return AnimatedContainer(
    duration: Duration(milliseconds: 500),
    curve: Curves.easeInOutCubic,
    margin: EdgeInsets.all(margin),
    decoration: BoxDecoration(
        image: DecorationImage(image: NetworkImage(images[pagePosition]))),
  );
}

imageAnimation(PageController animation, images, pagePosition) {
  return AnimatedBuilder(
    animation: animation,
    builder: (context, widget) {
      print(pagePosition);

      return SizedBox(
        width: 200,
        height: 200,
        child: widget,
      );
    },
    child: Container(
      margin: const EdgeInsets.all(10),
      child: Image.network(images[pagePosition]),
    ),
  );
}

List<Widget> indicators(imagesLength, currentIndex) {
  return List<Widget>.generate(imagesLength, (index) {
    return Container(
      margin: EdgeInsets.all(3),
      width: 10,
      height: 10,
      decoration: BoxDecoration(
          color: currentIndex == index ? Colors.black : Colors.black26,
          shape: BoxShape.circle),
    );
  });
}
