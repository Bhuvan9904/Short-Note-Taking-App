import 'package:flutter/material.dart';
import '../theme/app_colors.dart';
import '../theme/app_spacing.dart';
import '../services/storage_service.dart';
import '../models/abbreviation.dart';
import 'abbreviation_detail_screen.dart';

class AbbreviationsLearningScreen extends StatefulWidget {
  const AbbreviationsLearningScreen({super.key});

  @override
  State<AbbreviationsLearningScreen> createState() => _AbbreviationsLearningScreenState();
}

class _AbbreviationsLearningScreenState extends State<AbbreviationsLearningScreen> {
  int _selectedCategoryIndex = 0;

  final List<String> _categories = ['All', 'Business', 'Academic', 'General'];

  // Simple hardcoded abbreviations list (as fallback)
  final List<Map<String, String>> _hardcodedAbbreviations = [
    {'full': 'meeting', 'short': 'mtg', 'category': 'Business'},
    {'full': 'project', 'short': 'proj', 'category': 'Business'},
    {'full': 'budget', 'short': 'budg', 'category': 'Business'},
    {'full': 'manager', 'short': 'mgr', 'category': 'Business'},
    {'full': 'department', 'short': 'dept', 'category': 'Business'},
    {'full': 'quarter', 'short': 'qtr', 'category': 'Business'},
    {'full': 'revenue', 'short': 'rev', 'category': 'Business'},
    {'full': 'expenses', 'short': 'exp', 'category': 'Business'},
    {'full': 'marketing', 'short': 'mktg', 'category': 'Business'},
    {'full': 'human resources', 'short': 'HR', 'category': 'Business'},
    {'full': 'chief financial officer', 'short': 'CFO', 'category': 'Business'},
    {'full': 'chief executive officer', 'short': 'CEO', 'category': 'Business'},
    {'full': 'performance', 'short': 'perf', 'category': 'Business'},
    {'full': 'productivity', 'short': 'prod', 'category': 'Business'},
    {'full': 'communication', 'short': 'comm', 'category': 'Business'},
    {'full': 'collaboration', 'short': 'collab', 'category': 'Business'},
    {'full': 'customer', 'short': 'cust', 'category': 'Business'},
    {'full': 'customer relationship management', 'short': 'CRM', 'category': 'Business'},
    {'full': 'return on investment', 'short': 'ROI', 'category': 'Business'},
    {'full': 'key performance indicator', 'short': 'KPI', 'category': 'Business'},
    {'full': 'year', 'short': 'yr', 'category': 'General'},
    {'full': 'month', 'short': 'mo', 'category': 'General'},
    {'full': 'week', 'short': 'wk', 'category': 'General'},
    {'full': 'versus', 'short': 'vs', 'category': 'General'},
    {'full': 'etcetera', 'short': 'etc', 'category': 'General'},
    {'full': 'with', 'short': 'w/', 'category': 'General'},
    {'full': 'without', 'short': 'w/o', 'category': 'General'},
    {'full': 'because', 'short': 'b/c', 'category': 'General'},
    {'full': 'between', 'short': 'b/w', 'category': 'General'},
    {'full': 'for your information', 'short': 'fyi', 'category': 'General'},
    {'full': 'as soon as possible', 'short': 'asap', 'category': 'General'},
    {'full': 'please respond', 'short': 'rsvp', 'category': 'General'},
    {'full': 'artificial intelligence', 'short': 'AI', 'category': 'Academic'},
    {'full': 'machine learning', 'short': 'ML', 'category': 'Academic'},
    {'full': 'natural language processing', 'short': 'NLP', 'category': 'Academic'},
    {'full': 'authentication', 'short': 'auth', 'category': 'Academic'},
    {'full': 'prototype', 'short': 'proto', 'category': 'Academic'},
    {'full': 'information technology', 'short': 'IT', 'category': 'Academic'},
    {'full': 'user experience', 'short': 'UX', 'category': 'Academic'},
    {'full': 'World War II', 'short': 'WWII', 'category': 'Academic'},
    {'full': 'United Kingdom', 'short': 'UK', 'category': 'Academic'},
    {'full': 'Royal Air Force', 'short': 'RAF', 'category': 'Academic'},
    {'full': 'United States', 'short': 'US', 'category': 'Academic'},
  ];

  List<Map<String, dynamic>> get _currentAbbreviations {
    final category = _categories[_selectedCategoryIndex];
    
    print('DEBUG: Getting abbreviations for $category');
    
    // Get abbreviations from database
    final dbAbbreviations = StorageService.getAllAbbreviations();
    print('DEBUG: Loaded ${dbAbbreviations.length} abbreviations from database');
    
    // Combine hardcoded and database abbreviations
    List<Map<String, dynamic>> allAbbreviations = _hardcodedAbbreviations.map((abbr) => {
      ...abbr,
      'isCustom': false,
      'id': null,
    }).toList();
    
    // Add database abbreviations (mark as custom/deletable)
    for (var abbr in dbAbbreviations) {
      // Map enum categories back to user-facing names
      String displayCategory;
      switch (abbr.category) {
        case AbbreviationCategory.business:
          displayCategory = 'Business';
          break;
        case AbbreviationCategory.common:
          displayCategory = 'Academic';
          break;
        case AbbreviationCategory.custom:
          displayCategory = 'General';
          break;
      }
      
      allAbbreviations.add({
        'full': abbr.fullWord,
        'short': abbr.abbreviation,
        'category': displayCategory,
        'isCustom': abbr.isUserCreated,
        'id': abbr.id,
      });
    }
    
    print('DEBUG: Total abbreviations: ${allAbbreviations.length}');
    
    List<Map<String, dynamic>> filtered = allAbbreviations;
    
    // Filter by category if not 'All'
    if (category != 'All') {
      filtered = filtered.where((abbr) => abbr['category'] == category).toList();
      print('DEBUG: After category filter: ${filtered.length} abbreviations');
    }
    
    print('DEBUG: Final result: ${filtered.length} abbreviations');
    return filtered;
  }

  @override
  Widget build(BuildContext context) {
    print('DEBUG: AbbreviationsLearningScreen build() called');
    
    final abbreviations = _currentAbbreviations;
    
    return Scaffold(
      backgroundColor: AppColors.backgroundPrimary,
      appBar: AppBar(
        title: const Text('Abbreviation Learning'),
        backgroundColor: Colors.transparent,
        elevation: 0,
      ),
      body: SingleChildScrollView(
        padding: const EdgeInsets.all(AppSpacing.spacing4),
        child: Column(
          crossAxisAlignment: CrossAxisAlignment.start,
          children: [
            
            // Category selector
            _buildCategorySelector(),
            
            const SizedBox(height: AppSpacing.spacing4),
            
            // Abbreviations list
            if (abbreviations.isEmpty) ...[
              Container(
                width: double.infinity,
                padding: const EdgeInsets.all(AppSpacing.spacing6),
                decoration: BoxDecoration(
                  color: Colors.red.withOpacity(0.1),
                  borderRadius: BorderRadius.circular(AppSpacing.radiusMedium),
                ),
                child: Column(
                  children: [
                    const Icon(Icons.warning, color: Colors.red, size: 48),
                    const SizedBox(height: AppSpacing.spacing2),
                    const Text(
                      'No abbreviations found!',
                      style: TextStyle(
                        fontSize: 16,
                        fontWeight: FontWeight.bold,
                        color: Colors.red,
                      ),
                    ),
                    Text(
                      'Category: ${_categories[_selectedCategoryIndex]}',
                      style: const TextStyle(color: Colors.red),
                    ),
                  ],
                ),
              ),
            ] else ...[
              // Show abbreviations
              ...abbreviations.map((abbr) => GestureDetector(
                onTap: () {
                  // Create Abbreviation object from hardcoded data
                  final abbreviation = Abbreviation(
                    id: 'hardcoded_${abbr['short']}',
                    fullWord: abbr['full']!,
                    abbreviation: abbr['short']!,
                    category: _getCategoryFromString(abbr['category']!),
                    frequency: 0,
                    isUserCreated: false,
                    createdAt: DateTime.now(),
                    description: 'Common abbreviation used in professional settings',
                  );
                  
                  Navigator.of(context).push(
                    MaterialPageRoute(
                      builder: (context) => AbbreviationDetailScreen(
                        abbreviation: abbreviation,
                      ),
                    ),
                  );
                },
                child: Container(
                  width: double.infinity,
                  margin: const EdgeInsets.only(bottom: AppSpacing.spacing2),
                  padding: const EdgeInsets.all(AppSpacing.spacing3),
                  decoration: BoxDecoration(
                    color: AppColors.backgroundSecondary,
                    borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                    border: Border.all(color: AppColors.textTertiary.withOpacity(0.3)),
                    boxShadow: [
                      BoxShadow(
                        color: Colors.black.withOpacity(0.1),
                        spreadRadius: 1,
                        blurRadius: 3,
                        offset: const Offset(0, 1),
                      ),
                    ],
                  ),
                  child: Row(
                  children: [
                    Container(
                      width: 40,
                      height: 40,
                      decoration: BoxDecoration(
                        color: _getCategoryColor(abbr['category']!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(8),
                      ),
                      child: Icon(
                        _getCategoryIcon(abbr['category']!),
                        color: _getCategoryColor(abbr['category']!),
                        size: 20,
                      ),
                    ),
                    const SizedBox(width: AppSpacing.spacing3),
                    Expanded(
                      child: Column(
                        crossAxisAlignment: CrossAxisAlignment.start,
                        children: [
                          Text(
                            abbr['full']!,
                            style: const TextStyle(
                              fontSize: 16,
                              fontWeight: FontWeight.bold,
                              color: AppColors.textPrimary,
                            ),
                          ),
                          const SizedBox(height: 4),
                          Text(
                            '→ ${abbr['short']!}',
                            style: TextStyle(
                              fontSize: 14,
                              color: AppColors.primaryPurple,
                              fontWeight: FontWeight.bold,
                            ),
                          ),
                        ],
                      ),
                    ),
                    Container(
                      padding: const EdgeInsets.symmetric(
                        horizontal: 8,
                        vertical: 4,
                      ),
                      decoration: BoxDecoration(
                        color: _getCategoryColor(abbr['category']!).withOpacity(0.1),
                        borderRadius: BorderRadius.circular(4),
                      ),
                      child: Text(
                        abbr['category']!,
                        style: TextStyle(
                          fontSize: 12,
                          color: _getCategoryColor(abbr['category']!),
                          fontWeight: FontWeight.bold,
                        ),
                      ),
                    ),
                    // Delete button removed for custom abbreviations
                  ],
                ),
                ),
              )),
            ],
          ],
        ),
      ),
      floatingActionButton: FloatingActionButton(
        onPressed: () => _showAddAbbreviationDialog(),
        backgroundColor: AppColors.primaryPurple,
        foregroundColor: Colors.white,
        elevation: 8,
        tooltip: 'Add Custom Abbreviation',
        child: const Icon(Icons.add_rounded, size: 28),
      ),
    );
  }

  Widget _buildCategorySelector() {
    return Column(
      crossAxisAlignment: CrossAxisAlignment.start,
      children: [
        const Text(
          'Category',
          style: TextStyle(
            fontSize: 16,
            fontWeight: FontWeight.bold,
            color: AppColors.textPrimary,
          ),
        ),
        const SizedBox(height: AppSpacing.spacing2),
        SingleChildScrollView(
          scrollDirection: Axis.horizontal,
          child: Row(
            children: _categories.asMap().entries.map((entry) {
              final index = entry.key;
              final category = entry.value;
              final isSelected = index == _selectedCategoryIndex;
              
              return Container(
                margin: const EdgeInsets.only(right: AppSpacing.spacing2),
                child: GestureDetector(
                  onTap: () {
                    setState(() {
                      _selectedCategoryIndex = index;
                    });
                  },
                  child: Container(
                    padding: const EdgeInsets.symmetric(
                      horizontal: AppSpacing.spacing4,
                      vertical: AppSpacing.spacing2,
                    ),
                    decoration: BoxDecoration(
                      color: isSelected 
                          ? AppColors.primaryPurple
                          : AppColors.backgroundTertiary,
                      borderRadius: BorderRadius.circular(AppSpacing.radiusSmall),
                      border: Border.all(
                        color: isSelected 
                            ? AppColors.primaryPurple
                            : AppColors.textTertiary,
                      ),
                    ),
                    child: Text(
                      category,
                      style: TextStyle(
                        color: isSelected 
                            ? Colors.white
                            : AppColors.textPrimary,
                        fontWeight: isSelected 
                            ? FontWeight.bold
                            : FontWeight.normal,
                      ),
                    ),
                  ),
                ),
              );
            }).toList(),
          ),
        ),
      ],
    );
  }


  Color _getCategoryColor(String category) {
    switch (category) {
      case 'Business':
        return AppColors.successGreen;
      case 'Academic':
        return AppColors.infoBlue;
      case 'General':
        return AppColors.warningAmber;
      default:
        return AppColors.primaryPurple;
    }
  }

  IconData _getCategoryIcon(String category) {
    switch (category) {
      case 'Business':
        return Icons.business;
      case 'Academic':
        return Icons.school;
      case 'General':
        return Icons.language;
      default:
        return Icons.category;
    }
  }

  void _showAddAbbreviationDialog() {
    final fullWordController = TextEditingController();
    final abbreviationController = TextEditingController();
    AbbreviationCategory selectedCategory = AbbreviationCategory.common;

    showDialog(
      context: context,
      barrierDismissible: false,
      builder: (context) => StatefulBuilder(
        builder: (context, setState) => Dialog(
        shape: RoundedRectangleBorder(
          borderRadius: BorderRadius.circular(20),
        ),
        elevation: 20,
        child: Container(
          constraints: BoxConstraints(
            maxHeight: MediaQuery.of(context).size.height * 0.8,
            maxWidth: MediaQuery.of(context).size.width * 0.9,
          ),
          padding: const EdgeInsets.all(24),
          decoration: BoxDecoration(
            borderRadius: BorderRadius.circular(20),
            gradient: LinearGradient(
              begin: Alignment.topLeft,
              end: Alignment.bottomRight,
              colors: [
                AppColors.backgroundSecondary,
                AppColors.backgroundSecondary.withOpacity(0.95),
              ],
            ),
            border: Border.all(
              color: AppColors.primaryPurple.withOpacity(0.3),
              width: 2,
            ),
          ),
          child: SingleChildScrollView(
            child: Column(
              mainAxisSize: MainAxisSize.min,
              children: [
              // Add Icon with Animation
              Container(
                width: 80,
                height: 80,
                decoration: BoxDecoration(
                  shape: BoxShape.circle,
                  gradient: RadialGradient(
                    colors: [
                      AppColors.primaryPurple.withOpacity(0.2),
                      AppColors.primaryPurple.withOpacity(0.1),
                    ],
                  ),
                ),
                child: Icon(
                  Icons.add_circle_rounded,
                  size: 40,
                  color: AppColors.primaryPurple,
                ),
              ),
              const SizedBox(height: 20),
              
              // Title
              Text(
                'Add Custom Abbreviation',
                style: TextStyle(
                  fontSize: 24,
                  fontWeight: FontWeight.bold,
                  color: AppColors.textPrimary,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 12),
              
              // Subtitle
              Text(
                'Create your own abbreviation',
                style: TextStyle(
                  fontSize: 16,
                  color: AppColors.textSecondary,
                  fontWeight: FontWeight.w500,
                ),
                textAlign: TextAlign.center,
              ),
              const SizedBox(height: 24),
              
              // Input Fields
              TextField(
                controller: fullWordController,
                decoration: InputDecoration(
                  labelText: 'Full Word/Phrase',
                  hintText: 'e.g., presentation',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              TextField(
                controller: abbreviationController,
                decoration: InputDecoration(
                  labelText: 'Abbreviation',
                  hintText: 'e.g., pres',
                  border: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.textSecondary),
                  ),
                  focusedBorder: OutlineInputBorder(
                    borderRadius: BorderRadius.circular(12),
                    borderSide: BorderSide(color: AppColors.primaryPurple, width: 2),
                  ),
                  contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 12),
                ),
              ),
              const SizedBox(height: 16),
              
              // Category Dropdown
              Container(
                decoration: BoxDecoration(
                  gradient: LinearGradient(
                    colors: [
                      AppColors.backgroundSecondary,
                      AppColors.backgroundSecondary.withOpacity(0.8),
                    ],
                    begin: Alignment.topLeft,
                    end: Alignment.bottomRight,
                  ),
                  borderRadius: BorderRadius.circular(12),
                  border: Border.all(
                    color: AppColors.primaryPurple.withOpacity(0.3),
                    width: 1.5,
                  ),
                  boxShadow: [
                    BoxShadow(
                      color: AppColors.primaryPurple.withOpacity(0.1),
                      spreadRadius: 1,
                      blurRadius: 4,
                      offset: const Offset(0, 2),
                    ),
                  ],
                ),
                child: DropdownButtonFormField<AbbreviationCategory>(
                  value: selectedCategory,
                  decoration: InputDecoration(
                    labelText: 'Select Category',
                    labelStyle: TextStyle(
                      color: AppColors.primaryPurple,
                      fontWeight: FontWeight.w600,
                      fontSize: 14,
                    ),
                    hintText: 'Choose a category',
                    hintStyle: TextStyle(
                      color: AppColors.textSecondary,
                      fontSize: 16,
                    ),
                    border: InputBorder.none,
                    contentPadding: const EdgeInsets.symmetric(horizontal: 16, vertical: 16),
                    prefixIcon: Container(
                      margin: const EdgeInsets.only(right: 8),
                      child: Icon(
                        Icons.category_rounded,
                        color: AppColors.primaryPurple,
                        size: 20,
                      ),
                    ),
                  ),
                  dropdownColor: AppColors.backgroundSecondary,
                  style: TextStyle(
                    color: AppColors.textPrimary,
                    fontSize: 16,
                    fontWeight: FontWeight.w500,
                  ),
                  icon: Icon(
                    Icons.keyboard_arrow_down_rounded,
                    color: AppColors.primaryPurple,
                    size: 24,
                  ),
                  selectedItemBuilder: (BuildContext context) {
                    return AbbreviationCategory.values.map<Widget>((AbbreviationCategory category) {
                      return Container(
                        alignment: Alignment.centerLeft,
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIconFromEnum(category),
                              color: _getCategoryColorFromEnum(category),
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category.categoryText,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      );
                    }).toList();
                  },
                  items: AbbreviationCategory.values.map((category) {
                    return DropdownMenuItem<AbbreviationCategory>(
                      value: category,
                      child: Container(
                        padding: const EdgeInsets.symmetric(vertical: 8, horizontal: 12),
                        decoration: BoxDecoration(
                          color: selectedCategory == category 
                              ? AppColors.primaryPurple.withOpacity(0.1)
                              : Colors.transparent,
                          borderRadius: BorderRadius.circular(8),
                        ),
                        child: Row(
                          children: [
                            Icon(
                              _getCategoryIconFromEnum(category),
                              color: _getCategoryColorFromEnum(category),
                              size: 18,
                            ),
                            const SizedBox(width: 12),
                            Text(
                              category.categoryText,
                              style: TextStyle(
                                color: AppColors.textPrimary,
                                fontSize: 16,
                                fontWeight: FontWeight.w500,
                              ),
                            ),
                          ],
                        ),
                      ),
                    );
                  }).toList(),
                  onChanged: (AbbreviationCategory? newValue) {
                    if (newValue != null) {
                      setState(() {
                        selectedCategory = newValue;
                      });
                    }
                  },
                ),
              ),
              const SizedBox(height: 24),
              
              // Buttons
              Row(
                children: [
                  Expanded(
                    child: Container(
                      height: 48,
                      child: OutlinedButton(
                        onPressed: () => Navigator.of(context).pop(),
                        style: OutlinedButton.styleFrom(
                          side: BorderSide(
                            color: AppColors.textSecondary,
                            width: 1.5,
                          ),
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                        ),
                        child: Text(
                          'Cancel',
                          style: TextStyle(
                            fontSize: 16,
                            fontWeight: FontWeight.w600,
                            color: AppColors.textPrimary,
                          ),
                        ),
                      ),
                    ),
                  ),
                  const SizedBox(width: 12),
                  Expanded(
                    child: Container(
                      height: 48,
                      child: ElevatedButton(
                        onPressed: () {
                          if (fullWordController.text.isNotEmpty && abbreviationController.text.isNotEmpty) {
                            _addCustomAbbreviation(
                              fullWordController.text,
                              abbreviationController.text,
                              selectedCategory.categoryText, // Use selected category
                            );
                            Navigator.of(context).pop();
                            
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: Text('Added: ${fullWordController.text} → ${abbreviationController.text} (${selectedCategory.categoryText})'),
                                backgroundColor: AppColors.successGreen,
                              ),
                            );
                          } else {
                            ScaffoldMessenger.of(context).showSnackBar(
                              SnackBar(
                                content: const Text('Please fill in all fields'),
                                backgroundColor: AppColors.errorRed,
                              ),
                            );
                          }
                        },
                        style: ElevatedButton.styleFrom(
                          backgroundColor: AppColors.primaryPurple,
                          foregroundColor: Colors.white,
                          elevation: 0,
                          shape: RoundedRectangleBorder(
                            borderRadius: BorderRadius.circular(12),
                          ),
                          shadowColor: AppColors.primaryPurple.withOpacity(0.3),
                        ),
                        child: Row(
                          mainAxisAlignment: MainAxisAlignment.center,
                          children: [
                            Icon(
                              Icons.add_circle,
                              size: 18,
                              color: Colors.white,
                            ),
                            const SizedBox(width: 6),
                            Flexible(
                              child: Text(
                                'Add',
                                style: TextStyle(
                                  fontSize: 16,
                                  fontWeight: FontWeight.w600,
                                  color: Colors.white,
                                ),
                                overflow: TextOverflow.ellipsis,
                              ),
                            ),
                          ],
                        ),
                      ),
                    ),
                  ),
                ],
              ),
            ],
          ),
        ),
        ),
      ),
    ),
    );
  }

  void _addCustomAbbreviation(String fullWord, String abbreviation, String category) {
    // Convert string category to AbbreviationCategory enum
    AbbreviationCategory abbreviationCategory;
    switch (category) {
      case 'Business':
        abbreviationCategory = AbbreviationCategory.business;
        break;
      case 'Academic':
        abbreviationCategory = AbbreviationCategory.common;
        break;
      case 'General':
        abbreviationCategory = AbbreviationCategory.custom;
        break;
      default:
        abbreviationCategory = AbbreviationCategory.custom;
    }

    // Create and save the abbreviation using StorageService
    final newAbbreviation = Abbreviation.create(
      fullWord: fullWord,
      abbreviation: abbreviation,
      category: abbreviationCategory,
      description: 'Custom abbreviation added by user',
    );

    // Save to StorageService
    StorageService.saveAbbreviation(newAbbreviation);

    // Trigger UI update by calling setState
    setState(() {
      // No need to add to local list anymore - it will be loaded from database
    });

    print('DEBUG: Added abbreviation to StorageService: $fullWord -> $abbreviation');
  }

  AbbreviationCategory _getCategoryFromString(String category) {
    switch (category.toLowerCase()) {
      case 'business':
        return AbbreviationCategory.business;
      case 'academic':
        return AbbreviationCategory.common;
      case 'general':
        return AbbreviationCategory.custom;
      default:
        return AbbreviationCategory.custom;
    }
  }

  IconData _getCategoryIconFromEnum(AbbreviationCategory category) {
    switch (category) {
      case AbbreviationCategory.business:
        return Icons.business;
      case AbbreviationCategory.common:
        return Icons.school;
      case AbbreviationCategory.custom:
        return Icons.language;
    }
  }

  Color _getCategoryColorFromEnum(AbbreviationCategory category) {
    switch (category) {
      case AbbreviationCategory.business:
        return AppColors.successGreen;
      case AbbreviationCategory.common:
        return AppColors.infoBlue;
      case AbbreviationCategory.custom:
        return AppColors.warningAmber;
    }
  }

}
