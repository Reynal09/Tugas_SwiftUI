import SwiftUI
import SwiftyJSON
import Combine

class ContentViewModel: ObservableObject {
  @Published var articles: [NewsArticle] = []
  @Published var isLoading: Bool = false
  @Published var errorMessage: String?
  
  private var network = Networking()
  
  func loadArticles(query: String? = nil) {
    isLoading = true
    errorMessage = nil
    
    network.fetchData(query: query) { [weak self] hasil in
      DispatchQueue.main.async {
        self?.isLoading = false
        if hasil.isEmpty {
          self?.errorMessage = "Tidak ada berita ditemukan."
        } else {
          self?.articles = hasil
        }
      }
    }
  }
}

struct NewsView: View {
  @State var item: NewsArticle?
  @StateObject private var vm = ContentViewModel()
  @State private var searchText = ""
  
  var body: some View {
    NavigationStack {
      Group {
        if let article = item { // Detail Berita
          ScrollView {
            VStack(alignment: .leading, spacing: 12) {
              AsyncImage(url: imageURL(from: article)) { phase in
                switch phase {
                case .empty:
                  ProgressView().frame(height: 250)
                case .success(let image):
                  image
                    .resizable()
                    .scaledToFit()
                    .frame(maxWidth: .infinity)
                    .cornerRadius(12)
                case .failure:
                  Image(systemName: "photo")
                    .resizable()
                    .scaledToFit()
                    .frame(height: 250)
                    .foregroundStyle(.secondary)
                @unknown default:
                  EmptyView()
                }
              }
              
              Text(article.title)
                .font(.title3)
                .bold()
                .padding(.top, 8)
              
              if !article.description.isEmpty {
                Text(article.description)
                  .font(.body)
                  .foregroundStyle(.secondary)
              }
            }
            .padding()
          }
          
        } else { // List Berita
          if vm.isLoading {
            ProgressView("Memuat berita...")
          } else if let error = vm.errorMessage {
            VStack(spacing: 12) {
              Text("Terjadi kesalahan:")
              Text(error)
                .font(.footnote)
                .foregroundStyle(.secondary)
              Button("Coba Lagi") {
                vm.loadArticles()
              }
            }
            .padding()
          } else {
            List(vm.articles) { article in
              NavigationLink {
                NewsView(item: article)
              } label: {
                VStack(alignment: .leading, spacing: 6) {
                  Text(article.title)
                    .font(.headline)
                    .lineLimit(2)
                  if !article.description.isEmpty {
                    Text(article.description)
                      .font(.subheadline)
                      .foregroundStyle(.secondary)
                      .lineLimit(2)
                  }
                }
                .padding(.vertical, 4)
              }
            }
            .listStyle(.plain)
          }
        }
      }
      .navigationTitle(item == nil ? "Berita" : "Detail Berita")
      .searchable(text: $searchText, prompt: "Cari berita...")
      .onSubmit(of: .search) {
        vm.loadArticles(query: searchText)
      }
      .onAppear {
          if item == nil && vm.articles.isEmpty {
              print("🟢 Memuat berita...")
              vm.loadArticles()
          }
      }

    }
  }
  
  private func imageURL(from article: NewsArticle) -> URL? {
    if let urlString = article.urlToImage,
       !urlString.isEmpty,
       let url = URL(string: urlString) {
      return url
    }
    return nil
  }
}

#Preview {
  NewsView()
}

