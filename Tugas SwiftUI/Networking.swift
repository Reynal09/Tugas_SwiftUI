import Foundation
import SwiftyJSON
import Alamofire
import Combine



class PengelolaBerita: ObservableObject {
  /// Mengambil artikel dari News API dan melog tiap item
  /// - Parameters:
  ///   - apiKey: API key untuk NewsAPI.org
  ///   - query: Kata kunci pencarian (opsional). Jika nil, akan ambil top-headlines.
  ///   - country: Kode negara untuk top-headlines (default "us").
  /// - Returns: Daftar artikel berita.

  @Published var dataYangDiambil: [NewsArticle] = []
  
  
  func ambilBerita(query: String? = nil, country: String = "id") async {

    // Tentukan endpoint: jika ada query gunakan everything, jika tidak gunakan top-headlines
    let baseURL: String
    var params: [String: String] = ["apiKey": "c854425ad9034926baa4e239b2380bfc"]

    if let q = query, !q.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
      baseURL = "https://newsapi.org/v2/everything"
      params["q"] = q
      // Batasi hasil agar tidak terlalu banyak
      params["pageSize"] = "25"
      // Urutkan terbaru
      params["sortBy"] = "publishedAt"
      params["language"] = "en"
    } else {
      baseURL = "https://newsapi.org/v2/top-headlines"
      params["country"] = country
      params["pageSize"] = "25"
    }

    do {
      // Alamofire async request and validation
      let data = try await AF.request(baseURL, method: .get, parameters: params)
        .validate()
        .serializingData()
        .value

      let json = JSON(data)
      let articlesArray = json["articles"].arrayValue

      let iso8601 = ISO8601DateFormatter()
      for item in articlesArray {
        let title = item["title"].stringValue
        let description = item["description"].stringValue
        let url = item["url"].stringValue
        let urlToImage = item["urlToImage"].string
        let publishedAtStr = item["publishedAt"].string
        let publishedAt = publishedAtStr.flatMap { iso8601.date(from: $0) }

        let article = NewsArticle(
          title: title,
          description: description,
          url: url,
          urlToImage: urlToImage,
          publishedAt: publishedAt
        )
        print("JUDUL BERITA:", title)
//        daftarArtikel.append(article)
        self.dataYangDiambil.append(article)
      }

    } catch {
      print("❌ Error:", error)
    }

//    return daftarArtikel
  }
}
