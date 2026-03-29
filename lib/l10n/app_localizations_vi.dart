// ignore: unused_import
import 'package:intl/intl.dart' as intl;
import 'app_localizations.dart';

// ignore_for_file: type=lint

/// The translations for Vietnamese (`vi`).
class AppLocalizationsVi extends AppLocalizations {
  AppLocalizationsVi([String locale = 'vi']) : super(locale);

  @override
  String get dailyLanguage => 'Daily Language';

  @override
  String get continueWith => 'Tiếp tục với';

  @override
  String get home => 'Trang chủ';

  @override
  String get diary => 'Nhật ký';

  @override
  String get profile => 'Cá nhân';

  @override
  String get words => 'Từ vựng';

  @override
  String get fullName => 'Họ và tên';

  @override
  String get email => 'Email';

  @override
  String get phoneNumber => 'Số điện thoại';

  @override
  String get streak => 'Chuỗi học tập';

  @override
  String get edit => 'Chỉnh sửa';

  @override
  String get editProfile => 'Chỉnh sửa hồ sơ';

  @override
  String get confirm => 'Xác nhận';

  @override
  String get cancel => 'Hủy';

  @override
  String get save => 'Lưu';

  @override
  String get logOut => 'Đăng xuất';

  @override
  String get empty => 'Không có dữ liệu';

  @override
  String get required => 'Trường này là bắt buộc';

  @override
  String get invalidPhoneNumber => 'Số điện thoại không hợp lệ';

  @override
  String get invalidEmail => 'Email không hợp lệ';

  @override
  String get updateSuccess => 'Cập nhật thành công';

  @override
  String get welcomeBack => 'Chào mừng trở lại';

  @override
  String get currentStreak => 'Chuỗi hiện tại';

  @override
  String get highestStreak => 'Kỷ lục';

  @override
  String get recentDiary => 'Nhật ký gần đây';

  @override
  String get myVocabulary => 'Từ vựng của tôi';

  @override
  String get seeAll => 'Xem tất cả';

  @override
  String get review => 'Ôn tập';

  @override
  String get days => 'ngày';

  @override
  String get reviewWords => 'Ôn tập từ vựng';

  @override
  String get chooseLanguage => 'Chọn ngôn ngữ';

  @override
  String get appLanguage => 'Ngôn ngữ ứng dụng';

  @override
  String get learningLanguage => 'Ngôn ngữ học tập';

  @override
  String get version => 'Phiên bản';

  @override
  String get notifications => 'Thông báo';

  @override
  String get learningReminders => 'Nhắc nhở học tập';

  @override
  String get help => 'Trợ giúp';

  @override
  String get guidesAndFAQ => 'Hướng dẫn & FAQ';

  @override
  String get privacyPolicy => 'Chính sách bảo mật';

  @override
  String get termsOfService => 'Điều khoản dịch vụ';

  @override
  String get functions => 'Chức năng';

  @override
  String get personalInfo => 'Thông tin cá nhân';

  @override
  String get updateProfile => 'Cập nhật hồ sơ';

  @override
  String get logoutConfirm => 'Bạn có chắc chắn muốn đăng xuất không?';

  @override
  String get todayPrompt => 'Chủ đề hôm nay';

  @override
  String get dailyReview => 'Ôn tập hàng ngày';

  @override
  String reviewReady(int count) {
    return 'Bạn có $count từ đã sẵn sàng để ôn tập!';
  }

  @override
  String get noReviewToday =>
      'Hôm nay không có từ nào cần ôn tập. Hãy tiếp tục học nhé!';

  @override
  String get write => 'Viết';

  @override
  String get todayPromptQuestion => 'Điều gì đã làm bạn hạnh phúc hôm nay?';

  @override
  String get reviewCompleted => 'Ôn tập hoàn tất! 🥳';

  @override
  String get reviewFinishedMessage =>
      'Bạn đã hoàn thành tất cả các từ cần ôn tập. Tuyệt vời!';

  @override
  String get backToLearning => 'Quay lại trang học tập';

  @override
  String get correctKeepItUp => 'Chính xác! Tiếp tục phát huy nhé!';

  @override
  String get incorrectWordIsAbove => 'Rất tiếc! Từ chính xác nằm ở trên.';

  @override
  String get reviewSession => 'Phiên ôn tập';

  @override
  String get emotionQuestion => 'Bạn đang cảm thấy thế nào?';

  @override
  String get category => 'Danh mục';

  @override
  String get saveRecord => 'Lưu nhật ký';

  @override
  String get emptyError => 'Vui lòng viết nội dung nào đó';

  @override
  String get addRecord => 'Thêm nhật ký';

  @override
  String get editRecord => 'Sửa nhật ký';

  @override
  String get update => 'Cập nhật';

  @override
  String get aiOnlyEnglish =>
      'AI Review chỉ hỗ trợ tiếng Anh, vui lòng chuyển sang chế độ tiếng Anh';

  @override
  String get enterTextReview => 'Vui lòng nhập văn bản để review';

  @override
  String get updateRecord => 'Cập nhật nhật ký';

  @override
  String get unknown => 'Không xác định';

  @override
  String get nextReview => 'Ôn tập tiếp theo';

  @override
  String stage(int stage) {
    return 'Cấp độ $stage';
  }

  @override
  String get myLearning => 'Học tập của tôi';

  @override
  String get oxfordWordLists => 'Danh sách từ Oxford';

  @override
  String wordsCount(int count) {
    return '$count từ';
  }

  @override
  String get beginner => 'Sơ cấp';

  @override
  String get elementary => 'Cơ bản';

  @override
  String get intermediate => 'Trung cấp';

  @override
  String get upperIntermediate => 'Trung cấp cấp cao';

  @override
  String get advanced => 'Nâng cao';

  @override
  String get grammarChecker => 'Kiểm tra ngữ pháp';

  @override
  String get grammarCheckDescription =>
      'Cải thiện kỹ năng viết của bạn với công cụ kiểm tra ngữ pháp AI.';

  @override
  String get grammarCheckHint =>
      'Nhập hoặc dán văn bản tiếng Anh của bạn tại đây...';

  @override
  String get checkNow => 'Kiểm tra ngay';

  @override
  String get aiAnalysis => 'Phân tích AI';

  @override
  String get detailedExplanation => 'Giải thích chi tiết';

  @override
  String get original => 'Bản gốc';

  @override
  String get improved => 'Đã cải thiện';

  @override
  String get perfect => 'Hoàn hảo';

  @override
  String get wordDetails => 'Chi tiết từ vựng';

  @override
  String get audioError => 'Không thể phát âm thanh';

  @override
  String get wordAdded => 'Đã thêm vào từ vựng của tôi';

  @override
  String get wordNotFound => 'Không tìm thấy từ';

  @override
  String get englishMeaning => 'Nghĩa tiếng Anh';

  @override
  String get vietnameseMeaning => 'Nghĩa tiếng Việt';

  @override
  String get relations => 'Từ liên quan';

  @override
  String get synonyms => 'Từ đồng nghĩa:';

  @override
  String get antonyms => 'Từ trái nghĩa:';

  @override
  String get addToMyWords => 'Thêm vào từ vựng';

  @override
  String get myWords => 'Từ vựng của tôi';

  @override
  String get personalVocabulary => 'Kho từ vựng cá nhân của bạn';

  @override
  String oxfordTopic(String topic) {
    return 'Oxford $topic';
  }

  @override
  String levelWordsCount(String level, int count) {
    return '$level · $count từ';
  }

  @override
  String addedWordToMyWords(String word) {
    return 'Đã thêm \"$word\" vào từ vựng của bạn';
  }

  @override
  String get tapToReview => 'Nhấn để ôn tập →';

  @override
  String get noWordsYet => 'Chưa có từ vựng nào';

  @override
  String get startAddingWords =>
      'Bắt đầu thêm từ từ nhật ký của bạn\nhoặc nhấn + để thêm thủ công.';

  @override
  String get speechUnavailable => 'Nhận dạng giọng nói không khả dụng';

  @override
  String get writeThoughts => 'Viết suy nghĩ của bạn';

  @override
  String get englishTranslation => 'Bản dịch tiếng Anh';

  @override
  String get whatHappenedToday => 'Chuyện gì đã xảy ra hôm nay?';

  @override
  String get translationHint => 'Nội dung dịch sẽ xuất hiện tại đây';

  @override
  String get processing => 'Đang xử lý…';

  @override
  String get listening => 'Đang lắng nghe…';

  @override
  String get speakNow => 'Hãy nói — chúng tôi sẽ chuyển thành văn bản.';

  @override
  String get stopRecording => 'Dừng ghi âm';

  @override
  String get happy => 'Hạnh phúc';

  @override
  String get sad => 'Buồn';

  @override
  String get angry => 'Tức giận';

  @override
  String get scared => 'Sợ hãi';

  @override
  String get calm => 'Bình tĩnh';

  @override
  String get thinking => 'Đang suy nghĩ';

  @override
  String get daily => 'Hàng ngày';

  @override
  String get study => 'Học tập';

  @override
  String get work => 'Công việc';

  @override
  String get travel => 'Du lịch';

  @override
  String get food => 'Ẩm thực';

  @override
  String get other => 'Khác';

  @override
  String get aiReviewSupport =>
      'AI Review chỉ hỗ trợ tiếng Anh, vui lòng đổi sang chế độ tiếng Anh';

  @override
  String get enterTextToReview => 'Vui lòng nhập văn bản để review';

  @override
  String get english => 'Tiếng Anh';

  @override
  String get vietnamese => 'Tiếng Việt';

  @override
  String get stopReviewingQuestion =>
      'Bạn có chắc chắn muốn dừng ôn tập không?';

  @override
  String get stop => 'Dừng';

  @override
  String get exit => 'Thoát';

  @override
  String get continueText => 'Tiếp tục';

  @override
  String get exitReviewQuestion =>
      'Bạn có chắc chắn muốn thoát? Quá trình ôn tập trong phiên này sẽ bị mất.';

  @override
  String failedToLoadWords(String error) {
    return 'Không thể tải từ vựng: $error';
  }

  @override
  String get retry => 'Thử lại';

  @override
  String wordCountProgress(int current, int total) {
    return 'Từ $current trên $total';
  }

  @override
  String get definition => 'Định nghĩa';

  @override
  String get nextWord => 'Từ tiếp theo';

  @override
  String get checkAnswer => 'Kiểm tra đáp án';

  @override
  String get noDiaryEntries => 'Chưa có nhật ký nào. Hãy viết ngay!';
}
