import 'dart:convert';
import 'dart:typed_data';

import 'package:file_picker/file_picker.dart';
import 'package:flutter/material.dart';
import 'package:flutter_bloc/flutter_bloc.dart';
import 'package:tkd_saas/features/auth/presentation/bloc/authentication_bloc.dart';
import 'package:tkd_saas/features/tournament/domain/entities/tournament_entity.dart';
import 'package:uuid/uuid.dart';

/// Default Supabase-hosted logo URLs used when creating new tournaments.
abstract final class TournamentLogoDefaults {
  static const String rightLogoUrl =
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/logo_placeholder_4536.png';
  static const String leftLogoUrl =
      'https://lldlunqzkltclpfzpjxh.supabase.co/storage/v1/object/public/assets/logo_placeholder_4536.png';

  /// Returns `true` if the given [url] is a base64 data URI.
  static bool isDataUri(String url) => url.startsWith('data:');
}

/// Modal dialog to create or edit a [TournamentEntity].
///
/// Pass [existing] to pre-fill all fields and switch the dialog into
/// "edit" mode (title → "Edit Tournament", button → "Save").
/// Returns the completed [TournamentEntity] via [Navigator.pop], or null
/// on cancel.
class CreateTournamentDialog extends StatefulWidget {
  const CreateTournamentDialog({super.key, this.existing});

  /// When non-null the dialog operates in edit mode.
  final TournamentEntity? existing;

  @override
  State<CreateTournamentDialog> createState() => _CreateTournamentDialogState();
}

class _CreateTournamentDialogState extends State<CreateTournamentDialog> {
  static const _uuid = Uuid();

  final _formKey = GlobalKey<FormState>();
  late final TextEditingController _nameController;
  late final TextEditingController _dateRangeController;
  late final TextEditingController _venueController;
  late final TextEditingController _organizerController;

  /// Current logo URL/data-URI values. Mutable so they can be swapped by
  /// the file picker without needing a TextEditingController.
  late String _leftLogoUrl;
  late String _rightLogoUrl;

  bool get _isEditing => widget.existing != null;

  @override
  void initState() {
    super.initState();
    final existingTournament = widget.existing;
    _nameController = TextEditingController(
      text: existingTournament?.name ?? '',
    );
    _dateRangeController = TextEditingController(
      text: existingTournament?.dateRange ?? '',
    );
    _venueController = TextEditingController(
      text: existingTournament?.venue ?? '',
    );
    _organizerController = TextEditingController(
      text: existingTournament?.organizer ?? '',
    );
    _leftLogoUrl =
        existingTournament?.leftLogoUrl ?? TournamentLogoDefaults.leftLogoUrl;
    _rightLogoUrl =
        existingTournament?.rightLogoUrl ?? TournamentLogoDefaults.rightLogoUrl;
  }

  @override
  void dispose() {
    _nameController.dispose();
    _dateRangeController.dispose();
    _venueController.dispose();
    _organizerController.dispose();
    super.dispose();
  }

  void _submitTournamentForm() {
    if (!_formKey.currentState!.validate()) return;

    final existingTournament = widget.existing;
    final tournament = TournamentEntity(
      // Preserve original id and createdAt when editing.
      id: existingTournament?.id ?? _uuid.v4(),
      userId:
          existingTournament?.userId ??
          context.read<AuthenticationBloc>().state.mapOrNull(
            authenticated: (state) => state.user.id,
          ) ??
          '',
      name: _nameController.text.trim(),
      dateRange: _dateRangeController.text.trim(),
      venue: _venueController.text.trim(),
      organizer: _organizerController.text.trim(),
      leftLogoUrl: _leftLogoUrl,
      rightLogoUrl: _rightLogoUrl,
      createdAt: existingTournament?.createdAt ?? DateTime.now(),
      updatedAt: DateTime.now(),
    );

    Navigator.pop(context, tournament);
  }

  /// Opens a file picker to select an image and converts the result to a
  /// base64 data URI string.
  Future<String?> _pickImageAsDataUri() async {
    final result = await FilePicker.platform.pickFiles(
      type: FileType.image,
      allowMultiple: false,
      withData: true,
    );
    if (result == null || result.files.isEmpty) return null;

    final pickedFile = result.files.first;
    final Uint8List? fileBytes = pickedFile.bytes;
    if (fileBytes == null) return null;

    // Detect MIME from extension or default to png.
    final extension = pickedFile.extension?.toLowerCase() ?? 'png';
    final mimeType = switch (extension) {
      'jpg' || 'jpeg' => 'image/jpeg',
      'gif' => 'image/gif',
      'webp' => 'image/webp',
      'svg' => 'image/svg+xml',
      _ => 'image/png',
    };

    final base64Data = base64Encode(fileBytes);
    return 'data:$mimeType;base64,$base64Data';
  }

  @override
  Widget build(BuildContext context) {
    return AlertDialog(
      title: Text(_isEditing ? 'Edit Tournament' : 'New Tournament'),
      content: SizedBox(
        width: 540,
        child: Form(
          key: _formKey,
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                TextFormField(
                  controller: _nameController,
                  decoration: const InputDecoration(
                    labelText: 'Tournament Name *',
                  ),
                  textInputAction: TextInputAction.next,
                  validator: (value) => (value == null || value.trim().isEmpty)
                      ? 'Required'
                      : null,
                  autofocus: true,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _dateRangeController,
                  decoration: const InputDecoration(labelText: 'Date Range'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _venueController,
                  decoration: const InputDecoration(labelText: 'Venue'),
                  textInputAction: TextInputAction.next,
                ),
                const SizedBox(height: 12),
                TextField(
                  controller: _organizerController,
                  decoration: const InputDecoration(labelText: 'Organizer'),
                  textInputAction: TextInputAction.done,
                  onSubmitted: (_) => _submitTournamentForm(),
                ),
                const SizedBox(height: 20),
                _buildTournamentLogosSection(),
              ],
            ),
          ),
        ),
      ),
      actions: [
        TextButton(
          onPressed: () => Navigator.pop(context),
          child: const Text('Cancel'),
        ),
        ElevatedButton(
          onPressed: _submitTournamentForm,
          child: Text(_isEditing ? 'Save' : 'Create'),
        ),
      ],
    );
  }

  Widget _buildTournamentLogosSection() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        Row(
          children: [
            Icon(Icons.image_outlined, size: 18, color: Colors.grey.shade600),
            const SizedBox(width: 6),
            Text(
              'Tournament Logos',
              style: TextStyle(
                fontSize: 13,
                fontWeight: FontWeight.w600,
                color: Colors.grey.shade700,
              ),
            ),
          ],
        ),
        const SizedBox(height: 4),
        Text(
          'Displayed at the top of the tie sheet. Tap the image to change, or reset to the default.',
          style: TextStyle(fontSize: 11, color: Colors.grey.shade500),
        ),
        const SizedBox(height: 12),
        Row(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            Expanded(
              child: _LogoPickerCard(
                label: 'Left Logo',
                currentUrl: _leftLogoUrl,
                defaultUrl: TournamentLogoDefaults.leftLogoUrl,
                onPickImage: () async {
                  final dataUri = await _pickImageAsDataUri();
                  if (dataUri != null) {
                    setState(() => _leftLogoUrl = dataUri);
                  }
                },
                onResetToDefault: () {
                  setState(() {
                    _leftLogoUrl = TournamentLogoDefaults.leftLogoUrl;
                  });
                },
                onRemove: () {
                  setState(() => _leftLogoUrl = '');
                },
              ),
            ),
            const SizedBox(width: 12),
            Expanded(
              child: _LogoPickerCard(
                label: 'Right Logo',
                currentUrl: _rightLogoUrl,
                defaultUrl: TournamentLogoDefaults.rightLogoUrl,
                onPickImage: () async {
                  final dataUri = await _pickImageAsDataUri();
                  if (dataUri != null) {
                    setState(() => _rightLogoUrl = dataUri);
                  }
                },
                onResetToDefault: () {
                  setState(() {
                    _rightLogoUrl = TournamentLogoDefaults.rightLogoUrl;
                  });
                },
                onRemove: () {
                  setState(() => _rightLogoUrl = '');
                },
              ),
            ),
          ],
        ),
      ],
    );
  }
}

/// Compact card showing a logo preview with pick / reset / remove controls.
class _LogoPickerCard extends StatelessWidget {
  const _LogoPickerCard({
    required this.label,
    required this.currentUrl,
    required this.defaultUrl,
    required this.onPickImage,
    required this.onResetToDefault,
    required this.onRemove,
  });

  final String label;
  final String currentUrl;
  final String defaultUrl;
  final VoidCallback onPickImage;
  final VoidCallback onResetToDefault;
  final VoidCallback onRemove;

  bool get _isDefault => currentUrl == defaultUrl;
  bool get _hasLogo => currentUrl.isNotEmpty;

  /// Builds the appropriate image widget for a URL or data URI.
  Widget _buildPreviewImage(String url) {
    if (TournamentLogoDefaults.isDataUri(url)) {
      final commaIndex = url.indexOf(',');
      if (commaIndex == -1) return _buildBrokenIcon();
      final base64String = url.substring(commaIndex + 1);
      try {
        final bytes = base64Decode(base64String);
        return Image.memory(
          bytes,
          fit: BoxFit.contain,
          errorBuilder: (context, error, stackTrace) => _buildBrokenIcon(),
        );
      } catch (_) {
        return _buildBrokenIcon();
      }
    }
    return Image.network(
      url,
      fit: BoxFit.contain,
      errorBuilder: (context, error, stackTrace) => _buildBrokenIcon(),
      loadingBuilder: (context, child, loadingProgress) {
        if (loadingProgress == null) return child;
        return const Center(
          child: SizedBox(
            width: 20,
            height: 20,
            child: CircularProgressIndicator(strokeWidth: 2),
          ),
        );
      },
    );
  }

  static Widget _buildBrokenIcon() => Center(
    child: Icon(
      Icons.broken_image_outlined,
      size: 28,
      color: Colors.grey.shade600,
    ),
  );

  @override
  Widget build(BuildContext context) {
    return Container(
      padding: const EdgeInsets.all(10),
      decoration: BoxDecoration(
        border: Border.all(color: Colors.grey.shade300),
        borderRadius: BorderRadius.circular(8),
        color: Colors.grey.shade50,
      ),
      child: Column(
        children: [
          InkWell(
            borderRadius: BorderRadius.circular(6),
            onTap: onPickImage,
            child: Container(
              height: 64,
              width: 64,
              decoration: BoxDecoration(
                color: Colors.white,
                borderRadius: BorderRadius.circular(6),
                border: Border.all(color: Colors.grey.shade200),
              ),
              clipBehavior: Clip.antiAlias,
              child: _hasLogo
                  ? _buildPreviewImage(currentUrl)
                  : const Center(
                      child: Icon(
                        Icons.add_photo_alternate_outlined,
                        size: 28,
                        color: Colors.grey,
                      ),
                    ),
            ),
          ),
          const SizedBox(height: 8),
          Text(
            label,
            style: const TextStyle(fontSize: 11, fontWeight: FontWeight.w600),
          ),
          const SizedBox(height: 6),
          Row(
            mainAxisAlignment: MainAxisAlignment.center,
            children: [
              _MiniActionButton(
                icon: Icons.upload_file_outlined,
                tooltip: 'Choose image',
                onTap: onPickImage,
              ),
              if (!_isDefault) ...[
                const SizedBox(width: 4),
                _MiniActionButton(
                  icon: Icons.restart_alt,
                  tooltip: 'Reset to default',
                  onTap: onResetToDefault,
                  color: Colors.grey.shade600,
                ),
              ],
              if (_hasLogo && !_isDefault) ...[
                const SizedBox(width: 4),
                _MiniActionButton(
                  icon: Icons.close,
                  tooltip: 'Remove logo',
                  onTap: onRemove,
                  color: Colors.grey.shade600,
                ),
              ],
            ],
          ),
        ],
      ),
    );
  }
}

/// 24×24 icon button used for the logo card action row.
class _MiniActionButton extends StatelessWidget {
  const _MiniActionButton({
    required this.icon,
    required this.tooltip,
    required this.onTap,
    this.color,
  });

  final IconData icon;
  final String tooltip;
  final VoidCallback onTap;
  final Color? color;

  @override
  Widget build(BuildContext context) {
    return Tooltip(
      message: tooltip,
      child: InkWell(
        borderRadius: BorderRadius.circular(12),
        onTap: onTap,
        child: Padding(
          padding: const EdgeInsets.all(4),
          child: Icon(icon, size: 16, color: color ?? Colors.grey.shade700),
        ),
      ),
    );
  }
}
