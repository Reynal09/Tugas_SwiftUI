import Foundation
import SwiftyJSON
import Alamofire

// Model untuk artikel berita
struct NewsArticle: Identifiable, Hashable {
  let id = UUID()
  let title: String
  let description: String
  let url: String
  let urlToImage: String?
  let publishedAt: Date?
}
  

