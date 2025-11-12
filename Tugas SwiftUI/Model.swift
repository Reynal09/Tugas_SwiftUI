import Foundation
import SwiftyJSON

struct NewsArticle: Identifiable, Hashable {
    let id = UUID()
    let title: String
    let description: String
    let url: String
    let urlToImage: String?
    let publishedAt: Date?

    init(json: JSON) {
        self.title = json["title"].stringValue
        self.description = json["description"].stringValue
        self.url = json["url"].stringValue
        self.urlToImage = json["urlToImage"].string

        if let dateString = json["publishedAt"].string {
            let formatter = ISO8601DateFormatter()
            self.publishedAt = formatter.date(from: dateString)
        } else {
            self.publishedAt = nil
        }
    }
}
