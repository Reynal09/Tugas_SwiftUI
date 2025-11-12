import FirebaseAuth

struct AuthModel {
  let uid: String
  let email: String?
  
  init(user: User) {
    self.uid = user.uid
    self.email = user.email
  }
}
