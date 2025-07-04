import 'package:dreamscope/features/dream/domain/entities/dream.dart';
import 'package:flutter_gen/gen_l10n/app_localizations.dart';
import 'package:flutter/material.dart';
import 'package:intl/intl.dart';

class DreamCard extends StatelessWidget {
  final Dream dream;

  const DreamCard({super.key, required this.dream});

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final l10n = AppLocalizations.of(context)!;
    final formattedDate =
        DateFormat.yMMMd(l10n.localeName).add_jm().format(dream.date);

    return Card(
      margin: const EdgeInsets.symmetric(vertical: 8, horizontal: 4),
      child: InkWell(
        onTap: () {
          _showDreamDetail(context, dream, theme, l10n);
        },
        borderRadius: BorderRadius.circular(12),
        child: Padding(
          padding: const EdgeInsets.all(16.0),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              Text(
                dream.title,
                style: theme.textTheme.titleLarge,
                maxLines: 2,
                overflow: TextOverflow.ellipsis,
              ),
              const SizedBox(height: 8),
              Text(
                formattedDate,
                style:
                    theme.textTheme.bodySmall?.copyWith(color: Colors.white54),
              ),
              const SizedBox(height: 12),
              Text(
                dream.content,
                style: theme.textTheme.bodyMedium,
                maxLines: 3,
                overflow: TextOverflow.ellipsis,
              ),
            ],
          ),
        ),
      ),
    );
  }

  void _showDreamDetail(BuildContext context, Dream dream, ThemeData theme,
      AppLocalizations l10n) {
    showModalBottomSheet(
      context: context,
      isScrollControlled: true,
      backgroundColor: theme.scaffoldBackgroundColor,
      shape: const RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(20)),
      ),
      builder: (ctx) {
        return DraggableScrollableSheet(
          expand: false,
          initialChildSize: 0.8,
          maxChildSize: 0.95,
          minChildSize: 0.5,
          builder: (_, scrollController) {
            return Container(
              padding: const EdgeInsets.all(20),
              child: ListView(
                controller: scrollController,
                children: [
                  Text(dream.title, style: theme.textTheme.displaySmall),
                  const SizedBox(height: 16),
                  Text(
                    dream.content,
                    style: theme.textTheme.bodyLarge?.copyWith(fontSize: 16),
                  ),
                  const SizedBox(height: 24),
                  const Divider(color: Colors.white24),
                  const SizedBox(height: 16),
                  Text(
                    l10n.dreamAnalysis,
                    style: theme.textTheme.titleLarge?.copyWith(
                        color: theme.colorScheme.secondary, fontSize: 22),
                  ),
                  const SizedBox(height: 12),
                  dream.analysis != null
                      ? Text(
                          dream.analysis!,
                          style: theme.textTheme.bodyLarge
                              ?.copyWith(fontStyle: FontStyle.italic),
                        )
                      : Text(
                          "No analysis available.",
                          style: theme.textTheme.bodyMedium
                              ?.copyWith(fontStyle: FontStyle.italic),
                        ),
                ],
              ),
            );
          },
        );
      },
    );
  }
}
