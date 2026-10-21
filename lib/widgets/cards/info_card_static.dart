import 'package:flutter/material.dart';

class InfoCardStatic extends StatefulWidget {
  final String? title;
  final String? value;
  final IconData? icon;

  final double? height;
  final double? width;

  final Widget? child;

  const InfoCardStatic({
    super.key,

    this.title,
    this.value,
    this.icon,

    this.height,
    this.width,

    this.child,
  });

  @override
  State<InfoCardStatic> createState() => _InfoCardStaticState();
}

class _InfoCardStaticState extends State<InfoCardStatic> {
  @override
  void initState() {
    super.initState();
  }

  @override
  Widget build(BuildContext context) {
    final screenWidth = MediaQuery.of(context).size.width;
    final screenHeight = MediaQuery.of(context).size.height;

    final titleFontSize = screenWidth * 0.045;
    final valueFontSize = screenWidth * 0.035;

    final iconSize = screenWidth * 0.08;

    final cardPadding = screenWidth * 0.04;

    return SizedBox(
      height: widget.height ?? screenHeight * 0.18,
      width: widget.width ?? screenWidth * 0.9,

      child: Card(
        color: const Color.fromARGB(213, 172, 218, 255),

        elevation: 8,

        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(screenWidth * 0.05),
        ),

        child:
            widget.child ??
            Padding(
              padding: EdgeInsets.all(cardPadding),

              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,

                crossAxisAlignment: CrossAxisAlignment.start,

                children: [
                  if (widget.icon != null) Icon(widget.icon, size: iconSize),

                  if (widget.icon != null)
                    SizedBox(height: screenHeight * 0.03),

                  if (widget.title != null)
                    Text(
                      widget.title!,

                      maxLines: 2,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: titleFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),

                  if (widget.value != null)
                    Text(
                      widget.value!,

                      maxLines: 3,

                      overflow: TextOverflow.ellipsis,

                      style: TextStyle(
                        fontSize: valueFontSize,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                ],
              ),
            ),
      ),
    );
  }
}
