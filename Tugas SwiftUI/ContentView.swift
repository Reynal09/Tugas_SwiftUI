import SwiftUI
import FirebaseAuth
import Combine


class LoginViewModel: ObservableObject {
  @Published var email = ""
  @Published var password = ""
  @Published var isLoading = false
  @Published var isShowSuccess = false
  @Published var isShowFailed = false
  @Published var isLoggedIn = false
  
  func login() {
    isLoading = true
    Task {
      do {
        // 🔹 Gunakan signIn, bukan createUser (karena login, bukan daftar)
        let result = try await Auth.auth().signIn(withEmail: email, password: password)
        print("SUKSES LOGIN! User ID:", result.user.uid)
        await MainActor.run {
          self.isShowSuccess = true
          self.isLoggedIn = true
          self.isLoading = false
        }
      } catch {
        print("Email/Password salah:", error.localizedDescription)
        await MainActor.run {
          self.isShowFailed = true
          self.isLoading = false
        }
      }
    }
  }
}

// MARK: - ContentView (Login Page)
struct ContentView: View {
  @StateObject var vm = LoginViewModel()
  
  var body: some View {
    NavigationStack {
      VStack(spacing: 20) {
        Text("Login Akun")
          .font(.largeTitle)
          .bold()
        
        TextField("Email", text: $vm.email)
          .textFieldStyle(RoundedBorderTextFieldStyle())
          .keyboardType(.emailAddress)
          .autocapitalization(.none)
        
        SecureField("Password", text: $vm.password)
          .textFieldStyle(RoundedBorderTextFieldStyle())
        
        Button {
          vm.login()
        } label: {
          HStack {
            if vm.isLoading {
              ProgressView()
            }
            Text(vm.isLoading ? "Sedang Masuk..." : "Login")
              .bold()
          }
          .frame(maxWidth: .infinity)
          .padding()
          .background(Color.blue)
          .foregroundColor(.white)
          .cornerRadius(10)
        }
        .disabled(vm.isLoading)
        
        Spacer()
      }
      .padding()
      .alert("Gagal", isPresented: $vm.isShowFailed) {
        Button("Tutup", role: .cancel) {}
      } message: {
        Text("Email atau password salah.")
      }
      
      // 🔹 Navigation otomatis ke NewsView setelah login sukses
      .navigationDestination(isPresented: $vm.isLoggedIn) {
        NewsView()
      }
    }
  }
}
#Preview {
  ContentView()
}
