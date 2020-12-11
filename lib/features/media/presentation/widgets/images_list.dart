import 'package:dsc_platform/core/utils/strings.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:flutter_svg/flutter_svg.dart';

import '../blocs/image/image_bloc.dart';
import 'image_card.dart';

class ImagesList extends StatelessWidget {
  @override
  Widget build(BuildContext context) {
    return BlocConsumer<ImageBloc, ImageState>(
      listener: (context, state) {
        if (state is ImageFailedDeleted)
          FlushbarHelper.createError(
            title: Strings.image,
            message: state.failure.details,
          ).show(context);
      },
      builder: (context, state) {
        if (state is ImagesFetchedSuccessful) {
          if (state.images.isEmpty)
            return Center(
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  SvgPicture.asset(
                    'assets/images/annotation.svg',
                    height: 150,
                  ),
                  Text('No Images..')
                ],
              ),
            );

          return GridView.builder(
            physics: BouncingScrollPhysics(),
            padding: const EdgeInsets.all(8.0),
            itemCount: state.images.length,
            gridDelegate:
                SliverGridDelegateWithFixedCrossAxisCount(crossAxisCount: 3),
            itemBuilder: (BuildContext context, int index) {
              return ImageCard(
                image: state.images[index],
              );
            },
          );
        }
        return Center(
          child: CircularProgressIndicator(),
        );
      },
    );
  }
}
