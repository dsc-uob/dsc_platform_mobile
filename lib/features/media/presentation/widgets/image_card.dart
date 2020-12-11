import 'package:cached_network_image/cached_network_image.dart';
import 'package:flushbar/flushbar_helper.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:gallery_saver/gallery_saver.dart';

import '../../../../core/constant.dart';
import '../../domain/entities.dart';
import '../blocs/image/image_bloc.dart';

class ImageCard extends StatelessWidget {
  final DImage image;

  const ImageCard({Key key, this.image}) : super(key: key);
  @override
  Widget build(BuildContext context) {
    return InkWell(
      onTap: () {
        showDialog(
          context: context,
          builder: (cxt) {
            return Container(
              padding: const EdgeInsets.all(20.0),
              child: Column(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Expanded(
                    flex: 8,
                    child: Image(
                      image: CachedNetworkImageProvider(image.url),
                      fit: BoxFit.contain,
                    ),
                  ),
                  Expanded(
                    flex: 1,
                    child: Container(
                      padding: const EdgeInsets.all(8.0),
                      decoration: BoxDecoration(
                        color: Colors.white,
                        borderRadius: BorderRadius.circular(15),
                      ),
                      child: Row(
                        mainAxisAlignment: MainAxisAlignment.spaceEvenly,
                        children: [
                          Material(
                            child: IconButton(
                              icon: Icon(Icons.save_alt),
                              onPressed: () async {
                                final isSaved = await GallerySaver.saveImage(
                                  image.url,
                                  albumName: DSC_PLATFORM,
                                );
                                Navigator.pop(cxt);
                                if (isSaved)
                                  FlushbarHelper.createSuccess(
                                    message: 'Image Saved Successful!',
                                  ).show(context);
                              },
                            ),
                          ),
                          Material(
                            child: IconButton(
                              icon: Icon(Icons.delete),
                              onPressed: () {
                                BlocProvider.of<ImageBloc>(context)
                                    .add(DeleteImage(image.id));
                                Navigator.pop(cxt);
                              },
                            ),
                          ),
                          Material(
                            child: IconButton(
                              icon: Icon(Icons.close),
                              onPressed: () {
                                Navigator.pop(cxt);
                              },
                            ),
                          ),
                        ],
                      ),
                    ),
                  ),
                ],
              ),
            );
          },
        );
      },
      child: Image(
        image: CachedNetworkImageProvider(image.url),
      ),
    );
  }
}
