import 'dart:io';
import 'dart:ui';
import 'package:flutter/foundation.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';

class DefaultAppBar extends StatefulWidget implements PreferredSizeWidget {
  const DefaultAppBar(
      {super.key,});

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
    return BlocBuilder<LoginBloc, LoginState>(
      builder: (context, state) {
        if (state.user == null) {
          return const Center(child: CircularProgressIndicator());
        } else {
          return AppBar(
            iconTheme: IconThemeData(
              color: Colors.white,
            ),
            backgroundColor: Colors.transparent,
            elevation: 0,
            toolbarHeight: 120,
            centerTitle: true,
            titleSpacing: 0,
            title: LayoutBuilder(
              builder: (context, constraints) {
              double width = constraints.maxWidth;
              double logoSize = width * 0.15;
              return Row(
                mainAxisAlignment: MainAxisAlignment.start,
                children: [
                SizedBox(width: width * 0.04),
                Container(
                  width: logoSize,
                  height: logoSize,
                  decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  boxShadow: [
                    BoxShadow(
                    color: Colors.black26,
                    blurRadius: 6,
                    offset: const Offset(2, 2),
                    ),
                  ],
                  ),
                  child: ClipOval(
                  child: Image.asset(
                    'assets/icon/logo.png',
                    fit: BoxFit.cover,
                    errorBuilder: (context, error, stackTrace) {
                    return Icon(Icons.error, color: Colors.red, size: logoSize * 0.5);
                    },
                  ),
                  ),
                ),
                SizedBox(width: width * 0.04),
                Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  mainAxisAlignment: MainAxisAlignment.center,
                  children: [
                  Text(
                    'Roll & Reserve',
                    style: TextStyle(
                    fontSize: width * 0.075,
                    fontWeight: FontWeight.w600,
                    color: Colors.white,
                    letterSpacing: 1.5,
                    ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.find_your_game_table,
                    style: TextStyle(
                    fontSize: width * 0.045,
                    color: Colors.white70,
                    ),
                  ),
                  ],
                ),
                ],
              );
              },
            ),
            actions: [
              Padding(
                padding: const EdgeInsets.only(right: 16.0),
                child: GestureDetector(
                    onTap: () {
                    Scaffold.of(context).openEndDrawer();
                  },
                  child: Container(
                    width: 50,
                    height: 50,
                    decoration: BoxDecoration(
                      shape: BoxShape.circle,
                      boxShadow: [
                        BoxShadow(
                          color: Colors.black38,
                          blurRadius: 6,
                          offset: const Offset(2, 2),
                        ),
                      ],
                    ),
                    child: ClipOval(
                      child: Image(
                        fit: BoxFit.cover,
                        image: kIsWeb
                            ? MemoryImage(state.user!.avatar!)
                            : FileImage(File(state.user!.avatar.path))
                                as ImageProvider,
                        errorBuilder: (context, error, stackTrace) {
                          return Icon(Icons.person, color: Colors.white54);
                        },
                      ),
                    ),
                  ),
                ),
              ),
            ],
            flexibleSpace: Container(
              decoration: BoxDecoration(
                gradient: LinearGradient(
                  colors: [
                    Colors.blue.shade800,
                    Colors.blueAccent.shade400,
                  ],
                  begin: Alignment.topLeft,
                  end: Alignment.bottomRight,
                ),
                image: const DecorationImage(
                  image: AssetImage('assets/images/appbar_back.jpg'),
                  fit: BoxFit.cover,
                  colorFilter: ColorFilter.mode(
                    Colors.black45,
                    BlendMode.darken,
                  ),
                ),
              ),
              child: ClipRRect(
                borderRadius: const BorderRadius.only(
                  bottomLeft: Radius.circular(16),
                  bottomRight: Radius.circular(16),
                ),
                child: BackdropFilter(
                  filter: ImageFilter.blur(sigmaX: 3, sigmaY: 3),
                  child: Container(
                    alignment: Alignment.center,
                    color: Colors.black.withOpacity(0.2),
                  ),
                ),
              ),
            ),
          );
        }
      },
    );
  }
}
