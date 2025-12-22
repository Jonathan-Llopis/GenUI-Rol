// ignore_for_file: unused_field

import 'dart:typed_data';

import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:image_picker/image_picker.dart';
import 'package:permission_handler/permission_handler.dart';
import 'package:rol_genui/l10n/l10n/app_localizations.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_bloc.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_event.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_state.dart';
import 'package:speech_to_text/speech_recognition_result.dart';
import 'package:speech_to_text/speech_to_text.dart';

class InputTextImage extends StatefulWidget {
  const InputTextImage(
      {super.key, required this.focusNode, required this.isAssitant});

  final bool isAssitant;
  final FocusNode focusNode;

  @override
  State<InputTextImage> createState() => _InputTextState();
}

class _InputTextState extends State<InputTextImage> {
  final SpeechToText _speechToText = SpeechToText();
  bool _speechEnabled = false;
  bool _isAvailable = false;
  final TextEditingController textController = TextEditingController();

  @override

  /// Initializes the state of the widget by performing the following actions:
  ///
  /// 1. Calls the superclass's initState method to ensure proper
  ///    initialization of the inherited properties and functionality.
  /// 2. Checks for necessary permissions related to the microphone,
  ///    requesting them if they are not already granted.
  /// 3. Initializes the speech-to-text functionality to enable speech
  ///    recognition features.
  /// 4. Checks the availability of the speech recognition service and
  ///    updates the state accordingly.

  void initState() {
    super.initState();
    _checkPermissions();
    _initSpeech();
    _checkAvailability();
  }

  /// Checks and requests microphone permissions.
  ///
  /// This function checks the current status of the microphone permission.
  /// If the permission is not granted, it requests the user for the
  /// permission. If the permission is denied permanently, it opens the
  /// app settings to let the user manually enable the permission.
  ///
  /// Updates the widget's state after checking the permissions.

  void _checkPermissions() async {
    final status = await Permission.microphone.status;

    if (!status.isGranted) {
      final result = await Permission.microphone.request();
      if (result.isDenied) {
        if (result.isPermanentlyDenied) {
          await openAppSettings();
        }
      }
    }

    setState(() {});
  }

  /// Initializes the speech-to-text functionality to enable speech recognition
  /// features.
  ///
  /// This function initializes the speech-to-text service and sets the
  /// [_speechEnabled] property to true or false, depending on whether the
  /// service can be initialized successfully. If the service fails to
  /// initialize, it sets the property to false. The state of the widget is
  /// updated after initializing the service.
  void _initSpeech() async {
    try {
      _speechEnabled = await _speechToText.initialize(
        onStatus: (status) => setState(() {}),
      );
    } catch (e) {
      _speechEnabled = false;
    }
    setState(() {});
  }

  /// Checks the availability of the speech recognition service and updates the
  /// state accordingly.
  ///
  /// This function checks the availability of the speech recognition service
  /// and updates the [_isAvailable] property with the result. The state of
  /// the widget is updated after checking the availability.
  void _checkAvailability() async {
    _isAvailable = _speechToText.isAvailable;

    setState(() {});
  }

  /// Starts listening for speech recognition.
  ///
  /// This function starts listening for speech recognition if the
  /// [_speechEnabled] property is true. It sets the locale to 'es_ES',
  /// listens for 30 seconds, and enables partial results. After starting
  /// the listening process, it updates the state of the widget.
  void _startListening() async {
    if (!_speechEnabled) return;

    await _speechToText.listen(
      onResult: _onSpeechResult,
      localeId: 'es_ES',
      listenFor: const Duration(seconds: 30),
      partialResults: true,
    );
    setState(() {});
  }

  /// Stops listening for speech recognition.
  ///
  /// This function stops the speech recognition service from listening for
  /// speech. After stopping the service, it updates the state of the widget.
  void _stopListening() async {
    await _speechToText.stop();
    setState(() {});
  }

  /// Handles the speech recognition result.
  ///
  /// This function is called when the speech recognition service recognizes
  /// speech. It updates the text controller with the recognized words and
  /// checks if the result is final. If the result is final, it will update the
  /// text controller with the recognized words. The state of the widget is
  /// updated after handling the result.
  void _onSpeechResult(SpeechRecognitionResult result) {
    setState(() {
      textController.text = result.recognizedWords;
      if (result.finalResult) {
        textController.text = result.recognizedWords;
      }
    });
  }

  final ImagePicker _picker = ImagePicker();
  XFile? _image;
  @override

  /// Builds the input field widget for chat interaction.
  ///
  /// This widget contains a [TextField] for user input, an image picker button,
  /// a speech-to-text button, and a send button. The [TextField] allows for text
  /// input and handles submission by sending the message through the [ChatBloc].
  ///
  /// The image picker button opens a modal bottom sheet for selecting images,
  /// while the speech-to-text button toggles listening for voice input.
  ///
  /// The send button dispatches a message to the [ChatBloc], optionally with
  /// attached image bytes if an image is selected. The widget supports animated
  /// transitions to indicate loading states and button actions.

  Widget build(BuildContext context) {
    TextEditingController textController = TextEditingController();
    final theme = Theme.of(context);
    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        return Card(
          margin: EdgeInsets.zero,
          child: Padding(
            padding: const EdgeInsets.symmetric(
              vertical: 10,
              horizontal: 15,
            ),
            child: Row(
              children: [
                Expanded(
                  child: ConstrainedBox(
                    constraints: BoxConstraints(
                      maxHeight: 150,
                    ),
                    child: TextField(
                      controller: textController,
                      focusNode: widget.focusNode,
                      maxLines: null,
                      style: theme.textTheme.bodyLarge,
                      decoration: InputDecoration(
                        hintText: AppLocalizations.of(context)!.send_message,
                        hintStyle: theme.textTheme.bodyLarge?.copyWith(
                          color: theme.colorScheme.onSurface.withOpacity(0.4),
                        ),
                        border: OutlineInputBorder(
                          borderRadius: BorderRadius.circular(50),
                          borderSide: BorderSide.none,
                        ),
                        contentPadding: const EdgeInsets.symmetric(
                            horizontal: 16, vertical: 14),
                        fillColor: Colors.grey[200],
                        filled: true,
                      ),
                      onSubmitted: (_) {
                        context.read<ChatBloc>().add(
                              OnChatGeminiSendMessage(
                                message: textController.text,
                              ),
                            );
                        textController.clear();
                        widget.focusNode.requestFocus();
                      },
                    ),
                  ),
                ),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: state.isLoading
                      ? null
                      : Stack(
                          children: [
                            IconButton(
                              onPressed: () {
                                showModalBottomSheet(
                                  context: context,
                                  builder: (context) => bottomSheet(),
                                );
                              },
                              icon: Icon(Icons.image, color: Colors.white),
                              style: IconButton.styleFrom(
                                backgroundColor: theme.colorScheme.primary,
                                shape: const CircleBorder(),
                                padding: const EdgeInsets.all(16),
                              ),
                            ),
                            if (_image != null)
                              Positioned(
                                right: 8,
                                top: 8,
                                child: Container(
                                  width: 8,
                                  height: 8,
                                  decoration: BoxDecoration(
                                    color: Colors.red,
                                    shape: BoxShape.circle,
                                  ),
                                ),
                              ),
                          ],
                        ),
                ),
                const SizedBox(width: 8),
                AnimatedSwitcher(
                  duration: const Duration(milliseconds: 200),
                  child: state.isLoading
                      ? null
                      : IconButton(
                          onPressed: _speechEnabled
                              ? (_speechToText.isListening
                                  ? _stopListening
                                  : _startListening)
                              : null,
                          tooltip: 'Dictado',
                          icon: Icon(
                            _speechToText.isListening
                                ? Icons.mic
                                : Icons.mic_none,
                            color: _speechEnabled
                                ? theme.colorScheme.onPrimary
                                : theme.disabledColor,
                          ),
                          style: IconButton.styleFrom(
                            backgroundColor: _speechEnabled
                                ? theme.colorScheme.primary
                                : theme.colorScheme.surface.withOpacity(0.5),
                            shape: const CircleBorder(),
                            padding: const EdgeInsets.all(16),
                          ),
                        ),
                ),
                SizedBox(width: 8),
                state.isLoading
                    ? CircularProgressIndicator()
                    : AnimatedSwitcher(
                        duration: const Duration(milliseconds: 200),
                        child: state.isLoading
                            ? null
                            : IconButton(
                                onPressed: () async {
                                  List<ByteData>? imageBytes;
                                  if (_image != null) {
                                    imageBytes = [
                                      (await _image!.readAsBytes())
                                          .buffer
                                          .asByteData()
                                    ];
                                  }
                                  widget.isAssitant
                                      ? context.read<ChatBloc>().add(
                                            OnChatAssistantSendMessage(
                                              message: textController.text,
                                              imageBytes: imageBytes,
                                            ),
                                          )
                                      : context.read<ChatBloc>().add(
                                            OnChatGeminiSendMessage(
                                              message: textController.text,
                                              imageBytes: imageBytes,
                                            ),
                                          );
                                  textController.clear();
                                  _image = null;
                                },
                                icon: Icon(
                                  Icons.send,
                                  color: Colors.white,
                                ),
                                style: IconButton.styleFrom(
                                  backgroundColor:
                                      Theme.of(context).colorScheme.primary,
                                  shape: const CircleBorder(),
                                  padding: const EdgeInsets.all(16),
                                ),
                              ),
                      ),
              ],
            ),
          ),
        );
      },
    );
  }

  /// A bottom sheet that is shown when the user wants to add a new avatar.
  /// It shows a message that indicates the user can select a new avatar from the gallery or take a photo with the camera.
  /// There are two actions: one to select a new avatar from the gallery and one to take a photo with the camera.
  /// When the user selects an avatar, the [_imageFile] is updated with the new image and the dialog is closed.
  Widget bottomSheet() {
    return Container(
      height: 100.0,
      width: MediaQuery.of(context).size.width,
      margin: const EdgeInsets.symmetric(
        horizontal: 20,
        vertical: 20,
      ),
      child: Column(children: <Widget>[
        Text(
          AppLocalizations.of(context)!.add_profile_image,
          style: TextStyle(
            fontSize: 20.0,
          ),
        ),
        const SizedBox(
          height: 20,
        ),
        Row(mainAxisAlignment: MainAxisAlignment.center, children: <Widget>[
          TextButton.icon(
            icon: const Icon(Icons.camera),
            onPressed: () {
              takePhoto(ImageSource.camera);
              Navigator.pop(context);
            },
            label: Text(AppLocalizations.of(context)!.camera),
          ),
          const SizedBox(
            width: 10,
          ),
          TextButton.icon(
            icon: const Icon(Icons.image),
            onPressed: () {
              takePhoto(ImageSource.gallery);
              Navigator.pop(context);
            },
            label: Text(
              AppLocalizations.of(context)!.gallery,
            ),
          )
        ])
      ]),
    );
  }

  /// Opens the gallery or camera depending on the [ImageSource] parameter and
  /// sets the [_image] with the selected image.
  ///
  /// If the user selects an image, the [_image] is updated with the new image.
  ///
  /// The [ImageSource] parameter is used to determine if the gallery or camera
  /// should be opened. If [ImageSource.camera] is passed, the camera is opened.
  /// If [ImageSource.gallery] is passed, the gallery is opened.
  ///
  /// If the user doesn't select an image, the [_image] is not updated and the
  /// dialog is closed.
  void takePhoto(ImageSource source) async {
    final pickedFile = await _picker.pickImage(source: source);
    if (pickedFile != null) {
      setState(() {
        _image = pickedFile;
      });
    }
  }
}
