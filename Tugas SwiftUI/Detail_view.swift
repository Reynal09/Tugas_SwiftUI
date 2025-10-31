import SwiftUI

struct DetailView: View {
  @Binding var nama: String
  @Binding var password: String
  
  var body: some View {
    Text("Halo, \(nama)!")
    Text("Password, \(password)!")
  }
}

#Preview {
  DetailView(nama: .constant("Alfi"),password: .constant(""))
}
