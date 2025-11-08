import 'package:flutter/material.dart';
import 'package:flutter_animate/flutter_animate.dart';
import '../theme/app_colors.dart';
import '../theme/app_typography.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/exercise.dart';
import 'note_taking_screen.dart';

class ExerciseSelectionScreen extends StatefulWidget {
  const ExerciseSelectionScreen({super.key});

  @override
  State<ExerciseSelectionScreen> createState() => _ExerciseSelectionScreenState();
}

class _ExerciseSelectionScreenState extends State<ExerciseSelectionScreen> {
  List<Exercise> _exercises = [];
  List<Exercise> _filteredExercises = [];
  String _searchText = '';

  @override
  void initState() {
    super.initState();
    _loadExercises();
  }

  @override
  void didChangeDependencies() {
    super.didChangeDependencies();
    // Reload exercises when returning to this screen
    _loadExercises();
  }

  @override
  void dispose() {
    super.dispose();
  }

  void _loadExercises() {
    if (mounted) {
      setState(() {
        _exercises = StorageService.getAllExercises();
        _applyFilters();
      });
    }
  }

  

  void _applyFilters() {
    setState(() {
      _filteredExercises = _exercises.where((exercise) {
        // Search filter only
        if (_searchText.isNotEmpty) {
          final searchLower = _searchText.toLowerCase();
          if (!exercise.title.toLowerCase().contains(searchLower) &&
              !exercise.content.toLowerCase().contains(searchLower)) {
            return false;
          }
        }

        return true;
      }).toList();
    });
  }

  @override
  Widget build(BuildContext context) {
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Training'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: _buildPracticeExercisesTab(),
    );
  }

  Widget _buildPracticeExercisesTab() {
    return Column(
      children: [
        // Search bar
        Padding(
          padding: const EdgeInsets.all(AppSpacing.spacing4),
          child: TextField(
            onChanged: (value) {
              setState(() {
                _searchText = value;
              });
              _applyFilters();
            },
            decoration: InputDecoration(
              hintText: 'Search exercises...',
              prefixIcon: const Icon(Icons.search),
              suffixIcon: _searchText.isNotEmpty
                  ? IconButton(
                      icon: const Icon(Icons.clear),
                      onPressed: () {
                        setState(() {
                          _searchText = '';
                        });
                        _applyFilters();
                      },
                    )
                  : null,
            ),
          ),
        ),

        // Exercises list
        Expanded(
          child: _filteredExercises.isEmpty
              ? _buildEmptyState()
              : ListView.builder(
                  padding: const EdgeInsets.all(AppSpacing.spacing4),
                  itemCount: _filteredExercises.length,
                  itemBuilder: (context, index) {
                    final exercise = _filteredExercises[index];
                    return _buildExerciseCard(exercise);
                  },
                ),
        ),
      ],
    );
  }

  Widget _buildEmptyState() {
    return Center(
      child: Column(
        mainAxisAlignment: MainAxisAlignment.center,
        children: [
          Icon(
            Icons.search_off,
            size: 64,
            color: AppColors.textTertiary,
          ),
          const SizedBox(height: AppSpacing.spacing4),
          Text(
            'No exercises found',
            style: AppTypography.title3.copyWith(
              color: AppColors.textSecondary,
            ),
          ),
          const SizedBox(height: AppSpacing.spacing2),
          Text(
            'Try adjusting your search or filters',
            style: AppTypography.body.copyWith(
              color: AppColors.textTertiary,
            ),
          ),
        ],
      ),
    );
  }

  Widget _buildExerciseCard(Exercise exercise) {
    final isCompleted = StorageService.getProgressForExercise(exercise.id).isNotEmpty;
    
    return Container(
      margin: const EdgeInsets.only(bottom: AppSpacing.spacing4),
      child: Card(
        child: InkWell(
          onTap: () => _startExercise(exercise),
          borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
          child: Padding(
            padding: const EdgeInsets.all(AppSpacing.spacing4),
            child: Column(
              crossAxisAlignment: CrossAxisAlignment.start,
              children: [
                Row(
                  children: [
                    // Category icon
                    Container(
                      width: 48,
                      height: 48,
                      decoration: BoxDecoration(
                        color: AppColors.primaryPurple.withOpacity(0.1),
                        borderRadius: BorderRadius.circular(12),
                      ),
                      child: Icon(
                        _getCategoryIcon(exercise.category),
                        color: AppColors.primaryPurple,
                        size: 24,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing4),
                    
                    // Title and details
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Row(
                            children: [
                              Expanded(
                                child: Text(
                                  exercise.title,
                                  style: AppTypography.headline,
                                ),
                              ),
                            ],
                          ),
                          const SizedBox(height: AppSpacing.spacing2),
                          Wrap(
                            spacing: AppSpacing.spacing2,
                            runSpacing: AppSpacing.spacing1,
                            children: [
                              _buildDifficultyChip(exercise.difficulty),
                              _buildDurationChip(exercise.durationText),
                              _buildCategoryChip(exercise.category),
                            ],
                          ),
                        ],
                      ),
                    ),
                    
                    // Completion indicator
                    if (isCompleted)
                      Container(
                        width: 32,
                        height: 32,
                        decoration: const BoxDecoration(
                          color: AppColors.successGreen,
                          shape: BoxShape.circle,
                        ),
                        child: const Icon(
                          Icons.check,
                          color: Colors.white,
                          size: 20,
                        ),
                      ),
                  ],
                ),
                
                const SizedBox(height: AppSpacing.spacing4),
                
                // Description
                Text(
                  exercise.content.length > 100
                      ? '${exercise.content.substring(0, 100)}...'
                      : exercise.content,
                  style: AppTypography.body.copyWith(
                    color: AppColors.textSecondary,
                  ),
                  maxLines: 3,
                  overflow: TextOverflow.ellipsis,
                ),
              ],
            ),
          ),
        ),
      ),
    ).animate().fadeIn(duration: 300.ms).slideY(begin: 0.2, end: 0);
  }


  Widget _buildDifficultyChip(ExerciseDifficulty difficulty) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.getDifficultyColor(difficulty.difficultyText).withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          difficulty.difficultyText,
          style: AppTypography.caption.copyWith(
            color: AppColors.getDifficultyColor(difficulty.difficultyText),
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildDurationChip(String duration) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.backgroundTertiary,
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          duration,
          style: AppTypography.caption.copyWith(
            color: AppColors.textSecondary,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  Widget _buildCategoryChip(ExerciseCategory category) {
    return Flexible(
      child: Container(
        padding: const EdgeInsets.symmetric(
          horizontal: AppSpacing.spacing2,
          vertical: 2,
        ),
        decoration: BoxDecoration(
          color: AppColors.infoBlue.withOpacity(0.1),
          borderRadius: BorderRadius.circular(4),
        ),
        child: Text(
          category.categoryText,
          style: AppTypography.caption.copyWith(
            color: AppColors.infoBlue,
            fontWeight: FontWeight.w500,
          ),
          overflow: TextOverflow.ellipsis,
        ),
      ),
    );
  }

  IconData _getCategoryIcon(ExerciseCategory category) {
    switch (category) {
      case ExerciseCategory.business:
        return Icons.business;
      case ExerciseCategory.academic:
        return Icons.school;
      case ExerciseCategory.general:
        return Icons.article;
    }
  }



  void _startExercise(Exercise exercise) async {
    // Push the note taking screen and wait for result
    final result = await Navigator.of(context).push(
      MaterialPageRoute(
        builder: (context) => NoteTakingScreen(exercise: exercise),
      ),
    );
    
    // Refresh the exercise list when returning from completing an exercise
    // Result will be true if exercise was completed
    if (result == true || mounted) {
      _loadExercises();
    }
  }

}
