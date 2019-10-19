

class IBLocale
{
  static String BAR_HOME = "Home";
  static String BAR_FAV = "Favourite";
  static String BAR_CAT = "Category";
  static String BAR_SEARCH = "Search";
  static String BAR_EXPLORE = "Explore";
  static String BAR_NEWS = "News";
  static String MENU_SETTINGS = "Settings";
  static String MENU_ABOUT = "About";
  static String MENU_NEWSTORE = "Submit a new store";
  static String MENU_FEEDBACK = "Leave a message for us!";
  static String MENU_TERMS = "Terms and policies";
  static String SEARCHBAR = "What are you looking for?";
  static String FAV_EMPTY = "Add something to your favourite list!";
  static String MORE = "More...";
  static String LESS = "Less...";
  static String GOODS_OFFERED = "Merchandise offered by the store: ";
  static String SUBMIT_NEW_STORE = "Submit a new store";
  static String SUBMIT_NEW_STORE_HEADER = "Thank you for helping enrich ShopMeadow";
  static String SUBMIT_NEW_STORE_INSTRUCTIONS = "What stores are elligible?\n\n1. Shops that are based in Hong Kong,\n2. offers online ordering,\n3. and do not have physical chain stores.\n\nThese guidelines are made in conformity with our aim: to help local small businesses prosper.";
  static String SUBMIT = "Submit";
  static String FEEDBACK_HEADER = "Send us anything!";
  static String DEFAULT_HINT_TEXT = "Start typing here.";
  static String SEE_MORE = "See more...";
  static String NO_RATING_AVA = "No ratings available";
  static String ABOUT = "About";
  static String CLEAR_USER_DATA = "清除用戶資料";
  static String WARNING = "警告";
  static String CLEAR_USER_DATA_PROMPT = "清除所有個人資料?";
  static String CONFIRM = "確定";
  static String CANCEL = "取消";
  static String IG_NAME = "IG Username";
  static String SUBMIT_NEW_STORE_THANKS = "Thanks! Store submitted";
  static String SOMETHING_WRONG = "Oops! Something went wrong!";
  static String SUBMIT_NEW_STORE_NOT_VALID = "Please enter a valid username!";
  static String CAT_END_OF_LIST = "We are working hard to add more stores!";
  static String REVIEWS_FOR = "Reviews for @";
  static String REVIEWS_END = "No more reviews.";
  static String REVIEWS = "Reviews";
  static String OPEN_IN_IG = "Open in IG";
  static String RATE_STORE = "Rate this store...";
  static String REVIEWS_NO = "No reviews yet";
  static String REPORT_AMEND_STORE = "修正/檢舉商店";
  static String REVIEW_SUBMITTED_BEFORE = "You've already submitted a review for this store!";
  static String REPORT_HINT_TEXT = "請選擇類別";
  static List<String> REPORT_LIST = [
    "詐騙",
    "非香港商店",
    "非法商品",
    "錯誤類別",
    "重覆商店",
    "已經倒閉",
    "其他",
  ];
  static String SUPPLEMENTARY = "補充";
  static String SUBMITTED = "提交ded";
  static String REVIEW_HINT_TEXT = "Anything you would like to say? (Optional)";
  static String SERVER_UNAVA = "Server is unavailable now.";
  static String NEWS_END = "No more news.";
  static String EXAMPLE_QUERY = "Example query: \"present for girlfriend\", \"desk decorations\"";
  static String SEARCH_END = "No more search results.";
  static String FILTER_STORE = "過濾商店";
  static String CHANGE_LANGUAGE_PROMPT = "Changing language to Chinese. Confirm?";
  static String CHANGE_LANGUAGE = "Change language";
  static String CAT_TAB_STORE;
  static String CAT_TAB_EXPLORE;
  static String DELETE_STORE_OWNER_DIALOG;
  static String DELETE_STORE_OWNER;
  static String JUST_FOR_YOU;
  static String NEW_IN_TOWN;
  static String CATS_YOU_LIKE;


  static void setLanguage(bool langChinese){


    if (langChinese) _changeToChinese();
    else _changeToEnglish();
  }

  static void _changeToEnglish(){
    JUST_FOR_YOU = "JUST FOR YOU";
    NEW_IN_TOWN = "NEW IN TOWN";
    CATS_YOU_LIKE = "TYPES YOU LIKE";
    BAR_HOME = "Home";
    BAR_FAV = "Favourite";
    BAR_CAT = "Category";
    BAR_SEARCH = "Search";
    BAR_EXPLORE = "Explore";
    BAR_NEWS = "News";
    MENU_SETTINGS = "Settings";
    MENU_ABOUT = "About";
    MENU_NEWSTORE = "Submit a new store";
    MENU_FEEDBACK = "Leave a message for us!";
    MENU_TERMS = "Terms and policies";
    SEARCHBAR = "What are you looking for?";
    FAV_EMPTY = "Add something to your favourite list!";
    MORE = "More...";
    LESS = "Less...";
    GOODS_OFFERED = "Merchandise offered by the store: ";
    SUBMIT_NEW_STORE = "Submit a new store";
    SUBMIT_NEW_STORE_HEADER = "Thank you for helping enrich ShopMeadow";
    SUBMIT_NEW_STORE_INSTRUCTIONS = "What stores are elligible?\n\n1. Shops that are based in Hong Kong,\n2. offers online ordering,\n3. and do not have physical chain stores.\n\nThese guidelines are made in conformity with our aim: to help local small businesses prosper.";
    SUBMIT = "Submit";
    FEEDBACK_HEADER = "Send us anything!";
    DEFAULT_HINT_TEXT = "Start typing here.";
    SEE_MORE = "See more...";
    NO_RATING_AVA = "No ratings available";
    ABOUT = "About";
    CLEAR_USER_DATA = "Clear all personal data";
    WARNING = "Warning";
    CLEAR_USER_DATA_PROMPT = "Are you sure you want to clear all personal data? This includes your favourite stores.";
    CONFIRM = "Confirm";
    CANCEL = "Cancel";
    IG_NAME = "IG Username";
    SUBMIT_NEW_STORE_THANKS = "Thanks! Store submitted";
    SOMETHING_WRONG = "Oops! Something went wrong!";
    SUBMIT_NEW_STORE_NOT_VALID = "Please enter a valid username!";
    CAT_END_OF_LIST = "We are working hard to add more stores!";
    REVIEWS_FOR = "Reviews for @";
    REVIEWS_END = "No more reviews.";
    REVIEWS = "Reviews";
    OPEN_IN_IG = "Open in IG";
    RATE_STORE = "Rate this store...";
    REVIEWS_NO = "No reviews yet";
    REPORT_AMEND_STORE = "Amend/Report Store";
    DELETE_STORE_OWNER = "Request deletion (Owner)";
    REVIEW_SUBMITTED_BEFORE = "You've already submitted a review for this store!";
    REPORT_HINT_TEXT = "Please select category";
    REPORT_LIST = [
      "Fraud",
      "Non-local store",
      "Illegal",
      "Wrong category",
      "Repeated store",
      "Store does not exist",
      "Others",
    ];
    SUPPLEMENTARY = "Supplementary data...";
    SUBMITTED = "Submitted";
    REVIEW_HINT_TEXT = "Anything you would like to say? (Optional)";
    SERVER_UNAVA = "Server is unavailable now.";
    NEWS_END = "No more news.";
    EXAMPLE_QUERY = "Example query: IG shop name, \"korea\", \"macbook\"";
    SEARCH_END = "No more search results.";
    FILTER_STORE = "Filter stores";
    CHANGE_LANGUAGE_PROMPT = "將語言轉換成中文?";
    CHANGE_LANGUAGE = "Change language 轉換語言";
    CAT_TAB_STORE = "STORES";
    CAT_TAB_EXPLORE = "SWIPE TO EXPLORE";
    DELETE_STORE_OWNER_DIALOG = "Sorry to bother you. Please kindly contact us at @shopmeadow.hk with your store's account in order to verify your identify. Thanks!";

  }

  static void _changeToChinese(){
    JUST_FOR_YOU = "特登揀俾你";
    NEW_IN_TOWN = "新鮮熱辣";
    CATS_YOU_LIKE = "精選類別";
    BAR_HOME = "主頁";
    BAR_NEWS = "新資訊";
    BAR_FAV = "最愛";
    BAR_CAT = "商店類別";
    BAR_SEARCH = "尋找";
    BAR_EXPLORE = "hea下";
    MENU_SETTINGS = "設定/Language";
    MENU_ABOUT = "關於";
    MENU_NEWSTORE = "提交新商店";
    MENU_FEEDBACK = "留個口訊";
    MENU_TERMS = "服務條款";
    SEARCHBAR = "想搵咩?";
    FAV_EMPTY = "快啲將ig shop擺落我的最愛啦!";
    MORE = "更多...";
    LESS = "返回...";
    GOODS_OFFERED = "商店商品";
    SUBMIT_NEW_STORE = "提交新商店";
    SUBMIT_NEW_STORE_HEADER = "多謝您令ShopMeadow嘅目錄更豐富!";
    SUBMIT_NEW_STORE_INSTRUCTIONS = "合適商店:\n\n1. 香港商店,\n2. 於IG設有帳戶,\n3. 沒有多間實體連鎖店.\n\n守則咁定，係因為我哋希望推廣香港本地小商鋪。";
    SUBMIT = "提交";
    FEEDBACK_HEADER = "任何野都可以send的";
    DEFAULT_HINT_TEXT = "呢到開始打 謝";
    SEE_MORE = "睇多啲...";
    NO_RATING_AVA = "唔夠評論";
    ABOUT = "關於";
    CLEAR_USER_DATA = "清除用戶資料";
    WARNING = "警告";
    CLEAR_USER_DATA_PROMPT = "清除所有個人資料?";
    CONFIRM = "確定";
    CANCEL = "取消";
    IG_NAME = "IG 用戶名";
    SUBMIT_NEW_STORE_THANKS = "唔該曬！";
    SOMETHING_WRONG = "哎呀 有問題 遲啲再試試啦";
    SUBMIT_NEW_STORE_NOT_VALID = "請輸入有效ig名";
    CAT_END_OF_LIST = "係咁多";
    REVIEWS_FOR = "評論 @";
    REVIEWS_END = "係咁多";
    REVIEWS = "評論";
    OPEN_IN_IG = "於IG開啟";
    RATE_STORE = "評論此商家";
    REVIEWS_NO = "未有評論";
    REPORT_AMEND_STORE = "修正/檢舉商店";
    DELETE_STORE_OWNER = "要求移除商店";
    REVIEW_SUBMITTED_BEFORE = "評論過喇";
    REPORT_HINT_TEXT = "請選擇類別";
    REPORT_LIST = [
      "詐騙",
      "非香港商店",
      "非法商品",
      "錯誤類別",
      "重覆商店",
      "已經倒閉",
      "其他",
    ];
    SUPPLEMENTARY = "補充";
    SUBMITTED = "提交ded";
    REVIEW_HINT_TEXT = "有無咩想講? ";
    SERVER_UNAVA = "未能連結至伺服器 soz";
    NEWS_END = "係咁多";
    EXAMPLE_QUERY = "例如: IG商店名稱, \"韓國\", \"大眼仔\"";
    SEARCH_END = "係咁多";
    FILTER_STORE = "過濾商店";
    CHANGE_LANGUAGE_PROMPT = "Changing language to English. Confirm?";
    CHANGE_LANGUAGE = "Change language 轉換語言";
    CAT_TAB_STORE = "商店";
    CAT_TAB_EXPLORE = "向左掃睇多啲";
    DELETE_STORE_OWNER_DIALOG = "麻煩你唔好意思，請IG Direct @shopmeadow.hk 作認證，多謝！";
  }


}