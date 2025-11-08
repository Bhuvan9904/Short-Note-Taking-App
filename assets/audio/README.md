# Audio Files Required

## Required Audio Files

You need to create the following audio files and place them in the `assets/audio/` directory:

### 1. Budget Meeting Notes
- **File**: `budget_meeting.mp3`
- **Content**: "Today we reviewed Q3 budget: revenue up 15 percent to 2.5M, expenses 1.8M. Marketing overspend 50K. Reduce Q4 expenses by 10 percent."
- **Duration**: Approximately 2 minutes
- **Speed**: Normal speaking pace (120-150 WPM)

### 2. Project Kickoff
- **File**: `project_kickoff.mp3`
- **Content**: "New mobile app: 6 month timeline, 500K budget, features auth, payments, notifications. Prototype due in 4 weeks."
- **Duration**: Approximately 2 minutes
- **Speed**: Normal speaking pace (120-150 WPM)

### 3. Research Methods
- **File**: `research_methods.mp3`
- **Content**: "Quantitative research uses numerical data, surveys and experiments. Key ideas: validity, reliability, hypothesis testing."
- **Duration**: Approximately 2.5 minutes
- **Speed**: Normal speaking pace (120-150 WPM)

## How to Create Audio Files

### Option 1: Text-to-Speech (Recommended)
1. Use online TTS services like:
   - Google Text-to-Speech
   - Amazon Polly
   - Azure Cognitive Services
   - ElevenLabs
2. Copy the exact content from each exercise
3. Generate MP3 files
4. Place them in the `assets/audio/` directory

### Option 2: Record Your Voice
1. Read the content naturally
2. Record using any audio recording software
3. Export as MP3 format
4. Place in `assets/audio/` directory

### Option 3: Use AI Voice Generators
1. Use ChatGPT Voice or similar AI tools
2. Generate speech from the text content
3. Download as MP3
4. Place in `assets/audio/` directory

## File Format Requirements
- **Format**: MP3
- **Quality**: 44.1kHz, 128kbps minimum
- **Duration**: Match the exercise duration (2-2.5 minutes)
- **Speed**: Natural speaking pace for note-taking practice

## After Adding Files
1. Run `flutter pub get` to install the just_audio package
2. Run `flutter pub run build_runner build` to regenerate Hive models
3. Test the audio playback in the app

## Notes
- The app will show an error message if audio files are missing
- Audio files should be clear and professional
- Consider using a consistent voice/accent across all files
- Test playback speed controls (0.5x to 2.0x) work properly

