
import 'package:cached_network_image/cached_network_image.dart';
import 'package:flutter/material.dart';
import 'package:vivo_vivo_app/src/domain/models/user_pref_provider.dart';

class UIComponents {

  static Widget photo(Size size, UserAuth person) => Padding(
        padding: const EdgeInsets.only(top: 10, right: 10, bottom: 10),
        child: ClipOval(
          child: CachedNetworkImage(
            width: size.width * 0.2,
            height: size.width * 0.2,
            fit: BoxFit.cover,
            imageUrl:
                person.avatar,
            errorWidget: (context, url, error) => const Icon(Icons.error_outline),
            placeholder: (context, url) => const CircularProgressIndicator(),
          ),
        ),
      );
}


