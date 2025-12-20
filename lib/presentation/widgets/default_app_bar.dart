import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppBar({super.key});

  @override
  State<DefaultAppBar> createState() => _DefaultAppBarState();

  @override
  Size get preferredSize => const Size.fromHeight(120);
}

class _DefaultAppBarState extends State<DefaultAppBar> {
  @override
  /// Initializes the state of the app bar.
  ///
  /// It calls the [State.initState] method of the parent class.
  ///
  /// This method is called when the widget is inserted into the tree.
  void initState() {
    super.initState();
  }

  @override
  /// Builds the app bar with the logo and the user image.
  ///
  /// If the user is null, it shows a [CircularProgressIndicator].
  /// If the user is not null, it shows a custom app bar with the logo and the
  /// user image.
  ///
  /// The app bar has a gradient background and a shadow.
  ///
  /// The logo is a circle with a box shadow.
  ///
  /// The user image is a circle with a box shadow and a tap gesture to open the
  /// end drawer.
  ///
  /// The app bar also has a flexible space with a gradient and a shadow.
  /// The flexible space has an image with a color filter to darken it.
  /// The flexible space also has a child with a blurred background and a
  /// rounded corners.
  Widget build(BuildContext context) {
    return Padding(
      padding: const EdgeInsets.fromLTRB(0, 0, 0, 8.0),
      child: Container(
        decoration: BoxDecoration(
          borderRadius: const BorderRadius.only(
            bottomLeft: Radius.circular(24),
            bottomRight: Radius.circular(24),
          ),
        ),
        child: AppBar(
          iconTheme: IconThemeData(color: Colors.white),
          backgroundColor: Colors.transparent,
          elevation: 0,
          toolbarHeight: 120,
          centerTitle: true,
          titleSpacing: 0,
          title: LayoutBuilder(
            builder: (context, constraints) {
              double width = constraints.maxWidth;
              return Row(
                mainAxisAlignment: MainAxisAlignment.center,
                children: [
                  Column(
                    crossAxisAlignment: CrossAxisAlignment.center,
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Text(
                        'GenUI Roll',
                        style: TextStyle(
                          fontSize: width * 0.075,
                          fontWeight: FontWeight.w600,
                          color: Colors.white,
                          letterSpacing: 1.5,
                        ),
                      ),
                    ],
                  ),
                ],
              );
            },
          ),
          flexibleSpace: Container(
            decoration: BoxDecoration(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              image: const DecorationImage(
                image: AssetImage('assets/images/appbar_back.png'),
                fit: BoxFit.cover,
                colorFilter: ColorFilter.mode(Colors.black45, BlendMode.darken),
              ),
            ),
            child: ClipRRect(
              borderRadius: const BorderRadius.only(
                bottomLeft: Radius.circular(24),
                bottomRight: Radius.circular(24),
              ),
              child: BackdropFilter(
                filter: ImageFilter.blur(sigmaX: 0.5, sigmaY: 0.5),
                child: Container(
                  alignment: Alignment.center,
                  color: Colors.black.withOpacity(0.2),
                ),
              ),
            ),
          ),
        ),
      ),
    );
  }
}
