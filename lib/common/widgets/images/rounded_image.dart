import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:voice/common/widgets/shimmers/shimmer.dart';
import 'package:voice/utils/constants/sizes.dart';
import 'package:voice/utils/device/device_utility.dart';

class TRoundedImage extends StatelessWidget {
  const TRoundedImage({
    super.key,
    this.height,
    this.width,
    this.borderRadius = TSizes.md,
    required this.imageUrl,
    this.applyImageRadius = true,
    this.border,
    this.backgroundColor,
    this.fit = BoxFit.contain,
    this.padding,
    this.isNetworkImage = false,
    this.onPressed,
  });
  final double? height, width;
  final String imageUrl;
  final bool applyImageRadius;
  final BoxBorder? border;
  final Color? backgroundColor;
  final BoxFit? fit;
  final EdgeInsetsGeometry? padding;
  final bool isNetworkImage;
  final VoidCallback? onPressed;
  final double borderRadius;

  @override
  Widget build(BuildContext context) {
    return GestureDetector(
      onTap: onPressed,
      child: Container(
        height: height,
        width: width,
        padding: padding,
        decoration: BoxDecoration(
          border: border,
          color: backgroundColor,
          borderRadius: BorderRadius.circular(TSizes.md),
        ),
        child: Center(
          child: ClipRRect(
            borderRadius:
                (applyImageRadius)
                    ? BorderRadius.circular(borderRadius)
                    : BorderRadius.zero,
            child:
                isNetworkImage
                    ? CachedNetworkImage(
                      fit: fit,
                      imageUrl: imageUrl,
                      progressIndicatorBuilder:
                          (context, url, downloadProgress) => TShimmerEffect(
                            radius: applyImageRadius ? borderRadius : 0.0,
                            width: TDeviceUtils.getScreenWidth(context) * 0.9,
                            height: 190,
                          ),
                      errorWidget:
                          (context, url, downloadProgress) =>
                              const Icon(Icons.error),
                    )
                    : Image(image: AssetImage(imageUrl), fit: fit),
          ),
        ),
      ),
    );
  }
}
