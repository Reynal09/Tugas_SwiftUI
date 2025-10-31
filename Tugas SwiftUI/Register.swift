import SwiftUI

struct RegisterView: View {
  @State var nama = "" //nyambung ke binding
  @State var password = "" //nyambung ke binding
  var body: some View {
    NavigationStack {

      ScrollView{
          
        VStack {
          
          TextField("Masukkan nama", text: $nama)
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(20)
          
          
          SecureField("Masukkan password", text: $password)
            .padding()
            .background(.gray.opacity(0.3))
            .cornerRadius(20)
            
          
          
          NavigationLink(destination: HomeView()) {
            HStack {

              Text ("Daftar Dulu")
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
          
        }
        .padding(.horizontal)
        .padding(.vertical)
      }
      .navigationTitle("Daftar Dulu guis")
      
    }
  }
}

#Preview {
  RegisterView()
}
