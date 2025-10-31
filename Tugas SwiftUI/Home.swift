import SwiftUI

struct HomeView: View {
  @State private var nama: String = ""
  @State private var password: String = ""
  
  var body: some View {
    NavigationStack {
      
      ScrollView{
        Image(.IMG_4196)
          .resizable()
          .frame(width: 300, height: 300)
          .cornerRadius(1000)
          .padding()
        
        VStack {
          Text("Selamat Datang di Anomali News")
            .padding()
            .frame(maxWidth: .infinity)
            .background(.green .opacity(0.4))
            .cornerRadius(20)
            .fontWeight(.bold)
          
          
          
          HStack{
            Spacer()
            Text ("Kamu lupa Password?")
              .foregroundStyle(.red)
              .fontWeight(.bold)
          }
          
          NavigationLink(destination: ContentView()) {
            HStack {
              Text("Login")
              Image(systemName: "person.crop.circle.fill")
            }
            .padding(.vertical,5)
            .frame(maxWidth: .infinity)
            .padding(.vertical,8)
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(100)
            .padding(.vertical,20)
          }

          NavigationLink(destination: RegisterView()){
            HStack {
              Text("Register")
              Image(systemName: "person.badge.plus")
            }
            .padding(.vertical,5)
            .frame(maxWidth: .infinity)
            .padding(.vertical,8)
            .foregroundStyle(.white)
            .background(.blue)
            .cornerRadius(100)
            .padding(.vertical,20)
          }
          
        }
        .padding(.horizontal)
      }
      .navigationTitle("Login Disini")
      
    }
  }
}

#Preview {
  HomeView()
}
