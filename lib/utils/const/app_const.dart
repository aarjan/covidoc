class AppConst {
  static const String BLOG_URL = 'https://api.neuroflip.com/api/blog';

  static const String CACHE_USER = 'CACHE_USER';
  static const String CACHE_DOCTORS = 'CACHE_DOCTORS';
  static const String CACHE_LOGIN_TYPE = 'CACHE_LOGIN_TYPE';

  static const String APP_NAME = 'Covidoc';
  static const String APP_VERSION = 'Covidoc v1.0.0';
  static const String REGISTER_TITLE = 'Register to Covidoc';

  static const String FULLNAME_LENGTH_ERROR =
      'Your name should be between 3 and 100 characters long.';
  static const String AGE_ERROR = 'Please enter a valid age';
  static const String GENDER_ERROR = 'Please enter a valid gender';
  static const String LOCATION_ERROR = 'Please enter a valid location';
  static const String LANGUAGE_ERROR = 'Please enter a valid language';
  static const String SPECIALITY_LENGTH_ERROR =
      'Please enter a valid speciality';
  static const String PRACTICE_LENGTH_ERROR = 'Please enter a valid practice';
  static const String MSG_ERROR =
      'Your message should be atleast 50 chars long';

  static const String POST_ANONYMOUS_TXT = 'Post as anonymous';
  static const String REQUEST_UPDATE_BTN_TXT = 'UPDATE MESSAGE';
  static const String REQUEST_SEND_BTN_TXT = 'SEND MESSAGE';
  static const String REQUEST_CONSULT_BTN_TXT = 'CONSULT WITH A DOCTOR';
  static const String REQUEST_DONE_BTN_TXT = 'DONE';
  static const String REQUEST_SUCCESSFULL_TXT =
      'Your Request has been submitted sucessfully';
  static const String REQUEST_CONSULT =
      '''You can ask you queries and one of our doctor will respond to your request.''';
  static const String REQUEST_WRITE_TXT = 'Describe your queries in detail!';

  static const String NO_CONVERSATION_TXT = 'No Conversation started!';

  static const Map<int, String> MONTH = {
    1: 'Jan',
    2: 'Feb',
    3: 'Mar',
    4: 'Apr',
    5: 'May',
    6: 'Jun',
    7: 'Jul',
    8: 'Aug',
    9: 'Sep',
    10: 'Oct',
    11: 'Nov',
    12: 'Dec',
  };
}
