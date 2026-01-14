class UserState {
  // 앱 어디서든 UserState.currentUserEmail 로 접근 가능
  static String? currentUserEmail; 
  static String? currentUserName;
  
  // 로그인 성공 시 호출
  static void setLogin(String email, String name) {
    currentUserEmail = email;
    currentUserName = name;
  }

  // 로그아웃 시 호출
  static void clear() {
    currentUserEmail = null;
    currentUserName = null;
  }
}