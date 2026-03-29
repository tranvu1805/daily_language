import 'dart:async';

import 'package:flutter/foundation.dart';
import 'package:flutter/widgets.dart';
import 'package:flutter_localizations/flutter_localizations.dart';
import 'package:intl/intl.dart' as intl;

import 'app_localizations_en.dart';
import 'app_localizations_vi.dart';

// ignore_for_file: type=lint

/// Callers can lookup localized strings with an instance of AppLocalizations
/// returned by `AppLocalizations.of(context)`.
///
/// Applications need to include `AppLocalizations.delegate()` in their app's
/// `localizationDelegates` list, and the locales they support in the app's
/// `supportedLocales` list. For example:
///
/// ```dart
/// import 'l10n/app_localizations.dart';
///
/// return MaterialApp(
///   localizationsDelegates: AppLocalizations.localizationsDelegates,
///   supportedLocales: AppLocalizations.supportedLocales,
///   home: MyApplicationHome(),
/// );
/// ```
///
/// ## Update pubspec.yaml
///
/// Please make sure to update your pubspec.yaml to include the following
/// packages:
///
/// ```yaml
/// dependencies:
///   # Internationalization support.
///   flutter_localizations:
///     sdk: flutter
///   intl: any # Use the pinned version from flutter_localizations
///
///   # Rest of dependencies
/// ```
///
/// ## iOS Applications
///
/// iOS applications define key application metadata, including supported
/// locales, in an Info.plist file that is built into the application bundle.
/// To configure the locales supported by your app, you’ll need to edit this
/// file.
///
/// First, open your project’s ios/Runner.xcworkspace Xcode workspace file.
/// Then, in the Project Navigator, open the Info.plist file under the Runner
/// project’s Runner folder.
///
/// Next, select the Information Property List item, select Add Item from the
/// Editor menu, then select Localizations from the pop-up menu.
///
/// Select and expand the newly-created Localizations item then, for each
/// locale your application supports, add a new item and select the locale
/// you wish to add from the pop-up menu in the Value field. This list should
/// be consistent with the languages listed in the AppLocalizations.supportedLocales
/// property.
abstract class AppLocalizations {
  AppLocalizations(String locale)
    : localeName = intl.Intl.canonicalizedLocale(locale.toString());

  final String localeName;

  static AppLocalizations? of(BuildContext context) {
    return Localizations.of<AppLocalizations>(context, AppLocalizations);
  }

  static const LocalizationsDelegate<AppLocalizations> delegate =
      _AppLocalizationsDelegate();

  /// A list of this localizations delegate along with the default localizations
  /// delegates.
  ///
  /// Returns a list of localizations delegates containing this delegate along with
  /// GlobalMaterialLocalizations.delegate, GlobalCupertinoLocalizations.delegate,
  /// and GlobalWidgetsLocalizations.delegate.
  ///
  /// Additional delegates can be added by appending to this list in
  /// MaterialApp. This list does not have to be used at all if a custom list
  /// of delegates is preferred or required.
  static const List<LocalizationsDelegate<dynamic>> localizationsDelegates =
      <LocalizationsDelegate<dynamic>>[
        delegate,
        GlobalMaterialLocalizations.delegate,
        GlobalCupertinoLocalizations.delegate,
        GlobalWidgetsLocalizations.delegate,
      ];

  /// A list of this localizations delegate's supported locales.
  static const List<Locale> supportedLocales = <Locale>[
    Locale('en'),
    Locale('vi'),
  ];

  /// No description provided for @dailyLanguage.
  ///
  /// In en, this message translates to:
  /// **'Daily Language'**
  String get dailyLanguage;

  /// No description provided for @continueWith.
  ///
  /// In en, this message translates to:
  /// **'Continue with'**
  String get continueWith;

  /// No description provided for @home.
  ///
  /// In en, this message translates to:
  /// **'Home'**
  String get home;

  /// No description provided for @diary.
  ///
  /// In en, this message translates to:
  /// **'Diary'**
  String get diary;

  /// No description provided for @profile.
  ///
  /// In en, this message translates to:
  /// **'Profile'**
  String get profile;

  /// No description provided for @words.
  ///
  /// In en, this message translates to:
  /// **'Words'**
  String get words;

  /// No description provided for @fullName.
  ///
  /// In en, this message translates to:
  /// **'Full Name'**
  String get fullName;

  /// No description provided for @email.
  ///
  /// In en, this message translates to:
  /// **'Email'**
  String get email;

  /// No description provided for @phoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Phone Number'**
  String get phoneNumber;

  /// No description provided for @streak.
  ///
  /// In en, this message translates to:
  /// **'Streak'**
  String get streak;

  /// No description provided for @edit.
  ///
  /// In en, this message translates to:
  /// **'Edit'**
  String get edit;

  /// No description provided for @editProfile.
  ///
  /// In en, this message translates to:
  /// **'Edit Profile'**
  String get editProfile;

  /// No description provided for @confirm.
  ///
  /// In en, this message translates to:
  /// **'Confirm'**
  String get confirm;

  /// No description provided for @cancel.
  ///
  /// In en, this message translates to:
  /// **'Cancel'**
  String get cancel;

  /// No description provided for @save.
  ///
  /// In en, this message translates to:
  /// **'Save'**
  String get save;

  /// No description provided for @logOut.
  ///
  /// In en, this message translates to:
  /// **'Log Out'**
  String get logOut;

  /// No description provided for @empty.
  ///
  /// In en, this message translates to:
  /// **'No data available'**
  String get empty;

  /// No description provided for @required.
  ///
  /// In en, this message translates to:
  /// **'This field is required'**
  String get required;

  /// No description provided for @invalidPhoneNumber.
  ///
  /// In en, this message translates to:
  /// **'Invalid phone number'**
  String get invalidPhoneNumber;

  /// No description provided for @invalidEmail.
  ///
  /// In en, this message translates to:
  /// **'Invalid email'**
  String get invalidEmail;

  /// No description provided for @updateSuccess.
  ///
  /// In en, this message translates to:
  /// **'Updated successfully'**
  String get updateSuccess;

  /// No description provided for @welcomeBack.
  ///
  /// In en, this message translates to:
  /// **'Welcome back'**
  String get welcomeBack;

  /// No description provided for @currentStreak.
  ///
  /// In en, this message translates to:
  /// **'Current Streak'**
  String get currentStreak;

  /// No description provided for @highestStreak.
  ///
  /// In en, this message translates to:
  /// **'Highest Streak'**
  String get highestStreak;

  /// No description provided for @recentDiary.
  ///
  /// In en, this message translates to:
  /// **'Recent Diary'**
  String get recentDiary;

  /// No description provided for @myVocabulary.
  ///
  /// In en, this message translates to:
  /// **'My Vocabulary'**
  String get myVocabulary;

  /// No description provided for @seeAll.
  ///
  /// In en, this message translates to:
  /// **'See All'**
  String get seeAll;

  /// No description provided for @review.
  ///
  /// In en, this message translates to:
  /// **'Review'**
  String get review;

  /// No description provided for @days.
  ///
  /// In en, this message translates to:
  /// **'days'**
  String get days;

  /// No description provided for @reviewWords.
  ///
  /// In en, this message translates to:
  /// **'Review Words'**
  String get reviewWords;

  /// No description provided for @chooseLanguage.
  ///
  /// In en, this message translates to:
  /// **'Choose Language'**
  String get chooseLanguage;

  /// No description provided for @appLanguage.
  ///
  /// In en, this message translates to:
  /// **'App Language'**
  String get appLanguage;

  /// No description provided for @learningLanguage.
  ///
  /// In en, this message translates to:
  /// **'Learning Language'**
  String get learningLanguage;

  /// No description provided for @version.
  ///
  /// In en, this message translates to:
  /// **'Version'**
  String get version;

  /// No description provided for @notifications.
  ///
  /// In en, this message translates to:
  /// **'Notifications'**
  String get notifications;

  /// No description provided for @learningReminders.
  ///
  /// In en, this message translates to:
  /// **'Learning Reminders'**
  String get learningReminders;

  /// No description provided for @help.
  ///
  /// In en, this message translates to:
  /// **'Help'**
  String get help;

  /// No description provided for @guidesAndFAQ.
  ///
  /// In en, this message translates to:
  /// **'Guides & FAQ'**
  String get guidesAndFAQ;

  /// No description provided for @privacyPolicy.
  ///
  /// In en, this message translates to:
  /// **'Privacy Policy'**
  String get privacyPolicy;

  /// No description provided for @termsOfService.
  ///
  /// In en, this message translates to:
  /// **'Terms of Service'**
  String get termsOfService;

  /// No description provided for @functions.
  ///
  /// In en, this message translates to:
  /// **'Functions'**
  String get functions;

  /// No description provided for @personalInfo.
  ///
  /// In en, this message translates to:
  /// **'Personal Information'**
  String get personalInfo;

  /// No description provided for @updateProfile.
  ///
  /// In en, this message translates to:
  /// **'Update Profile'**
  String get updateProfile;

  /// No description provided for @logoutConfirm.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to log out?'**
  String get logoutConfirm;

  /// No description provided for @todayPrompt.
  ///
  /// In en, this message translates to:
  /// **'Today\'s Prompt'**
  String get todayPrompt;

  /// No description provided for @dailyReview.
  ///
  /// In en, this message translates to:
  /// **'Daily Review'**
  String get dailyReview;

  /// No description provided for @reviewReady.
  ///
  /// In en, this message translates to:
  /// **'You have {count} words ready to review!'**
  String reviewReady(int count);

  /// No description provided for @noReviewToday.
  ///
  /// In en, this message translates to:
  /// **'No words to review today. Keep learning!'**
  String get noReviewToday;

  /// No description provided for @write.
  ///
  /// In en, this message translates to:
  /// **'Write'**
  String get write;

  /// No description provided for @todayPromptQuestion.
  ///
  /// In en, this message translates to:
  /// **'What made you happy today?'**
  String get todayPromptQuestion;

  /// No description provided for @reviewCompleted.
  ///
  /// In en, this message translates to:
  /// **'Review Completed! 🥳'**
  String get reviewCompleted;

  /// No description provided for @reviewFinishedMessage.
  ///
  /// In en, this message translates to:
  /// **'You have finished all your reviews for now. Great job!'**
  String get reviewFinishedMessage;

  /// No description provided for @backToLearning.
  ///
  /// In en, this message translates to:
  /// **'Back to My Learning'**
  String get backToLearning;

  /// No description provided for @correctKeepItUp.
  ///
  /// In en, this message translates to:
  /// **'Correct! Keep it up!'**
  String get correctKeepItUp;

  /// No description provided for @incorrectWordIsAbove.
  ///
  /// In en, this message translates to:
  /// **'Oops! The correct word is above.'**
  String get incorrectWordIsAbove;

  /// No description provided for @reviewSession.
  ///
  /// In en, this message translates to:
  /// **'Review Session'**
  String get reviewSession;

  /// No description provided for @emotionQuestion.
  ///
  /// In en, this message translates to:
  /// **'How are you feeling?'**
  String get emotionQuestion;

  /// No description provided for @category.
  ///
  /// In en, this message translates to:
  /// **'Category'**
  String get category;

  /// No description provided for @saveRecord.
  ///
  /// In en, this message translates to:
  /// **'Save Record'**
  String get saveRecord;

  /// No description provided for @emptyError.
  ///
  /// In en, this message translates to:
  /// **'Please write something'**
  String get emptyError;

  /// No description provided for @addRecord.
  ///
  /// In en, this message translates to:
  /// **'Add Record'**
  String get addRecord;

  /// No description provided for @editRecord.
  ///
  /// In en, this message translates to:
  /// **'Edit Record'**
  String get editRecord;

  /// No description provided for @update.
  ///
  /// In en, this message translates to:
  /// **'Update'**
  String get update;

  /// No description provided for @aiOnlyEnglish.
  ///
  /// In en, this message translates to:
  /// **'AI Review only supports English, please change to English mode'**
  String get aiOnlyEnglish;

  /// No description provided for @enterTextReview.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text to review'**
  String get enterTextReview;

  /// No description provided for @updateRecord.
  ///
  /// In en, this message translates to:
  /// **'Update Record'**
  String get updateRecord;

  /// No description provided for @unknown.
  ///
  /// In en, this message translates to:
  /// **'Unknown'**
  String get unknown;

  /// No description provided for @nextReview.
  ///
  /// In en, this message translates to:
  /// **'Next review'**
  String get nextReview;

  /// No description provided for @stage.
  ///
  /// In en, this message translates to:
  /// **'Stage {stage}'**
  String stage(int stage);

  /// No description provided for @myLearning.
  ///
  /// In en, this message translates to:
  /// **'My Learning'**
  String get myLearning;

  /// No description provided for @oxfordWordLists.
  ///
  /// In en, this message translates to:
  /// **'Oxford Word Lists'**
  String get oxfordWordLists;

  /// No description provided for @wordsCount.
  ///
  /// In en, this message translates to:
  /// **'{count} words'**
  String wordsCount(int count);

  /// No description provided for @beginner.
  ///
  /// In en, this message translates to:
  /// **'Beginner'**
  String get beginner;

  /// No description provided for @elementary.
  ///
  /// In en, this message translates to:
  /// **'Elementary'**
  String get elementary;

  /// No description provided for @intermediate.
  ///
  /// In en, this message translates to:
  /// **'Intermediate'**
  String get intermediate;

  /// No description provided for @upperIntermediate.
  ///
  /// In en, this message translates to:
  /// **'Upper-Intermediate'**
  String get upperIntermediate;

  /// No description provided for @advanced.
  ///
  /// In en, this message translates to:
  /// **'Advanced'**
  String get advanced;

  /// No description provided for @grammarChecker.
  ///
  /// In en, this message translates to:
  /// **'Grammar Checker'**
  String get grammarChecker;

  /// No description provided for @grammarCheckDescription.
  ///
  /// In en, this message translates to:
  /// **'Improve your writing with AI-powered grammar check.'**
  String get grammarCheckDescription;

  /// No description provided for @grammarCheckHint.
  ///
  /// In en, this message translates to:
  /// **'Type or paste your English text here...'**
  String get grammarCheckHint;

  /// No description provided for @checkNow.
  ///
  /// In en, this message translates to:
  /// **'Check Now'**
  String get checkNow;

  /// No description provided for @aiAnalysis.
  ///
  /// In en, this message translates to:
  /// **'AI Analysis'**
  String get aiAnalysis;

  /// No description provided for @detailedExplanation.
  ///
  /// In en, this message translates to:
  /// **'Detailed Explanation'**
  String get detailedExplanation;

  /// No description provided for @original.
  ///
  /// In en, this message translates to:
  /// **'Original'**
  String get original;

  /// No description provided for @improved.
  ///
  /// In en, this message translates to:
  /// **'Improved'**
  String get improved;

  /// No description provided for @perfect.
  ///
  /// In en, this message translates to:
  /// **'Perfect'**
  String get perfect;

  /// No description provided for @wordDetails.
  ///
  /// In en, this message translates to:
  /// **'Word Details'**
  String get wordDetails;

  /// No description provided for @audioError.
  ///
  /// In en, this message translates to:
  /// **'Could not play audio'**
  String get audioError;

  /// No description provided for @wordAdded.
  ///
  /// In en, this message translates to:
  /// **'Word added to My Words'**
  String get wordAdded;

  /// No description provided for @wordNotFound.
  ///
  /// In en, this message translates to:
  /// **'Word not found'**
  String get wordNotFound;

  /// No description provided for @englishMeaning.
  ///
  /// In en, this message translates to:
  /// **'English Meaning'**
  String get englishMeaning;

  /// No description provided for @vietnameseMeaning.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese Meaning'**
  String get vietnameseMeaning;

  /// No description provided for @relations.
  ///
  /// In en, this message translates to:
  /// **'Relations'**
  String get relations;

  /// No description provided for @synonyms.
  ///
  /// In en, this message translates to:
  /// **'Synonyms:'**
  String get synonyms;

  /// No description provided for @antonyms.
  ///
  /// In en, this message translates to:
  /// **'Antonyms:'**
  String get antonyms;

  /// No description provided for @addToMyWords.
  ///
  /// In en, this message translates to:
  /// **'Add to My Words'**
  String get addToMyWords;

  /// No description provided for @myWords.
  ///
  /// In en, this message translates to:
  /// **'My Words'**
  String get myWords;

  /// No description provided for @personalVocabulary.
  ///
  /// In en, this message translates to:
  /// **'Your personal vocabulary'**
  String get personalVocabulary;

  /// No description provided for @oxfordTopic.
  ///
  /// In en, this message translates to:
  /// **'Oxford {topic}'**
  String oxfordTopic(String topic);

  /// No description provided for @levelWordsCount.
  ///
  /// In en, this message translates to:
  /// **'{level} · {count} words'**
  String levelWordsCount(String level, int count);

  /// No description provided for @addedWordToMyWords.
  ///
  /// In en, this message translates to:
  /// **'Added \"{word}\" to your words'**
  String addedWordToMyWords(String word);

  /// No description provided for @tapToReview.
  ///
  /// In en, this message translates to:
  /// **'Tap to review →'**
  String get tapToReview;

  /// No description provided for @noWordsYet.
  ///
  /// In en, this message translates to:
  /// **'No words yet'**
  String get noWordsYet;

  /// No description provided for @startAddingWords.
  ///
  /// In en, this message translates to:
  /// **'Start adding words from your diary\nor tap + to add manually.'**
  String get startAddingWords;

  /// No description provided for @speechUnavailable.
  ///
  /// In en, this message translates to:
  /// **'Speech recognition unavailable'**
  String get speechUnavailable;

  /// No description provided for @writeThoughts.
  ///
  /// In en, this message translates to:
  /// **'Write your thoughts'**
  String get writeThoughts;

  /// No description provided for @englishTranslation.
  ///
  /// In en, this message translates to:
  /// **'English translation'**
  String get englishTranslation;

  /// No description provided for @whatHappenedToday.
  ///
  /// In en, this message translates to:
  /// **'What happened today?'**
  String get whatHappenedToday;

  /// No description provided for @translationHint.
  ///
  /// In en, this message translates to:
  /// **'Translated content will appear here'**
  String get translationHint;

  /// No description provided for @processing.
  ///
  /// In en, this message translates to:
  /// **'Processing…'**
  String get processing;

  /// No description provided for @listening.
  ///
  /// In en, this message translates to:
  /// **'Listening…'**
  String get listening;

  /// No description provided for @speakNow.
  ///
  /// In en, this message translates to:
  /// **'Speak now — we\'ll transcribe your words.'**
  String get speakNow;

  /// No description provided for @stopRecording.
  ///
  /// In en, this message translates to:
  /// **'Stop Recording'**
  String get stopRecording;

  /// No description provided for @happy.
  ///
  /// In en, this message translates to:
  /// **'Happy'**
  String get happy;

  /// No description provided for @sad.
  ///
  /// In en, this message translates to:
  /// **'Sad'**
  String get sad;

  /// No description provided for @angry.
  ///
  /// In en, this message translates to:
  /// **'Angry'**
  String get angry;

  /// No description provided for @scared.
  ///
  /// In en, this message translates to:
  /// **'Scared'**
  String get scared;

  /// No description provided for @calm.
  ///
  /// In en, this message translates to:
  /// **'Calm'**
  String get calm;

  /// No description provided for @thinking.
  ///
  /// In en, this message translates to:
  /// **'Thinking'**
  String get thinking;

  /// No description provided for @daily.
  ///
  /// In en, this message translates to:
  /// **'Daily'**
  String get daily;

  /// No description provided for @study.
  ///
  /// In en, this message translates to:
  /// **'Study'**
  String get study;

  /// No description provided for @work.
  ///
  /// In en, this message translates to:
  /// **'Work'**
  String get work;

  /// No description provided for @travel.
  ///
  /// In en, this message translates to:
  /// **'Travel'**
  String get travel;

  /// No description provided for @food.
  ///
  /// In en, this message translates to:
  /// **'Food'**
  String get food;

  /// No description provided for @other.
  ///
  /// In en, this message translates to:
  /// **'Other'**
  String get other;

  /// No description provided for @aiReviewSupport.
  ///
  /// In en, this message translates to:
  /// **'AI Review only supports English, please change to English mode'**
  String get aiReviewSupport;

  /// No description provided for @enterTextToReview.
  ///
  /// In en, this message translates to:
  /// **'Please enter some text to review'**
  String get enterTextToReview;

  /// No description provided for @english.
  ///
  /// In en, this message translates to:
  /// **'English'**
  String get english;

  /// No description provided for @vietnamese.
  ///
  /// In en, this message translates to:
  /// **'Vietnamese'**
  String get vietnamese;

  /// No description provided for @stopReviewingQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to stop reviewing?'**
  String get stopReviewingQuestion;

  /// No description provided for @stop.
  ///
  /// In en, this message translates to:
  /// **'Stop'**
  String get stop;

  /// No description provided for @exit.
  ///
  /// In en, this message translates to:
  /// **'Exit'**
  String get exit;

  /// No description provided for @continueText.
  ///
  /// In en, this message translates to:
  /// **'Continue'**
  String get continueText;

  /// No description provided for @exitReviewQuestion.
  ///
  /// In en, this message translates to:
  /// **'Are you sure you want to exit? Your progress for this session will be lost.'**
  String get exitReviewQuestion;

  /// No description provided for @failedToLoadWords.
  ///
  /// In en, this message translates to:
  /// **'Failed to load words: {error}'**
  String failedToLoadWords(String error);

  /// No description provided for @retry.
  ///
  /// In en, this message translates to:
  /// **'Retry'**
  String get retry;

  /// No description provided for @wordCountProgress.
  ///
  /// In en, this message translates to:
  /// **'Word {current} of {total}'**
  String wordCountProgress(int current, int total);

  /// No description provided for @definition.
  ///
  /// In en, this message translates to:
  /// **'Definition'**
  String get definition;

  /// No description provided for @nextWord.
  ///
  /// In en, this message translates to:
  /// **'Next Word'**
  String get nextWord;

  /// No description provided for @checkAnswer.
  ///
  /// In en, this message translates to:
  /// **'Check Answer'**
  String get checkAnswer;

  /// No description provided for @noDiaryEntries.
  ///
  /// In en, this message translates to:
  /// **'No diary entries yet. Start writing!'**
  String get noDiaryEntries;

  /// No description provided for @dataNotFound.
  ///
  /// In en, this message translates to:
  /// **'Data does not exist'**
  String get dataNotFound;

  /// No description provided for @googleSignInFailed.
  ///
  /// In en, this message translates to:
  /// **'Google sign-in failed'**
  String get googleSignInFailed;

  /// No description provided for @wordAlreadyExists.
  ///
  /// In en, this message translates to:
  /// **'This word already exists in your collection'**
  String get wordAlreadyExists;

  /// No description provided for @unknownError.
  ///
  /// In en, this message translates to:
  /// **'Unknown error: {message}'**
  String unknownError(String message);

  /// No description provided for @permissionDenied.
  ///
  /// In en, this message translates to:
  /// **'You do not have permission to perform this operation'**
  String get permissionDenied;

  /// No description provided for @alreadyExists.
  ///
  /// In en, this message translates to:
  /// **'Data already exists'**
  String get alreadyExists;

  /// No description provided for @resourceExhausted.
  ///
  /// In en, this message translates to:
  /// **'Quota exceeded, please try again later'**
  String get resourceExhausted;

  /// No description provided for @failedPrecondition.
  ///
  /// In en, this message translates to:
  /// **'Invalid operation'**
  String get failedPrecondition;

  /// No description provided for @aborted.
  ///
  /// In en, this message translates to:
  /// **'Operation aborted, please try again'**
  String get aborted;

  /// No description provided for @outOfRange.
  ///
  /// In en, this message translates to:
  /// **'Value out of range'**
  String get outOfRange;

  /// No description provided for @unavailable.
  ///
  /// In en, this message translates to:
  /// **'Service temporarily unavailable, please try again later'**
  String get unavailable;

  /// No description provided for @dataLoss.
  ///
  /// In en, this message translates to:
  /// **'Data loss or corruption'**
  String get dataLoss;

  /// No description provided for @deadlineExceeded.
  ///
  /// In en, this message translates to:
  /// **'Request timed out'**
  String get deadlineExceeded;

  /// No description provided for @cancelled.
  ///
  /// In en, this message translates to:
  /// **'Request cancelled'**
  String get cancelled;

  /// No description provided for @userNotFound.
  ///
  /// In en, this message translates to:
  /// **'Account does not exist'**
  String get userNotFound;

  /// No description provided for @wrongPassword.
  ///
  /// In en, this message translates to:
  /// **'Incorrect password'**
  String get wrongPassword;

  /// No description provided for @emailAlreadyInUse.
  ///
  /// In en, this message translates to:
  /// **'Email is already in use'**
  String get emailAlreadyInUse;

  /// No description provided for @weakPassword.
  ///
  /// In en, this message translates to:
  /// **'Password is too weak'**
  String get weakPassword;

  /// No description provided for @userDisabled.
  ///
  /// In en, this message translates to:
  /// **'Account has been disabled'**
  String get userDisabled;

  /// No description provided for @tooManyRequests.
  ///
  /// In en, this message translates to:
  /// **'Too many requests, please try again later'**
  String get tooManyRequests;

  /// No description provided for @operationNotAllowed.
  ///
  /// In en, this message translates to:
  /// **'Operation not allowed'**
  String get operationNotAllowed;

  /// No description provided for @accountExistsWithDifferentCredential.
  ///
  /// In en, this message translates to:
  /// **'Account exists with different sign-in method'**
  String get accountExistsWithDifferentCredential;

  /// No description provided for @invalidCredential.
  ///
  /// In en, this message translates to:
  /// **'Invalid credentials'**
  String get invalidCredential;

  /// No description provided for @networkRequestFailed.
  ///
  /// In en, this message translates to:
  /// **'Network error, please check your connection'**
  String get networkRequestFailed;

  /// No description provided for @connectionTimeout.
  ///
  /// In en, this message translates to:
  /// **'Connection timed out'**
  String get connectionTimeout;

  /// No description provided for @cacheError.
  ///
  /// In en, this message translates to:
  /// **'Cache error: {message}'**
  String cacheError(String message);

  /// No description provided for @reminderSetAt.
  ///
  /// In en, this message translates to:
  /// **'Reminder set at {time}'**
  String reminderSetAt(String time);
}

class _AppLocalizationsDelegate
    extends LocalizationsDelegate<AppLocalizations> {
  const _AppLocalizationsDelegate();

  @override
  Future<AppLocalizations> load(Locale locale) {
    return SynchronousFuture<AppLocalizations>(lookupAppLocalizations(locale));
  }

  @override
  bool isSupported(Locale locale) =>
      <String>['en', 'vi'].contains(locale.languageCode);

  @override
  bool shouldReload(_AppLocalizationsDelegate old) => false;
}

AppLocalizations lookupAppLocalizations(Locale locale) {
  // Lookup logic when only language code is specified.
  switch (locale.languageCode) {
    case 'en':
      return AppLocalizationsEn();
    case 'vi':
      return AppLocalizationsVi();
  }

  throw FlutterError(
    'AppLocalizations.delegate failed to load unsupported locale "$locale". This is likely '
    'an issue with the localizations generation tool. Please file an issue '
    'on GitHub with a reproducible sample app and the gen-l10n configuration '
    'that was used.',
  );
}
