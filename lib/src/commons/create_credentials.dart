Map<String, dynamic> createCredentials(String userName, String password) {
  return {
    "email": userName,
    "password": password,
  };
}