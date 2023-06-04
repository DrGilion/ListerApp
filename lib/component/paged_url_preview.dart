import 'package:any_link_preview/any_link_preview.dart';
import 'package:flutter/material.dart';
import 'package:lister_app/generated/l10n.dart';
import 'package:smooth_page_indicator/smooth_page_indicator.dart';

class PagedUrlPreview extends StatefulWidget {
  final List<String> urls;

  const PagedUrlPreview({super.key, required this.urls});

  @override
  State<PagedUrlPreview> createState() => _PagedUrlPreviewState();
}

class _PagedUrlPreviewState extends State<PagedUrlPreview> {
  final pageController = PageController(viewportFraction: 0.8, keepPage: true);

  @override
  Widget build(BuildContext context) {
    return Column(
      mainAxisSize: MainAxisSize.min,
      mainAxisAlignment: MainAxisAlignment.center,
      children: [
        SizedBox(
          height: 120,
          child: PageView.builder(
              controller: pageController,
              itemCount: widget.urls.length,
              itemBuilder: (context, index) {
                final url = widget.urls[index];
                return Padding(
                  padding: const EdgeInsets.symmetric(horizontal: 4.0),
                  child: AnyLinkPreview(
                    link: url,
                    displayDirection: UIDirection.uiDirectionHorizontal,
                    showMultimedia: true,
                    bodyMaxLines: 3,
                    previewHeight: 105,
                    bodyTextOverflow: TextOverflow.ellipsis,
                    titleStyle: const TextStyle(fontWeight: FontWeight.bold, fontSize: 15),
                    bodyStyle: const TextStyle(color: Colors.grey, fontSize: 12),
                    errorBody: url,
                    errorTitle: url,
                    errorWidget: Container(
                      color: Colors.grey[300],
                      padding: const EdgeInsets.all(18),
                      child: Center(child: Text(Translations.of(context).url_preview_error(url))),
                    ),
                    cache: const Duration(days: 7),
                    backgroundColor: Colors.grey[300],
                    borderRadius: 16,
                    boxShadow: const [BoxShadow(blurRadius: 3, color: Colors.grey)],
                  ),
                );
              }),
        ),
        const SizedBox(height: 8),
        SmoothPageIndicator(
          controller: pageController,
          count: widget.urls.length,
          effect: const ExpandingDotsEffect(),
          onDotClicked: (index) {
            setState(() {
              pageController.animateToPage(index, duration: const Duration(milliseconds: 300), curve: Curves.easeIn);
            });
          },
        ),
      ],
    );
  }
}
