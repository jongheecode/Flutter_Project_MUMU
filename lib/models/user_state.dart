class UserState {
  // 앱 어디서든 UserState.currentUserEmail 로 접근 가능
  static String? currentUserEmail; 
  static String? currentUserName;
  static String? currentUserArtistName;
  
  // 로그인 성공 시 호출
  static void setLogin(String email, String name, {String? artistName}) {
    currentUserEmail = email;
    currentUserName = name;
    currentUserArtistName = artistName;
  }

  // 로그아웃 시 호출
  static void clear() {
    currentUserEmail = null;
    currentUserName = null;
    currentUserArtistName = null;
  }
}