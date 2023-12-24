import 'package:flutter/material.dart';
import 'package:kartal/kartal.dart';

class SliderDeneme extends StatefulWidget {
  const SliderDeneme({super.key});

  @override
  State<SliderDeneme> createState() => _SliderDenemeState();
}

class _SliderDenemeState extends State<SliderDeneme> {
  final PageController _pageController = PageController();
  int _currentPage = 0;

  final List<String> _images = [
    'https://firebasestorage.googleapis.com/v0/b/alergenproject.appspot.com/o/alerjeniki.jpeg?alt=media&token=649bb6cb-a4c3-4b52-ab74-cf25f6386f22',
    'https://firebasestorage.googleapis.com/v0/b/alergenproject.appspot.com/o/alerjenbir.jpeg?alt=media&token=982fa935-9b65-4f4d-aa9a-3d141a35d990',
    'https://firebasestorage.googleapis.com/v0/b/alergenproject.appspot.com/o/alerjen2.jpeg?alt=media&token=3d6aa022-e51e-4ded-8fb9-12cbd8891ced',
    'https://firebasestorage.googleapis.com/v0/b/alergenproject.appspot.com/o/latex.jpeg?alt=media&token=7c425337-95c9-4698-8dd2-85b59f10375b',
  ];

  @override
  void initState() {
    super.initState();
    _pageController.addListener(() {
      setState(() {
        _currentPage = _pageController.page!.round();
      });
    });
  }

  @override
  Widget build(BuildContext context) {
    return SizedBox(
      height: context.sized.dynamicHeight(.3),
      width: MediaQuery.of(context).size.width,
      child: PageView.builder(
        pageSnapping: true,
        controller: _pageController,
        itemCount: _images.length,
        itemBuilder: (context, index) {
          return Stack(
            children: [
              Center(
                child: Image.network(
                  _images[index],
                  fit: BoxFit.cover,

                  // alignment: Alignment.center,
                ),
              ),
              Positioned(
                  bottom: 10,
                  left: 155,
                  child: Center(
                    child: Row(
                      mainAxisAlignment: MainAxisAlignment.center,
                      children: _buildPageIndicator(),
                    ),
                  ))
            ],
          );
        },
      ),
    );
  }

  List<Widget> _buildPageIndicator() {
    List<Widget> indicators = [];
    for (var i = 0; i < _images.length; i++) {
      indicators.add(Container(
        width: 10,
        height: 10,
        margin: const EdgeInsets.symmetric(horizontal: 5),
        decoration: BoxDecoration(
          shape: BoxShape.circle,
          color: _currentPage == i ? Colors.blue : Colors.grey,
        ),
      ));
    }
    return indicators;
  }
}
