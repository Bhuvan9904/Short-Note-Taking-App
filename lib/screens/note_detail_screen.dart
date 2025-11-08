import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import 'dart:io';

class NoteDetailScreen extends StatelessWidget {
  final Note note;

  const NoteDetailScreen({super.key, required this.note});

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        backgroundColor: Colors.transparent,
        elevation: 0,
        leading: BackButton(color: AppColors.textSecondary),
        title: const SizedBox.shrink(),
        actions: [
          IconButton(
            icon: const Icon(Icons.delete_outline),
            color: AppColors.textSecondary,
            tooltip: 'Delete',
            onPressed: () async {
              try {
                await StorageService.deleteNote(note.id);
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Deleted "${note.displayTitle}"'),
                      backgroundColor: AppColors.successGreen,
                      duration: const Duration(seconds: 2),
                    ),
                  );
                  Navigator.of(context).pop();
                }
              } catch (e) {
                if (context.mounted) {
                  ScaffoldMessenger.of(context).showSnackBar(
                    SnackBar(
                      content: Text('Error deleting note: $e'),
                      backgroundColor: AppColors.errorRed,
                    ),
                  );
                }
              }
            },
          ),
        ],
      ),
      body: SafeArea(
        child: SingleChildScrollView(
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          child: Column(
            crossAxisAlignment: CrossAxisAlignment.start,
            children: [
              // Title
              Text(
                note.displayTitle,
                style: AppTypography.title2.copyWith(
                  color: AppColors.textPrimary,
                  fontWeight: FontWeight.w800,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing1),
              // Date
              Text(
                note.formattedDate,
                style: AppTypography.caption.copyWith(color: AppColors.textSecondary),
              ),
              const SizedBox(height: AppSpacing.spacing2),
              // Divider
              Container(
                height: 1,
                width: double.infinity,
                color: AppColors.backgroundTertiary,
              ),
              const SizedBox(height: AppSpacing.spacing3),
              // Content
              Text(
                note.content.isEmpty ? 'Empty note' : note.content,
                style: AppTypography.body.copyWith(
                  color: AppColors.textPrimary,
                  height: 1.5,
                ),
              ),
              const SizedBox(height: AppSpacing.spacing8),
            ],
          ),
        ),
      ),
      floatingActionButtonLocation: FloatingActionButtonLocation.startFloat,
      floatingActionButton: note.imagePaths.isEmpty
          ? null
          : SafeArea(
              minimum: EdgeInsets.only(left: AppSpacing.spacing12.toDouble(), bottom: AppSpacing.spacing2.toDouble()),
              child: SizedBox(
                height: 96,
                child: Row(
                  mainAxisSize: MainAxisSize.min,
                  children: [
                    for (int i = 0; i < note.imagePaths.length; i++)
                      Padding(
                        padding: EdgeInsets.only(left: i == 0 ? 0 : AppSpacing.spacing3.toDouble()),
                        child: ClipRRect(
                          borderRadius: BorderRadius.circular(12),
                          child: Image.file(
                            File(note.imagePaths[i]),
                            width: 120,
                            height: 96,
                            fit: BoxFit.cover,
                          ),
                        ),
                      ),
                  ],
                ),
              ),
            ),
    );
  }

  // (unused helper retained for parity with editor; suppress warning)
  // ignore: unused_element
  String _counterText(String text) {
    final trimmed = text.trim();
    final words = trimmed.isEmpty ? 0 : trimmed.split(RegExp(r"\s+"))
        .where((w) => w.isNotEmpty).length;
    final chars = trimmed.length;
    return '$words words · $chars chars';
  }
}


