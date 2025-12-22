import 'package:flutter/material.dart';
import 'package:flutter_markdown_plus/flutter_markdown_plus.dart';
import 'package:rol_genui/l10n/l10n/app_localizations.dart';

class ChatMessage extends StatelessWidget {
  final String text;
  final bool isFromUser;

  const ChatMessage({
    super.key,
    required this.text,
    required this.isFromUser,
  });

  @override

  /// Builds a chat message widget.
  ///
  /// This widget displays a single chat message within a styled container. The
  /// message is aligned to the start or end of the row based on whether it is
  /// from the user. The message text is rendered using Markdown, allowing for
  /// rich text formatting. The container's appearance, including its color and
  /// border radius, changes depending on who sent the message (user or narrator).
  ///
  /// The message displays the sender's identifier ("You" for user and "Narrator"
  /// for the other party) and the message content. The message bubble has a max
  /// width of 600 pixels and includes a shadow effect for messages not from the
  /// user.
  ///
  /// The [context] parameter is used to access theme data and localizations.

  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colors = theme.colorScheme;

    return Padding(
      padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 8),
      child: Row(
        mainAxisAlignment:
            isFromUser ? MainAxisAlignment.end : MainAxisAlignment.start,
        children: [
          Flexible(
            child: Container(
              constraints: const BoxConstraints(maxWidth: 600),
              decoration: BoxDecoration(
                color: isFromUser
                    ? colors.primaryContainer
                    : colors.surfaceContainerHighest,
                borderRadius: BorderRadius.only(
                  topLeft: const Radius.circular(20),
                  topRight: const Radius.circular(20),
                  bottomLeft: Radius.circular(isFromUser ? 20 : 4),
                  bottomRight: Radius.circular(isFromUser ? 4 : 20),
                ),
                boxShadow: [
                  if (!isFromUser)
                    BoxShadow(
                      color: colors.shadow.withOpacity(0.1),
                      blurRadius: 8,
                      offset: const Offset(0, 2),
                    ),
                ],
              ),
              padding: const EdgeInsets.symmetric(vertical: 12, horizontal: 16),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  Text(
                    isFromUser
                        ? AppLocalizations.of(context)!.you
                        : AppLocalizations.of(context)!.narrator,
                    style: theme.textTheme.labelMedium?.copyWith(
                      fontWeight: FontWeight.w600,
                      color: isFromUser
                          ? colors.onPrimaryContainer
                          : colors.onSurfaceVariant,
                    ),
                  ),
                  const SizedBox(height: 8),
                  MarkdownBody(
                    data: text,
                    styleSheet: MarkdownStyleSheet(
                      p: theme.textTheme.bodyLarge?.copyWith(
                        color: isFromUser
                            ? colors.onPrimaryContainer
                            : colors.onSurface,
                        height: 1.5,
                      ),
                      a: TextStyle(color: colors.primary),
                      code: TextStyle(
                        backgroundColor: colors.surfaceContainerHighest,
                        color: colors.onSurface,
                        fontFamily: 'FiraCode',
                      ),
                    ),
                  ),
                ],
              ),
            ),
          ),
        ],
      ),
    );
  }
}
