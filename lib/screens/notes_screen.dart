import 'package:flutter/material.dart';
import 'dart:io';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../models/note.dart';
import '../services/storage_service.dart';
import 'note_detail_screen.dart';
import 'note_editor_screen.dart';

class NotesScreen extends StatefulWidget {
  const NotesScreen({super.key});

  @override
  State<NotesScreen> createState() => _NotesScreenState();
}

class _NotesScreenState extends State<NotesScreen> {
  final TextEditingController _noteTitleController = TextEditingController();
  final TextEditingController _noteContentController = TextEditingController();

  @override
  void dispose() {
    _noteTitleController.dispose();
    _noteContentController.dispose();
    super.dispose();
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Notes'),
        backgroundColor: Colors.transparent,
        elevation: 0,
        automaticallyImplyLeading: false,
      ),
      body: SafeArea(
        child: Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          child: ValueListenableBuilder(
            valueListenable: StorageService.listenableNotes(),
            builder: (context, box, _) {
              final notes = StorageService.getAllNotes();
              if (notes.isEmpty) {
                return Center(
                  child: Column(
                    mainAxisAlignment: MainAxisAlignment.center,
                    children: [
                      Icon(
                        Icons.note_add,
                        size: 48,
                        color: AppColors.textTertiary,
                      ),
                      const SizedBox(height: AppSpacing.spacing3),
                      Text(
                        'No notes yet',
                        style: AppTypography.title3.copyWith(
                          color: AppColors.textSecondary,
                        ),
                      ),
                      const SizedBox(height: AppSpacing.spacing2),
                      Text(
                        'Create a note from the editor to see it here.',
                        style: AppTypography.body.copyWith(
                          color: AppColors.textTertiary,
                        ),
                        textAlign: TextAlign.center,
                      ),
                    ],
                  ),
                );
              }

              return ListView.builder(
                itemCount: notes.length,
                itemBuilder: (context, index) {
                  final note = notes[index];
                  return _buildNoteCard(note);
                },
              );
            },
          ),
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () {
          Navigator.of(context).push(
            MaterialPageRoute(
              builder: (context) => const NoteEditorScreen(),
            ),
          );
        },
        backgroundColor: AppColors.primaryPurple,
        child: const Icon(
          Icons.add,
          color: Colors.white,
        ),
      ),
    );
  }
  

  Widget _buildNoteCard(Note note) {
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing3),
      child: Card(
        color: AppColors.backgroundSecondary,
        child: InkWell(
          onTap: () => _viewNote(note),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                if (note.imagePaths.isNotEmpty)
                  ClipRRect(
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    child: Image.file(
                      File(note.imagePaths.first),
                      height: 140,
                      width: double.infinity,
                      fit: BoxFit.cover,
                    ),
                  ),
                if (note.imagePaths.isNotEmpty)
                  const SizedBox(height: AppSpacing.spacing3),
                Row(
                  children: [
                    Expanded(
                      child: Text(
                        note.displayTitle,
                        style: AppTypography.callout.copyWith(
                          fontWeight: FontWeight.w600,
                        ),
                      ),
                    ),
                    Text(
                      note.formattedDate,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.textTertiary,
                      ),
                    ),
                    // Delete icon removed; deletion available in detail screen
                  ],
                ),
                const SizedBox(height: AppSpacing.spacing2),
                Text(
                  note.previewContent,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                ),
                if (note.category != null) ...[
                  const SizedBox(height: AppSpacing.spacing2),
                  Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing2,
                      vertical: AppSpacing.spacing1,
                    ),
                    decoration: BoxDecoration(
                      color: AppColors.primaryPurple.withOpacity(0.1),
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    ),
                    child: Text(
                      note.category!,
                      style: AppTypography.caption.copyWith(
                        color: AppColors.primaryPurple,
                        fontWeight: FontWeight.w600,
                      ),
                    ),
                  ),
                ],
              ],
            ),
          ),
        ),
      ),
    );
  }


  

  void _viewNote(Note note) {
    Navigator.of(context).push(
      MaterialPageRoute(
        builder: (_) => NoteDetailScreen(note: note),
      ),
    );
  }
}
