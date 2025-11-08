import '../models/exercise.dart';
import 'storage_service.dart';

class SampleDataService {
  static Future<void> seedIfEmpty() async {
    final existing = StorageService.getAllExercises();
    // Force clear existing data and reload with new 15 exercises
    if (existing.isNotEmpty) {
      // Clear existing exercises to load new ones
      await StorageService.clearAllExercises();
    }

    final samples = <Exercise>[
      // BUSINESS EXERCISES
      Exercise(
        id: 'ex_seed_001',
        title: 'Budget Meeting Notes',
        content:
            'Good morning everyone. Let\'s start with our Q3 budget review. Revenue increased 15 percent to 2.5 million dollars, which is excellent. However, our expenses totaled 1.8 million, higher than projected. Marketing department overspent by 50 thousand dollars due to the summer campaign. For Q4, we need to reduce expenses by 10 percent across all departments. HR will implement a hiring freeze, and marketing budget will be cut by 25 percent. We also need to review vendor contracts and negotiate better rates. The CFO will provide detailed analysis next week.',
        idealNotes:
            'Q3 Budget Rev: 2.5M (+15%), Exp: 1.8M. Mktg +50K over. Q4: -10% exp, hiring freeze, mktg -25%, review vendors, CFO analysis nxt wk.',
        difficulty: ExerciseDifficulty.beginner,
        duration: 180,
        category: ExerciseCategory.business,
        isPremium: false,
        estimatedWPM: 35,
        keyTerms: ['revenue', 'expenses', 'marketing', 'Q3', 'Q4', 'hiring freeze', 'vendors', 'CFO'],
        suggestedAbbreviations: ['rev', 'exp', 'mktg', 'budg', 'HR', 'CFO', 'nxt', 'wk'],
        audioFilePath: 'assets/audio/budget_meeting.mp3',
      ),
      Exercise(
        id: 'ex_seed_002',
        title: 'Project Kickoff',
        content:
            'Welcome to the mobile app project kickoff meeting. We\'re developing a new fitness tracking application with a 6-month timeline and 500 thousand dollar budget. Key features include user authentication, payment processing, and push notifications. The development team consists of 5 developers, 2 designers, and 1 project manager. We\'ll use React Native for cross-platform development. The prototype is due in 4 weeks for client review. We\'ll have weekly standup meetings every Tuesday at 10 AM. The testing phase will begin in month 4, and we\'ll launch on both iOS and Android stores simultaneously.',
        idealNotes:
            'Mobile app kickoff: 6mo timeline, \$500K budget. Features: auth, payments, notifications. Team: 5 devs, 2 designers, 1 PM. React Native, proto 4w, weekly standups Tues 10AM, testing mo4, launch iOS+Android.',
        difficulty: ExerciseDifficulty.beginner,
        duration: 180,
        category: ExerciseCategory.business,
        isPremium: false,
        estimatedWPM: 32,
        keyTerms: ['timeline', 'budget', 'features', 'prototype', 'React Native', 'standup', 'testing', 'launch'],
        suggestedAbbreviations: ['auth', 'proto', 'wk', 'mo', 'devs', 'PM', 'iOS', 'Android'],
        audioFilePath: 'assets/audio/project_kickoff.mp3',
      ),
      Exercise(
        id: 'ex_seed_003',
        title: 'Sales Strategy Meeting',
        content:
            'Our Q4 sales strategy focuses on three key areas: customer retention, market expansion, and digital transformation. We\'re launching a new customer loyalty program with tiered benefits based on purchase volume. The program includes exclusive discounts, early access to new products, and dedicated customer support. For market expansion, we\'re targeting the European market with localized marketing campaigns and partnerships with regional distributors. Digital transformation includes upgrading our CRM system, implementing AI-powered lead scoring, and launching a new e-commerce platform with mobile optimization.',
        idealNotes:
            'Q4 Sales Strategy: 3 areas - customer retention, market expansion, digital transformation. Loyalty program: tiered benefits, discounts, early access, dedicated support. Europe expansion: localized marketing, regional distributors. Digital: CRM upgrade, AI lead scoring, new e-commerce platform, mobile optimization.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 200,
        category: ExerciseCategory.business,
        isPremium: false,
        estimatedWPM: 36,
        keyTerms: ['sales strategy', 'customer retention', 'loyalty program', 'market expansion', 'digital transformation', 'CRM', 'AI'],
        suggestedAbbreviations: ['Q4', 'CRM', 'AI', 'mkt', 'cust', 'retention', 'loyalty', 'EU'],
        audioFilePath: 'assets/audio/sales_strategy.mp3',
      ),
      Exercise(
        id: 'ex_seed_004',
        title: 'Team Performance Review',
        content:
            'Let\'s review our team performance for the past quarter. Overall productivity increased by 12 percent, with the engineering team leading at 18 percent improvement. Customer satisfaction scores reached 4.7 out of 5, up from 4.2 last quarter. However, we need to address communication gaps between departments and implement better project management tools. The marketing team exceeded their lead generation targets by 25 percent, while sales closed 15 percent more deals than projected. We\'re implementing weekly cross-functional meetings and upgrading to a new project management platform to improve collaboration.',
        idealNotes:
            'Q Performance: productivity +12%, engineering +18%, customer satisfaction 4.7/5 (was 4.2). Issues: communication gaps, need better PM tools. Marketing: +25% leads, Sales: +15% deals. Solutions: weekly cross-functional meetings, new PM platform.',
        difficulty: ExerciseDifficulty.beginner,
        duration: 160,
        category: ExerciseCategory.business,
        isPremium: false,
        estimatedWPM: 34,
        keyTerms: ['performance', 'productivity', 'customer satisfaction', 'communication', 'project management', 'collaboration'],
        suggestedAbbreviations: ['perf', 'prod', 'cust sat', 'comm', 'PM', 'collab', 'Q'],
        audioFilePath: 'assets/audio/team_performance.mp3',
      ),
      Exercise(
        id: 'ex_seed_005',
        title: 'Product Launch Planning',
        content:
            'Our new AI-powered productivity suite launches in 8 weeks. The product includes document collaboration, task management, and automated workflow features. Pricing strategy: basic plan at 29 dollars monthly, professional at 49 dollars, and enterprise at 99 dollars with custom pricing. Marketing campaign includes social media, content marketing, influencer partnerships, and trade show appearances. We\'re targeting small businesses and remote teams initially. Beta testing with 100 users starts next week, and we\'ll gather feedback for final improvements. Launch event scheduled for December 15th at the Convention Center.',
        idealNotes:
            'AI productivity suite launch: 8wks. Features: doc collaboration, task mgmt, automated workflows. Pricing: basic \$29/mo, pro \$49/mo, enterprise \$99/mo. Marketing: social media, content, influencers, trade shows. Target: small biz, remote teams. Beta: 100 users nxt wk. Launch: Dec 15, Convention Center.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 190,
        category: ExerciseCategory.business,
        isPremium: false,
        estimatedWPM: 37,
        keyTerms: ['product launch', 'AI', 'productivity suite', 'pricing strategy', 'marketing campaign', 'beta testing'],
        suggestedAbbreviations: ['AI', 'prod', 'launch', 'collab', 'mgmt', 'workflows', 'mktg', 'beta', 'biz'],
        audioFilePath: 'assets/audio/product_launch.mp3',
      ),

      // ACADEMIC EXERCISES
      Exercise(
        id: 'ex_seed_006',
        title: 'Research Methods',
        content:
            'Today we\'ll discuss quantitative research methodologies. Quantitative research uses numerical data collected through surveys, experiments, and statistical analysis. Key concepts include validity, which measures accuracy of results, and reliability, which ensures consistency across measurements. Hypothesis testing involves formulating null and alternative hypotheses, then using statistical methods to determine significance. Sample size calculation is crucial for obtaining reliable results. We\'ll also cover correlation versus causation, and how to avoid common biases like selection bias and confirmation bias. The research process includes literature review, methodology design, data collection, analysis, and interpretation of findings.',
        idealNotes:
            'Quant research: numerical data, surveys/experiments, stats analysis. Key: validity (accuracy), reliability (consistency), hypothesis testing (null/alt), sample size calc, correlation vs causation, avoid biases (selection, confirmation). Process: lit review, methodology, data collection, analysis, interpretation.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 240,
        category: ExerciseCategory.academic,
        isPremium: false,
        estimatedWPM: 38,
        keyTerms: ['quantitative', 'surveys', 'experiments', 'validity', 'reliability', 'hypothesis', 'sample size', 'bias'],
        suggestedAbbreviations: ['quant', 'exp', 'valid', 'reliab', 'hypo', 'null/alt', 'calc', 'corr', 'causation'],
        audioFilePath: 'assets/audio/research_methods.mp3',
      ),
      Exercise(
        id: 'ex_seed_007',
        title: 'World War II History',
        content:
            'The Second World War began in 1939 with Germany\'s invasion of Poland, triggering declarations of war from Britain and France. Key turning points included the Battle of Britain in 1940, where the Royal Air Force successfully defended against German air attacks. The United States entered the war in 1941 after the attack on Pearl Harbor. The D-Day invasion in June 1944 marked the beginning of the end for Nazi Germany. The war ended in Europe in May 1945 with Germany\'s surrender, and in the Pacific in September 1945 after atomic bombs were dropped on Hiroshima and Nagasaki. The war resulted in approximately 70 million deaths worldwide.',
        idealNotes:
            'WWII: started 1939, Germany invades Poland, UK/France declare war. Key events: Battle of Britain 1940 (RAF victory), US enters 1941 (Pearl Harbor), D-Day June 1944, Germany surrenders May 1945, atomic bombs Hiroshima/Nagasaki Sept 1945. Deaths: ~70M worldwide.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 200,
        category: ExerciseCategory.academic,
        isPremium: false,
        estimatedWPM: 39,
        keyTerms: ['World War II', 'Germany', 'Poland', 'Battle of Britain', 'Pearl Harbor', 'D-Day', 'atomic bombs'],
        suggestedAbbreviations: ['WWII', 'UK', 'RAF', 'US', 'D-Day', 'atomic', 'Hiroshima', 'Nagasaki'],
        audioFilePath: 'assets/audio/wwii_history.mp3',
      ),
      Exercise(
        id: 'ex_seed_008',
        title: 'Climate Change Science',
        content:
            'Climate change refers to long-term shifts in global temperatures and weather patterns. While climate variations occur naturally, scientific evidence shows human activities are the primary driver since the mid-20th century. Key greenhouse gases include carbon dioxide, methane, and nitrous oxide, which trap heat in Earth\'s atmosphere. Global average temperatures have risen by approximately 1.1 degrees Celsius since pre-industrial times. Effects include rising sea levels, more frequent extreme weather events, and ecosystem disruption. The Paris Agreement aims to limit global warming to well below 2 degrees Celsius above pre-industrial levels.',
        idealNotes:
            'Climate change: long-term temp/weather shifts. Human activities main driver since mid-20th century. Greenhouse gases: CO2, methane, nitrous oxide trap heat. Global temps +1.1°C since pre-industrial. Effects: sea level rise, extreme weather, ecosystem disruption. Paris Agreement: limit warming <2°C.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 180,
        category: ExerciseCategory.academic,
        isPremium: false,
        estimatedWPM: 40,
        keyTerms: ['climate change', 'greenhouse gases', 'carbon dioxide', 'global warming', 'sea levels', 'Paris Agreement'],
        suggestedAbbreviations: ['climate', 'GHG', 'CO2', 'methane', 'warming', 'sea levels', 'Paris'],
        audioFilePath: 'assets/audio/climate_change.mp3',
      ),
      Exercise(
        id: 'ex_seed_009',
        title: 'Machine Learning Fundamentals',
        content:
            'Machine learning is a subset of artificial intelligence that enables computers to learn and make decisions from data without explicit programming. There are three main types: supervised learning using labeled data, unsupervised learning finding patterns in unlabeled data, and reinforcement learning through trial and error. Common algorithms include linear regression, decision trees, neural networks, and support vector machines. Key concepts include training data, feature selection, model evaluation, and overfitting prevention. Applications span image recognition, natural language processing, recommendation systems, and autonomous vehicles.',
        idealNotes:
            'ML: AI subset, computers learn from data without explicit programming. 3 types: supervised (labeled data), unsupervised (unlabeled patterns), reinforcement (trial/error). Algorithms: linear regression, decision trees, neural networks, SVM. Key: training data, feature selection, model eval, overfitting prevention. Apps: image recognition, NLP, recommendations, autonomous vehicles.',
        difficulty: ExerciseDifficulty.advanced,
        duration: 220,
        category: ExerciseCategory.academic,
        isPremium: false,
        estimatedWPM: 42,
        keyTerms: ['machine learning', 'artificial intelligence', 'supervised learning', 'neural networks', 'algorithms', 'overfitting'],
        suggestedAbbreviations: ['ML', 'AI', 'supervised', 'unsupervised', 'reinforcement', 'algorithms', 'neural', 'SVM', 'NLP'],
        audioFilePath: 'assets/audio/machine_learning.mp3',
      ),
      Exercise(
        id: 'ex_seed_010',
        title: 'Psychology of Learning',
        content:
            'Learning psychology examines how humans acquire, retain, and apply knowledge. Key theories include behaviorism, which focuses on observable behaviors and reinforcement, and cognitivism, which emphasizes mental processes and information processing. Constructivism suggests learners build knowledge through experience and reflection. Memory systems include sensory memory, short-term memory with limited capacity, and long-term memory with unlimited storage. Effective learning strategies include spaced repetition, active recall, and interleaving different topics. Factors affecting learning include motivation, attention, prior knowledge, and environmental conditions.',
        idealNotes:
            'Learning psych: how humans acquire/retain/apply knowledge. Theories: behaviorism (observable behaviors, reinforcement), cognitivism (mental processes), constructivism (build knowledge through experience). Memory: sensory, short-term (limited), long-term (unlimited). Strategies: spaced repetition, active recall, interleaving. Factors: motivation, attention, prior knowledge, environment.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 210,
        category: ExerciseCategory.academic,
        isPremium: false,
        estimatedWPM: 41,
        keyTerms: ['learning psychology', 'behaviorism', 'cognitivism', 'constructivism', 'memory systems', 'learning strategies'],
        suggestedAbbreviations: ['psych', 'behaviorism', 'cognitivism', 'constructivism', 'memory', 'strategies', 'motivation'],
        audioFilePath: 'assets/audio/learning_psychology.mp3',
      ),

      // GENERAL EXERCISES
      Exercise(
        id: 'ex_seed_011',
        title: 'Healthy Lifestyle Tips',
        content:
            'Maintaining a healthy lifestyle involves several key components. Regular physical activity, at least 150 minutes of moderate exercise weekly, strengthens cardiovascular health and improves mental well-being. A balanced diet rich in fruits, vegetables, whole grains, and lean proteins provides essential nutrients while limiting processed foods and added sugars. Quality sleep of 7-9 hours nightly supports immune function and cognitive performance. Stress management through meditation, deep breathing, or hobbies helps prevent chronic health issues. Regular health check-ups and preventive screenings catch potential problems early. Hydration with 8 glasses of water daily supports all bodily functions.',
        idealNotes:
            'Healthy lifestyle: regular exercise (150min/week), balanced diet (fruits, veggies, whole grains, lean proteins, limit processed/sugar), quality sleep (7-9hrs), stress mgmt (meditation, breathing, hobbies), regular check-ups, hydration (8 glasses water/day).',
        difficulty: ExerciseDifficulty.beginner,
        duration: 170,
        category: ExerciseCategory.general,
        isPremium: false,
        estimatedWPM: 33,
        keyTerms: ['healthy lifestyle', 'physical activity', 'balanced diet', 'sleep', 'stress management', 'hydration'],
        suggestedAbbreviations: ['healthy', 'exercise', 'diet', 'sleep', 'stress', 'mgmt', 'hydration'],
        audioFilePath: 'assets/audio/healthy_lifestyle.mp3',
      ),
      Exercise(
        id: 'ex_seed_012',
        title: 'Travel Planning Guide',
        content:
            'Effective travel planning involves several essential steps. First, research your destination\'s climate, culture, and local customs to pack appropriately and behave respectfully. Book accommodations well in advance, especially during peak seasons, and consider location proximity to attractions and public transportation. Create a flexible itinerary with must-see attractions while leaving room for spontaneous discoveries. Purchase travel insurance to protect against trip cancellations, medical emergencies, and lost luggage. Check visa requirements and ensure your passport has sufficient validity. Download offline maps, translation apps, and currency converters for convenience. Inform your bank of travel plans to prevent card blocks.',
        idealNotes:
            'Travel planning: research destination (climate, culture, customs), book accommodations early (consider location, peak seasons), flexible itinerary (must-sees + spontaneous), travel insurance (cancellations, medical, lost luggage), check visa/passport validity, download offline maps/translation/currency apps, inform bank of travel.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 190,
        category: ExerciseCategory.general,
        isPremium: false,
        estimatedWPM: 35,
        keyTerms: ['travel planning', 'destination research', 'accommodations', 'itinerary', 'travel insurance', 'visa requirements'],
        suggestedAbbreviations: ['travel', 'dest', 'accommodations', 'itinerary', 'insurance', 'visa', 'passport'],
        audioFilePath: 'assets/audio/travel_planning.mp3',
      ),
      Exercise(
        id: 'ex_seed_013',
        title: 'Financial Investment Basics',
        content:
            'Investment fundamentals begin with understanding different asset classes and risk levels. Stocks represent ownership in companies and offer high potential returns but with significant volatility. Bonds are debt securities providing steady income with lower risk. Mutual funds pool money from multiple investors to buy diversified portfolios managed by professionals. Exchange-traded funds combine benefits of stocks and mutual funds with lower fees. Key principles include diversification across different sectors and asset classes, dollar-cost averaging to reduce timing risk, and long-term perspective for compound growth. Start with emergency fund, pay high-interest debt, then invest in retirement accounts before taxable investments.',
        idealNotes:
            'Investment basics: asset classes (stocks - ownership, high returns/volatility; bonds - debt, steady income/low risk; mutual funds - pooled/diversified; ETFs - stocks+funds benefits, lower fees). Principles: diversification, dollar-cost averaging, long-term perspective. Steps: emergency fund, pay debt, retirement accounts, then taxable investments.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 200,
        category: ExerciseCategory.general,
        isPremium: false,
        estimatedWPM: 37,
        keyTerms: ['investment', 'asset classes', 'stocks', 'bonds', 'mutual funds', 'ETFs', 'diversification'],
        suggestedAbbreviations: ['invest', 'assets', 'stocks', 'bonds', 'funds', 'ETFs', 'diversification', 'retirement'],
        audioFilePath: 'assets/audio/investment_basics.mp3',
      ),
      Exercise(
        id: 'ex_seed_014',
        title: 'Cooking Techniques Masterclass',
        content:
            'Mastering fundamental cooking techniques transforms basic ingredients into delicious meals. Sautéing involves cooking food quickly in a small amount of oil over medium-high heat, perfect for vegetables and proteins. Roasting uses dry heat in an oven to caramelize surfaces and develop deep flavors. Braising combines searing and slow cooking in liquid, ideal for tough cuts of meat. Steaming preserves nutrients and natural flavors while keeping food moist. Knife skills are crucial: use sharp knives, proper grip, and consistent cutting techniques for even cooking. Seasoning with salt enhances natural flavors, while herbs and spices add complexity. Temperature control prevents overcooking and ensures food safety.',
        idealNotes:
            'Cooking techniques: sautéing (quick, small oil, med-high heat, veggies/proteins), roasting (dry oven heat, caramelization), braising (sear+slow cook in liquid, tough meats), steaming (preserves nutrients, moist). Knife skills: sharp knives, proper grip, consistent cuts. Seasoning: salt enhances flavors, herbs/spices add complexity. Temp control: prevents overcooking, food safety.',
        difficulty: ExerciseDifficulty.intermediate,
        duration: 210,
        category: ExerciseCategory.general,
        isPremium: false,
        estimatedWPM: 36,
        keyTerms: ['cooking techniques', 'sautéing', 'roasting', 'braising', 'steaming', 'knife skills', 'seasoning'],
        suggestedAbbreviations: ['cooking', 'techniques', 'sautéing', 'roasting', 'braising', 'steaming', 'knife', 'seasoning'],
        audioFilePath: 'assets/audio/cooking_techniques.mp3',
      ),
      Exercise(
        id: 'ex_seed_015',
        title: 'Digital Privacy & Security',
        content:
            'Protecting your digital privacy requires understanding common threats and implementing security measures. Use strong, unique passwords for each account and enable two-factor authentication whenever possible. Regularly update software and operating systems to patch security vulnerabilities. Be cautious with public Wi-Fi networks and use VPN services for sensitive activities. Review and adjust privacy settings on social media platforms to limit data sharing. Avoid clicking suspicious links in emails or messages, as phishing attacks are increasingly sophisticated. Use encrypted messaging apps for sensitive communications. Regularly back up important data to multiple locations, including cloud storage with encryption. Monitor your accounts for unauthorized access and report suspicious activity immediately.',
        idealNotes:
            'Digital privacy/security: strong unique passwords, 2FA, regular software updates, cautious with public Wi-Fi (use VPN), adjust social media privacy settings, avoid suspicious links (phishing), encrypted messaging, regular backups (multiple locations, encrypted cloud), monitor accounts for unauthorized access.',
        difficulty: ExerciseDifficulty.advanced,
        duration: 220,
        category: ExerciseCategory.general,
        isPremium: false,
        estimatedWPM: 39,
        keyTerms: ['digital privacy', 'passwords', 'two-factor authentication', 'software updates', 'VPN', 'phishing', 'encryption'],
        suggestedAbbreviations: ['privacy', 'security', 'passwords', '2FA', 'updates', 'VPN', 'phishing', 'encryption'],
        audioFilePath: 'assets/audio/digital_privacy.mp3',
      ),
    ];

    await StorageService.saveExercises(samples);
  }

  // Debug method to force reload exercises
  static Future<void> forceReloadExercises() async {
    await StorageService.clearAllExercises();
    await seedIfEmpty();
  }
}


