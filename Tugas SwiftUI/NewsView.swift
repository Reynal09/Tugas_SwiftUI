//
//  NewsView.swift
//  Tugas SwiftUI
//
//  Created by iCodeWave Community on 31/10/25.
//

import SwiftUI
import SafariServices

struct NewsView: View {
  
  @StateObject private var network = PengelolaBerita()
  @State private var selectedURL: URL?
  @State private var isShowingSafari = false
  
  
  var body: some View {
    NavigationStack {
      List {
        ForEach(network.dataYangDiambil, id: \.self) { article in
          Text(article.title)
            .onTapGesture {
              if let url = URL(string: article.url) {
                selectedURL = url
                isShowingSafari = true
              }
            }
        }
      }
      .onAppear {
        Task {
          await network.ambilBerita(query: "BAHLIL")
        }
      }
      .navigationTitle("Berita Hot")
    }
    .sheet(isPresented: $isShowingSafari) {
      if let url = selectedURL {
        SafariView(url: url)
      }
    }
  }
}

struct SafariView: UIViewControllerRepresentable {
  let url: URL
  
  func makeUIViewController(context: Context) -> SFSafariViewController {
    SFSafariViewController(url: url)
  }
  
  func updateUIViewController(_ uiViewController: SFSafariViewController, context: Context) {}
}



#Preview {
  NewsView()
}
