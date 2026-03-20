import 'package:flutter/material.dart';
import 'package:tkd_saas/features/bracket/domain/entities/bracket_edit_action.dart';
import 'package:tkd_saas/features/bracket/presentation/bloc/bracket_state.dart';

/// A drawer widget that displays the chronological history of match-result
/// actions. Each entry shows a human-readable label and timestamp. The
/// current history pointer position is visually highlighted.
///
/// Tapping an entry fires [onJumpToHistoryIndex] to jump to that point.
class BracketHistoryDrawer extends StatelessWidget {
  const BracketHistoryDrawer({
    super.key,
    required this.actionHistory,
    required this.historyPointer,
    required this.onJumpToHistoryIndex,
  });

  final List<BracketHistoryEntry> actionHistory;
  final int historyPointer;
  final ValueChanged<int> onJumpToHistoryIndex;

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Drawer(
      width: 340,
      child: Column(
        children: [
          // ── Header ──
          Container(
            width: double.infinity,
            padding: const EdgeInsets.fromLTRB(20, 48, 20, 16),
            decoration: BoxDecoration(color: colorScheme.primaryContainer),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    Icon(Icons.history, color: colorScheme.onPrimaryContainer),
                    const SizedBox(width: 8),
                    Text(
                      'Action History',
                      style: theme.textTheme.titleLarge?.copyWith(
                        color: colorScheme.onPrimaryContainer,
                        fontWeight: FontWeight.bold,
                      ),
                    ),
                  ],
                ),
                const SizedBox(height: 4),
                Text(
                  '${actionHistory.length} action${actionHistory.length == 1 ? '' : 's'} recorded',
                  style: theme.textTheme.bodySmall?.copyWith(
                    color: colorScheme.onPrimaryContainer.withAlpha(180),
                  ),
                ),
              ],
            ),
          ),

          // ── Initial State Entry ──
          _HistoryEntryTile(
            index: -1,
            label: 'Bracket Generated (Initial State)',
            timestamp: null,
            isCurrentPosition: historyPointer == -1,
            isInitialState: true,
            onTap: () => onJumpToHistoryIndex(-1),
          ),

          const Divider(height: 1),

          // ── Action Entries ──
          Expanded(
            child: actionHistory.isEmpty
                ? Center(
                    child: Padding(
                      padding: const EdgeInsets.all(24),
                      child: Column(
                        mainAxisSize: MainAxisSize.min,
                        children: [
                          Icon(
                            Icons.inbox_outlined,
                            size: 48,
                            color: colorScheme.outline,
                          ),
                          const SizedBox(height: 12),
                          Text(
                            'No actions recorded yet.\nScore a match to see it here.',
                            textAlign: TextAlign.center,
                            style: theme.textTheme.bodyMedium?.copyWith(
                              color: colorScheme.outline,
                            ),
                          ),
                        ],
                      ),
                    ),
                  )
                : ListView.separated(
                    padding: const EdgeInsets.symmetric(vertical: 4),
                    itemCount: actionHistory.length,
                    separatorBuilder: (_, _) =>
                        const Divider(height: 1, indent: 16, endIndent: 16),
                    itemBuilder: (context, index) {
                      final entry = actionHistory[index];
                      final displayLabel = switch (entry.action) {
                        BracketActionMatchResult(:final data) =>
                          data.displayLabel,
                        BracketActionEditAction(:final data) =>
                          data.displayLabel,
                      };
                      final timestamp = switch (entry.action) {
                        BracketActionMatchResult(:final data) =>
                          data.recordedAt,
                        BracketActionEditAction(:final data) =>
                          data.recordedAt,
                      };
                      final actionType = switch (entry.action) {
                        BracketActionMatchResult() =>
                          _HistoryActionType.matchResult,
                        BracketActionEditAction(
                          data: BracketEditActionParticipantSlotSwapped()
                        ) =>
                          _HistoryActionType.swap,
                        BracketActionEditAction(
                          data: BracketEditActionParticipantDetailsUpdated()
                        ) =>
                          _HistoryActionType.detailEdit,
                      };
                      return _HistoryEntryTile(
                        index: index,
                        label: displayLabel,
                        timestamp: timestamp,
                        isCurrentPosition: index == historyPointer,
                        isInitialState: false,
                        actionType: actionType,
                        onTap: () => onJumpToHistoryIndex(index),
                      );
                    },
                  ),
          ),
        ],
      ),
    );
  }
}

/// Differentiates entry types for visual styling in the drawer.
enum _HistoryActionType { matchResult, swap, detailEdit }

class _HistoryEntryTile extends StatelessWidget {
  const _HistoryEntryTile({
    required this.index,
    required this.label,
    required this.timestamp,
    required this.isCurrentPosition,
    required this.isInitialState,
    required this.onTap,
    this.actionType,
  });

  final int index;
  final String label;
  final DateTime? timestamp;
  final bool isCurrentPosition;
  final bool isInitialState;
  final VoidCallback onTap;
  final _HistoryActionType? actionType;

  IconData get _actionIcon => switch (actionType) {
    _HistoryActionType.matchResult => Icons.emoji_events_outlined,
    _HistoryActionType.swap => Icons.swap_horiz,
    _HistoryActionType.detailEdit => Icons.edit_outlined,
    null => Icons.flag,
  };

  @override
  Widget build(BuildContext context) {
    final theme = Theme.of(context);
    final colorScheme = theme.colorScheme;

    return Material(
      color: isCurrentPosition
          ? colorScheme.primaryContainer.withAlpha(100)
          : Colors.transparent,
      child: InkWell(
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
          child: Row(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // ── Step indicator ──
              Container(
                width: 28,
                height: 28,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  color: isCurrentPosition
                      ? colorScheme.primary
                      : isInitialState
                      ? colorScheme.surfaceContainerHighest
                      : colorScheme.surfaceContainerHigh,
                  border: isCurrentPosition
                      ? null
                      : Border.all(color: colorScheme.outline.withAlpha(80)),
                ),
                alignment: Alignment.center,
                child: isInitialState
                    ? Icon(
                        Icons.flag,
                        size: 14,
                        color: isCurrentPosition
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      )
                    : Icon(
                        _actionIcon,
                        size: 14,
                        color: isCurrentPosition
                            ? colorScheme.onPrimary
                            : colorScheme.onSurfaceVariant,
                      ),
              ),
              const SizedBox(width: 12),

              // ── Label and timestamp ──
              Expanded(
                child: Column(
                  crossAxisAlignment: CrossAxisAlignment.start,
                  children: [
                    Text(
                      label,
                      style: theme.textTheme.bodyMedium?.copyWith(
                        fontWeight: isCurrentPosition
                            ? FontWeight.bold
                            : FontWeight.normal,
                        color: isCurrentPosition
                            ? colorScheme.primary
                            : colorScheme.onSurface,
                      ),
                      maxLines: 2,
                      overflow: TextOverflow.ellipsis,
                    ),
                    if (timestamp != null) ...[
                      const SizedBox(height: 2),
                      Text(
                        _formatTimestamp(timestamp!),
                        style: theme.textTheme.bodySmall?.copyWith(
                          color: colorScheme.outline,
                        ),
                      ),
                    ],
                  ],
                ),
              ),

              // ── Current marker ──
              if (isCurrentPosition)
                Padding(
                  padding: const EdgeInsets.only(left: 8),
                  child: Icon(
                    Icons.arrow_back,
                    size: 16,
                    color: colorScheme.primary,
                  ),
                ),
            ],
          ),
        ),
      ),
    );
  }

  String _formatTimestamp(DateTime dateTime) {
    final hour = dateTime.hour.toString().padLeft(2, '0');
    final minute = dateTime.minute.toString().padLeft(2, '0');
    final second = dateTime.second.toString().padLeft(2, '0');
    return '$hour:$minute:$second';
  }
}
