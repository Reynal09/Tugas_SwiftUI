import Foundation
import Alamofire
import SwiftyJSON

class Networking {
    private let apiKey = "c854425ad9034926baa4e239b2380bfc"

    func fetchData(query: String? = nil, country: String = "us", completion: @escaping ([NewsArticle]) -> Void) {
        let baseURL: String
        var params: [String: String] = [:]

        // --- Pilih endpoint sesuai query ---
        if let q = query, !q.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty {
            baseURL = "https://newsapi.org/v2/everything"
            params["q"] = q
            params["pageSize"] = "25"
            params["sortBy"] = "publishedAt"
            params["language"] = "en"
        } else {
            baseURL = "https://newsapi.org/v2/top-headlines"
            params["country"] = country
            params["pageSize"] = "25"
        }

        // --- Gunakan header Authorization (lebih stabil) ---
        let headers: HTTPHeaders = [
            "Authorization": apiKey
        ]

        AF.request(baseURL, method: .get, parameters: params, headers: headers)
            .validate()
            .responseData { response in
                switch response.result {
                case .success(let data):
                    let json = JSON(data)
                    if let status = json["status"].string, status != "ok" {
                        print("⚠️ Response status:", status, "| Message:", json["message"].stringValue)
                    }

                    let articlesArray = json["articles"].arrayValue
                    let daftarArtikel = articlesArray.map { NewsArticle(json: $0) }

                    print("✅ Jumlah berita:", daftarArtikel.count)
                    if daftarArtikel.isEmpty {
                        print("⚠️ Tidak ada berita ditemukan. Response JSON:\n", json)
                    }
                    completion(daftarArtikel)

                case .failure(let error):
                    print("❌ Gagal ambil data:", error.localizedDescription)
                    completion([])
                }
            }
    }
}
