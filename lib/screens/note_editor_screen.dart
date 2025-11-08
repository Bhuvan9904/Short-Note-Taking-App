import 'package:flutter/material.dart';
// ignore_for_file: uri_does_not_exist, undefined_class, undefined_identifier, undefined_function, undefined_method
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import 'package:image_picker/image_picker.dart';
import 'dart:io';

class NoteEditorScreen extends StatefulWidget {
  const NoteEditorScreen({super.key});

  @override
  State<NoteEditorScreen> createState() => _NoteEditorScreenState();
}

class _NoteEditorScreenState extends State<NoteEditorScreen> {
  final TextEditingController _titleController = TextEditingController();
  final TextEditingController _contentController = TextEditingController();
  final List<File> _attachments = [];

  @override
  void initState() {
    super.initState();
    _contentController.addListener(() {
      // Trigger rebuild to update counters
      if (mounted) setState(() {});
    });
  }

  @override
  void dispose() {
    _titleController.dispose();
    _contentController.dispose();
    super.dispose();
  }

  String get _formattedDate {
    final now = DateTime.now();
    const months = [
      'Jan','Feb','Mar','Apr','May','Jun','Jul','Aug','Sep','Oct','Nov','Dec'
    ];
    final day = now.day.toString().padLeft(2, '0');
    final month = months[now.month - 1];
    return 'Tuesday $day $month';
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textSecondary),
        title: Text(
          _formattedDate,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
        ),
        actions: [
          TextButton(
            onPressed: _saveNote,
            child: Text(
              'Save',
              style: AppTypography.callout.copyWith(
                color: AppColors.primaryPurple,
                fontWeight: FontWeight.w700,
              ),
            ),
          ),
          const SizedBox(width: AppSpacing.spacing2),
        ],
      ),
      body: SafeArea(
        child: Stack(
          children: [
            Padding(
              padding: const EdgeInsets.symmetric(
                horizontal: AppSpacing.spacing4,
              ),
              child: Column(
                crossAxisAlignment: CrossAxisAlignment.start,
                children: [
                  // Title field (filled card)
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing4,
                      vertical: AppSpacing.spacing4,
                    ),
                    constraints: const BoxConstraints(minHeight: 56),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    ),
                    child: TextField(
                      controller: _titleController,
                      style: AppTypography.title3.copyWith(
                        color: AppColors.textPrimary,
                        fontWeight: FontWeight.w700,
                      ),
                      decoration: const InputDecoration(
                        hintText: 'Title',
                        hintStyle: TextStyle(
                          color: AppColors.textSecondary,
                        ),
                        border: InputBorder.none,
                        contentPadding: EdgeInsets.symmetric(
                          horizontal: AppSpacing.spacing2,
                          vertical: AppSpacing.spacing3,
                        ),
                      ),
                    ),
                  ),

				  const SizedBox(height: 0),

                  // Content field (large filled card)
                  Expanded(
                    child: Container(
                      padding: const EdgeInsets.all(AppSpacing.spacing4),
                    decoration: BoxDecoration(
                      borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                    ),
                      child: TextField(
                        controller: _contentController,
                        maxLines: null,
                        expands: true,
                        textAlignVertical: TextAlignVertical.top,
                        decoration: const InputDecoration(
                          hintText: 'Start Writing...',
                          hintStyle: TextStyle(
                            color: AppColors.textTertiary,
                          ),
                          border: InputBorder.none,
                          contentPadding: EdgeInsets.symmetric(
                            horizontal: AppSpacing.spacing2,
                            vertical: AppSpacing.spacing2,
                          ),
                        ),
                        style: AppTypography.body.copyWith(
                          color: AppColors.textPrimary,
                          height: 1.5,
                        ),
                      ),
                    ),
                  ),

                  const SizedBox(height: AppSpacing.spacing3),

                  // Counters
                  Row(
                    children: [
                      Text(
                        _counterText,
                        style: AppTypography.caption.copyWith(
                          color: AppColors.textTertiary,
                        ),
                      ),
                    ],
                  ),

                  const SizedBox(height: 72), // space for bottom buttons
                ],
              ),
            ),
            // Bottom action buttons
            Positioned(
              bottom: AppSpacing.spacing4.toDouble(),
              right: AppSpacing.spacing4.toDouble(),
              child: Container(
                padding: const EdgeInsets.symmetric(
                  horizontal: AppSpacing.spacing3,
                  vertical: AppSpacing.spacing2,
                ),
                decoration: BoxDecoration(
                  color: AppColors.backgroundSecondary.withOpacity(0.9),
                  borderRadius: BorderRadius.circular(999),
                  border: Border.all(color: AppColors.backgroundTertiary, width: 1),
                  boxShadow: [
                    BoxShadow(
                      color: Colors.black.withOpacity(0.15),
                      blurRadius: 12,
                      offset: const Offset(0, 6),
                    ),
                  ],
                ),
                child: _circleButton(icon: Icons.add, onTap: _showAttachmentOptions),
              ),
            ),
            if (_attachments.isNotEmpty)
              Positioned(
                bottom: 100,
                left: 0,
                right: 0,
                child: SizedBox(
                  height: 72,
                  child: ListView.separated(
                    padding: const EdgeInsets.symmetric(horizontal: 16),
                    scrollDirection: Axis.horizontal,
                    itemCount: _attachments.length,
                    separatorBuilder: (_, __) => const SizedBox(width: 8),
                    itemBuilder: (context, index) {
                      final file = _attachments[index];
                      return Stack(
                        clipBehavior: Clip.none,
                        children: [
                          ClipRRect(
                            borderRadius: BorderRadius.circular(12),
                            child: Image.file(
                              file,
                              width: 72,
                              height: 72,
                              fit: BoxFit.cover,
                            ),
                          ),
                          Positioned(
                            top: -6,
                            right: -6,
                            child: GestureDetector(
                              onTap: () {
                                setState(() {
                                  _attachments.removeAt(index);
                                });
                              },
                              child: Container(
                                width: 22,
                                height: 22,
                                decoration: BoxDecoration(
                                  color: Colors.black.withOpacity(0.6),
                                  borderRadius: BorderRadius.circular(999),
                                ),
                                child: const Icon(Icons.close, size: 14, color: Colors.white),
                              ),
                            ),
                          ),
                        ],
                      );
                    },
                  ),
                ),
              ),
          ],
        ),
      ),
    );
  }

  Widget _circleButton({required IconData icon, required VoidCallback onTap}) {
    return Container(
      width: 46,
      height: 46,
      decoration: BoxDecoration(
        color: AppColors.backgroundSecondary,
        borderRadius: BorderRadius.circular(999),
        border: Border.all(color: AppColors.backgroundTertiary, width: 1),
        boxShadow: [
          BoxShadow(color: Colors.black.withOpacity(0.1), blurRadius: 8, offset: const Offset(0, 3)),
        ],
      ),
      child: IconButton(
        onPressed: onTap,
        icon: Icon(icon, color: AppColors.textSecondary, size: 20),
      ),
    );
  }

  String get _counterText {
    final text = _contentController.text.trim();
    final words = text.isEmpty
        ? 0
        : text
            .split(RegExp(r"\s+"))
            .where((w) => w.isNotEmpty)
            .length;
    final chars = text.length;
    return '$words words · $chars chars';
  }

  Future<void> _pickFromCamera() async {
    try {
      final picker = ImagePicker();
      final result = await picker.pickImage(source: ImageSource.camera, maxWidth: 1920, maxHeight: 1920, imageQuality: 90);
      if (result == null) return;
      setState(() {
        _attachments.add(File(result.path));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Camera error: $e')),
      );
    }
  }

  Future<void> _pickFromGallery() async {
    try {
      final picker = ImagePicker();
      final results = await picker.pickMultiImage(maxWidth: 1920, maxHeight: 1920, imageQuality: 90);
      if (results.isEmpty) return;
      setState(() {
        _attachments.addAll(results.map((x) => File(x.path)));
      });
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(content: Text('Gallery error: $e')),
      );
    }
  }

  void _showAttachmentOptions() {
    showModalBottomSheet(
      context: context,
      backgroundColor: AppColors.backgroundSecondary,
      shape: RoundedRectangleBorder(
        borderRadius: BorderRadius.vertical(top: Radius.circular(AppSpacing.radiusLarge.toDouble())),
      ),
      builder: (_) {
        return SafeArea(
          child: Column(
            mainAxisSize: MainAxisSize.min,
            children: [
              ListTile(
                leading: const Icon(Icons.camera_alt_outlined, color: AppColors.textSecondary),
                title: Text('Camera', style: AppTypography.body.copyWith(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickFromCamera();
                },
              ),
              ListTile(
                leading: const Icon(Icons.photo_library_outlined, color: AppColors.textSecondary),
                title: Text('Gallery', style: AppTypography.body.copyWith(color: AppColors.textPrimary)),
                onTap: () async {
                  Navigator.of(context).pop();
                  await _pickFromGallery();
                },
              ),
              const SizedBox(height: 8),
            ],
          ),
        );
      },
    );
  }

  Future<void> _saveNote() async {
    final title = _titleController.text.trim();
    final content = _contentController.text.trim();
    if (title.isEmpty && content.isEmpty) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: const Text('Please enter a title or content for your note'),
          backgroundColor: AppColors.warningAmber,
        ),
      );
      return;
    }

    final note = Note(
      id: DateTime.now().millisecondsSinceEpoch.toString(),
      title: title.isEmpty ? 'Untitled Note' : title,
      content: content,
      createdAt: DateTime.now(),
      updatedAt: DateTime.now(),
      category: 'Manual Note',
      tags: const ['manual'],
      imagePaths: _attachments.map((f) => f.path).toList(),
    );

    try {
      await StorageService.saveNote(note);
      
      // Update daily streak when creating notes
      StorageService.updateDailyStreak();
      
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Note "${note.displayTitle}" saved successfully!'),
          backgroundColor: AppColors.successGreen,
        ),
      );
      Navigator.of(context).pop();
    } catch (e) {
      if (!mounted) return;
      ScaffoldMessenger.of(context).showSnackBar(
        SnackBar(
          content: Text('Error saving note: $e'),
          backgroundColor: AppColors.errorRed,
        ),
      );
    }
  }
}


