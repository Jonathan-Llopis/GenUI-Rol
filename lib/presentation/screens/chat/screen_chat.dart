import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:rol_genui/l10n/l10n/app_localizations.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_bloc.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_event.dart';
import 'package:rol_genui/presentation/blocs/chat/chat_state.dart';
import 'package:rol_genui/presentation/screens/chat/chat_message.dart';
import 'package:rol_genui/presentation/screens/chat/input_text_image.dart';


class ScreenChat extends StatefulWidget {
  const ScreenChat({super.key});

  @override
  State<ScreenChat> createState() => _ChatScreenState();
}

class _ChatScreenState extends State<ScreenChat> {
  final FocusNode _focusNode = FocusNode();
  @override

  /// Initializes the state of the chat Gemini screen.
  ///
  /// This function is called when the widget is inserted into the tree.
  ///
  /// If the Gemini chat messages are empty, it adds a [OnChatGeminiStart] event
  /// to the [ChatBloc] to start the chat with Gemini.

  void initState() {
    ChatBloc chatBloc = context.read<ChatBloc>();
    if (chatBloc.state.messagesGemini.isEmpty) {
      context.read<ChatBloc>().add(OnChatGeminiStart(context: context));
    }

    super.initState();
  }

  @override

  /// Called when the widget is removed from the tree permanently.
  ///
  /// This is the opposite of [initState]. It is called when the widget is
  /// discarded, and is used to free up any resources that aren't needed
  /// anymore.
  ///
  /// In this case, it is used to remove the focus node from the widget tree.
  ///
  /// This method is called automatically when the widget is removed from the
  /// tree, but it is also safe to call manually if you want to prematurely
  /// release resources.
  void dispose() {
    _focusNode.dispose();
    super.dispose();
  }

  @override

  /// Builds the chat Gemini screen.
  ///
  /// This screen is used to chat with Gemini about board games. It shows the
  /// conversation history at the top and an input field at the bottom.
  ///
  /// The title of the screen is "Identify board games" and it shows a restart
  /// icon in the actions section that restarts the conversation when pressed.
  ///
  /// The input field is an [InputTextImage] widget that allows the user to
  /// input text and images. The focus node is passed as a parameter so that
  /// the input field can request focus when the user starts typing.
  ///
  /// The conversation history is a [BodyMessages] widget that shows the
  /// conversation history. It is passed the [ChatBloc] as a parameter so that
  /// it can retrieve the messages from the bloc.
  Widget build(BuildContext context) {
    return Scaffold(
        appBar: AppBar(
          title: Row(
            children: [
              Icon(Icons.auto_awesome,
                  color: Theme.of(context).colorScheme.primary),
              const SizedBox(width: 12),
              Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    AppLocalizations.of(context)!.identify_board_games,
                    style: Theme.of(context).textTheme.titleMedium?.copyWith(
                          fontWeight: FontWeight.w600,
                          fontSize: 14,
                        ),
                  ),
                  Text(
                    AppLocalizations.of(context)!.ai_assistant,
                    style: Theme.of(context).textTheme.bodySmall?.copyWith(
                          color: Theme.of(context)
                              .colorScheme
                              .onSurface
                              .withOpacity(0.6),
                        ),
                  ),
                ],
              ),
            ],
          ),
          actions: [
            Tooltip(
              message: AppLocalizations.of(context)!.restart_conversation,
              child: IconButton(
                icon: Icon(Icons.restart_alt, size: 28),
                onPressed: () {
                  context
                      .read<ChatBloc>()
                      .add(OnChatGeminiStart(context: context));
                  setState(() {});
                },
              ),
            ),
          ],
        ),
        body: Column(
          children: [
            Expanded(
              child: BodyMessages(),
            ),
            InputTextImage(
              focusNode: _focusNode,
              isAssitant: false,
            ),
          ],
        ));
  }
}

class BodyMessages extends StatelessWidget {
  const BodyMessages({super.key});

  @override

  /// Builds a widget that displays the chat messages with Gemini.
  ///
  /// This widget uses a [BlocBuilder] to listen to the state of the [ChatBloc].
  /// If there are messages from Gemini, it displays them in a [ListView] and
  /// automatically scrolls to the bottom when new messages arrive. If there are
  /// no messages, it shows a loading text.
  ///
  /// The [scrollController] is used to manage the scrolling of the [ListView].
  /// The widget triggers a post-frame callback to ensure the list scrolls to the
  /// latest message once the frame is rendered.

  Widget build(BuildContext context) {
    ScrollController scrollController = ScrollController();

    return BlocBuilder<ChatBloc, ChatState>(
      builder: (context, state) {
        if (state.messagesGemini.isNotEmpty) {
          WidgetsBinding.instance.addPostFrameCallback((_) {
            if (scrollController.hasClients) {
              scrollController
                  .jumpTo(scrollController.position.maxScrollExtent);
            }
          });

          return ListView.builder(
            controller: scrollController,
            itemBuilder: (context, index) {
              final text = state.messagesGemini[index]['text'] ?? '';

              return ChatMessage(
                text: text,
                isFromUser: state.messagesGemini[index]['role'] == 'user',
              );
            },
            itemCount: state.messagesGemini.length,
          );
        } else {
          return Center(child: Text('Cargando chat...'));
        }
      },
    );
  }
}
