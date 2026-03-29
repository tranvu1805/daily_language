// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for English (`en`).
class AppLocalizationsEn extends AppLocalizations {
  AppLocalizationsEn([String locale = 'en']) : super(locale);

  @override
  String get dailyLanguage => 'Daily Language';

  @override
  String get continueWith => 'Continue with';

  @override
  String get home => 'Home';

  @override
  String get diary => 'Diary';

  @override
  String get profile => 'Profile';

  @override
  String get words => 'Words';

  @override
  String get fullName => 'Full Name';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Phone Number';

  @override
  String get streak => 'Streak';

  @override
  String get edit => 'Edit';

  @override
  String get editProfile => 'Edit Profile';

  @override
  String get confirm => 'Confirm';

  @override
  String get cancel => 'Cancel';

  @override
  String get save => 'Save';

  @override
  String get logOut => 'Log Out';

  @override
  String get empty => 'No data available';

  @override
  String get required => 'This field is required';

  @override
  String get invalidPhoneNumber => 'Invalid phone number';

  @override
  String get invalidEmail => 'Invalid email';

  @override
  String get updateSuccess => 'Updated successfully';

  @override
  String get welcomeBack => 'Welcome back';

  @override
  String get currentStreak => 'Current Streak';

  @override
  String get highestStreak => 'Highest Streak';

  @override
  String get recentDiary => 'Recent Diary';

  @override
  String get myVocabulary => 'My Vocabulary';

  @override
  String get seeAll => 'See All';

  @override
  String get review => 'Review';

  @override
  String get days => 'days';

  @override
  String get reviewWords => 'Review Words';

  @override
  String get chooseLanguage => 'Choose Language';

  @override
  String get appLanguage => 'App Language';

  @override
  String get learningLanguage => 'Learning Language';

  @override
  String get version => 'Version';

  @override
  String get notifications => 'Notifications';

  @override
  String get learningReminders => 'Learning Reminders';

  @override
  String get help => 'Help';

  @override
  String get guidesAndFAQ => 'Guides & FAQ';

  @override
  String get privacyPolicy => 'Privacy Policy';

  @override
  String get termsOfService => 'Terms of Service';

  @override
  String get functions => 'Functions';

  @override
  String get personalInfo => 'Personal Information';

  @override
  String get updateProfile => 'Update Profile';

  @override
  String get logoutConfirm => 'Are you sure you want to log out?';

  @override
  String get todayPrompt => 'Today\'s Prompt';

  @override
  String get dailyReview => 'Daily Review';

  @override
  String reviewReady(int count) {
    return 'You have $count words ready to review!';
  }

  @override
  String get noReviewToday => 'No words to review today. Keep learning!';

  @override
  String get write => 'Write';

  @override
  String get todayPromptQuestion => 'What made you happy today?';

  @override
  String get reviewCompleted => 'Review Completed! 🥳';

  @override
  String get reviewFinishedMessage =>
      'You have finished all your reviews for now. Great job!';

  @override
  String get backToLearning => 'Back to My Learning';

  @override
  String get correctKeepItUp => 'Correct! Keep it up!';

  @override
  String get incorrectWordIsAbove => 'Oops! The correct word is above.';

  @override
  String get reviewSession => 'Review Session';

  @override
  String get emotionQuestion => 'How are you feeling?';

  @override
  String get category => 'Category';

  @override
  String get saveRecord => 'Save Record';

  @override
  String get emptyError => 'Please write something';

  @override
  String get addRecord => 'Add Record';

  @override
  String get editRecord => 'Edit Record';

  @override
  String get update => 'Update';

  @override
  String get aiOnlyEnglish =>
      'AI Review only supports English, please change to English mode';

  @override
  String get enterTextReview => 'Please enter some text to review';

  @override
  String get updateRecord => 'Update Record';

  @override
  String get unknown => 'Unknown';

  @override
  String get nextReview => 'Next review';

  @override
  String stage(int stage) {
    return 'Stage $stage';
  }

  @override
  String get myLearning => 'My Learning';

  @override
  String get oxfordWordLists => 'Oxford Word Lists';

  @override
  String wordsCount(int count) {
    return '$count words';
  }

  @override
  String get beginner => 'Beginner';

  @override
  String get elementary => 'Elementary';

  @override
  String get intermediate => 'Intermediate';

  @override
  String get upperIntermediate => 'Upper-Intermediate';

  @override
  String get advanced => 'Advanced';

  @override
  String get grammarChecker => 'Grammar Checker';

  @override
  String get grammarCheckDescription =>
      'Improve your writing with AI-powered grammar check.';

  @override
  String get grammarCheckHint => 'Type or paste your English text here...';

  @override
  String get checkNow => 'Check Now';

  @override
  String get aiAnalysis => 'AI Analysis';

  @override
  String get detailedExplanation => 'Detailed Explanation';

  @override
  String get original => 'Original';

  @override
  String get improved => 'Improved';

  @override
  String get perfect => 'Perfect';

  @override
  String get wordDetails => 'Word Details';

  @override
  String get audioError => 'Could not play audio';

  @override
  String get wordAdded => 'Word added to My Words';

  @override
  String get wordNotFound => 'Word not found';

  @override
  String get englishMeaning => 'English Meaning';

  @override
  String get vietnameseMeaning => 'Vietnamese Meaning';

  @override
  String get relations => 'Relations';

  @override
  String get synonyms => 'Synonyms:';

  @override
  String get antonyms => 'Antonyms:';

  @override
  String get addToMyWords => 'Add to My Words';

  @override
  String get myWords => 'My Words';

  @override
  String get personalVocabulary => 'Your personal vocabulary';

  @override
  String oxfordTopic(String topic) {
    return 'Oxford $topic';
  }

  @override
  String levelWordsCount(String level, int count) {
    return '$level · $count words';
  }

  @override
  String addedWordToMyWords(String word) {
    return 'Added \"$word\" to your words';
  }

  @override
  String get tapToReview => 'Tap to review →';

  @override
  String get noWordsYet => 'No words yet';

  @override
  String get startAddingWords =>
      'Start adding words from your diary\nor tap + to add manually.';

  @override
  String get speechUnavailable => 'Speech recognition unavailable';

  @override
  String get writeThoughts => 'Write your thoughts';

  @override
  String get englishTranslation => 'English translation';

  @override
  String get whatHappenedToday => 'What happened today?';

  @override
  String get translationHint => 'Translated content will appear here';

  @override
  String get processing => 'Processing…';

  @override
  String get listening => 'Listening…';

  @override
  String get speakNow => 'Speak now — we\'ll transcribe your words.';

  @override
  String get stopRecording => 'Stop Recording';

  @override
  String get happy => 'Happy';

  @override
  String get sad => 'Sad';

  @override
  String get angry => 'Angry';

  @override
  String get scared => 'Scared';

  @override
  String get calm => 'Calm';

  @override
  String get thinking => 'Thinking';

  @override
  String get daily => 'Daily';

  @override
  String get study => 'Study';

  @override
  String get work => 'Work';

  @override
  String get travel => 'Travel';

  @override
  String get food => 'Food';

  @override
  String get other => 'Other';

  @override
  String get aiReviewSupport =>
      'AI Review only supports English, please change to English mode';

  @override
  String get enterTextToReview => 'Please enter some text to review';

  @override
  String get aiReviewLimitReached => 'Daily AI Review limit reached (3/3)';

  @override
  String get getMoreTurns => 'Get More';

  @override
  String get watchAdToGetTurn => 'Watch an ad to get 1 more AI review turn';

  @override
  String aiReviewTurnsLeft(int count) {
    return 'AI Review turns left: $count';
  }

  @override
  String get english => 'English';

  @override
  String get vietnamese => 'Vietnamese';

  @override
  String get stopReviewingQuestion =>
      'Are you sure you want to stop reviewing?';

  @override
  String get stop => 'Stop';

  @override
  String get exit => 'Exit';

  @override
  String get continueText => 'Continue';

  @override
  String get exitReviewQuestion =>
      'Are you sure you want to exit? Your progress for this session will be lost.';

  @override
  String failedToLoadWords(String error) {
    return 'Failed to load words: $error';
  }

  @override
  String get retry => 'Retry';

  @override
  String wordCountProgress(int current, int total) {
    return 'Word $current of $total';
  }

  @override
  String get definition => 'Definition';

  @override
  String get nextWord => 'Next Word';

  @override
  String get checkAnswer => 'Check Answer';

  @override
  String get noDiaryEntries => 'No diary entries yet. Start writing!';

  @override
  String get dataNotFound => 'Data does not exist';

  @override
  String get googleSignInFailed => 'Google sign-in failed';

  @override
  String get wordAlreadyExists => 'This word already exists in your collection';

  @override
  String unknownError(String message) {
    return 'Unknown error: $message';
  }

  @override
  String get permissionDenied =>
      'You do not have permission to perform this operation';

  @override
  String get alreadyExists => 'Data already exists';

  @override
  String get resourceExhausted => 'Quota exceeded, please try again later';

  @override
  String get failedPrecondition => 'Invalid operation';

  @override
  String get aborted => 'Operation aborted, please try again';

  @override
  String get outOfRange => 'Value out of range';

  @override
  String get unavailable =>
      'Service temporarily unavailable, please try again later';

  @override
  String get dataLoss => 'Data loss or corruption';

  @override
  String get deadlineExceeded => 'Request timed out';

  @override
  String get cancelled => 'Request cancelled';

  @override
  String get userNotFound => 'Account does not exist';

  @override
  String get wrongPassword => 'Incorrect password';

  @override
  String get emailAlreadyInUse => 'Email is already in use';

  @override
  String get weakPassword => 'Password is too weak';

  @override
  String get userDisabled => 'Account has been disabled';

  @override
  String get tooManyRequests => 'Too many requests, please try again later';

  @override
  String get operationNotAllowed => 'Operation not allowed';

  @override
  String get accountExistsWithDifferentCredential =>
      'Account exists with different sign-in method';

  @override
  String get invalidCredential => 'Invalid credentials';

  @override
  String get networkRequestFailed =>
      'Network error, please check your connection';

  @override
  String get connectionTimeout => 'Connection timed out';

  @override
  String cacheError(String message) {
    return 'Cache error: $message';
  }

  @override
  String reminderSetAt(String time) {
    return 'Reminder set at $time';
  }
}
