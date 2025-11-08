#!/usr/bin/env python3
"""
Simple script to help generate audio files for the Short Notes Trainer app.
This script uses Google Text-to-Speech (gTTS) to generate MP3 files.

Requirements:
pip install gtts

Usage:
python generate_audio.py
"""

try:
    from gtts import gTTS
    import os
    
    # Exercise content to convert to audio
    exercises = [
        {
            "filename": "budget_meeting.mp3",
            "text": "Today we reviewed Q3 budget: revenue up 15 percent to 2.5M, expenses 1.8M. Marketing overspend 50K. Reduce Q4 expenses by 10 percent."
        },
        {
            "filename": "project_kickoff.mp3", 
            "text": "New mobile app: 6 month timeline, 500K budget, features auth, payments, notifications. Prototype due in 4 weeks."
        },
        {
            "filename": "research_methods.mp3",
            "text": "Quantitative research uses numerical data, surveys and experiments. Key ideas: validity, reliability, hypothesis testing."
        }
    ]
    
    print("🎵 Generating audio files for Short Notes Trainer...")
    print("=" * 50)
    
    for exercise in exercises:
        print(f"Creating: {exercise['filename']}")
        
        # Create TTS object
        tts = gTTS(text=exercise['text'], lang='en', slow=False)
        
        # Save the audio file
        tts.save(exercise['filename'])
        
        print(f"✅ Generated: {exercise['filename']}")
        print(f"   Content: {exercise['text'][:50]}...")
        print()
    
    print("🎉 All audio files generated successfully!")
    print("\nFiles created:")
    for exercise in exercises:
        if os.path.exists(exercise['filename']):
            size = os.path.getsize(exercise['filename'])
            print(f"  - {exercise['filename']} ({size} bytes)")
    
    print("\n📱 Next steps:")
    print("1. Move these files to your Flutter project's assets/audio/ folder")
    print("2. Run 'flutter pub get' to install dependencies")
    print("3. Test the audio playback in your app")
    
except ImportError:
    print("❌ gTTS library not found!")
    print("\nTo install it, run:")
    print("pip install gtts")
    print("\nOr use alternative methods:")
    print("1. Use online TTS services (Google, Amazon Polly)")
    print("2. Record your voice manually")
    print("3. Use AI voice generators")
    
except Exception as e:
    print(f"❌ Error generating audio files: {e}")
    print("\nAlternative methods:")
    print("1. Use online TTS services")
    print("2. Record your voice manually") 
    print("3. Use AI voice generators")

