import 'package:my_medical_app/data/remote/models/StaticPagesListModel.dart';
import 'package:my_medical_app/data/remote/models/allCategoriesModel.dart';
import 'package:my_medical_app/ui/models/user.dart';

class Constants {
  // static String BASE_URL = "https://Test.osouly.com";
  static String BASE_URL = "https://mymedicalshope.com/api/v1/";
  static String IMAGE_BASE_URL = "https://mymedicalshope.com/public/";

  static String LANG = "en";

  static String FIRST_VISIT = "first_visit";
  static String APP_LANG = "app_lang";
  static String ENGLISH = "en";
  static String ARABIC = "ar";
  static String API_LANG = "en";

  static String token_type = "token_type";
  static String access_token = "access_token";
  static String expires_at = "expires_at";
  static String FCM_TOKEN = "fcm_token";
  static String id = "id";
  static String isSocial = "is_social";
  static String type = "type";
  static String name = "name";
  static String email = "email";
  static String avatar = "avatar";
  static String avatarFromSocial = "avatarFromSocial";
  static String avatar_original = "avatar_original";
  static String address = "address";
  static String country = "country";
  static String city = "city";
  static String postal_code = "postal_code";
  static String phone = "phone";


  static int CART_COUNT = 0;
  static int NOTIFICATIONS_COUNT = 0;

/*  static INCRECE_CART_COUNT(){
    CART_COUNT++;
  }*/

  static User USER_APP;

  static String IS_LOGGEDIN = "is_loggedin";
  // static String IS_LOGGED = "is_logged";

  static List<CategoriesData> drawerCategoriesList = List();
  static List<PageData> drawerStaticPagesList = List();

  static int ABOUT_MY_MEDICAL_ID = 8;
  static int TERMS_AND_CONDITIONS_ID = 9;
  static int RETURN_POLICY_ID = 10;
  static int CONTACT_US_ID = 11;
  static int PRIVACY_POLICY_ID = 12;
  static int PAYMENT_METHODS_ID = 13;

}
