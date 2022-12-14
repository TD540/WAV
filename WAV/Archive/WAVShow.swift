//
//  WAVShow.swift
//  WAV
//
//  Created by Thomas on 01/01/2023.
//

import Foundation

typealias WAVShows = [WAVShow]

struct WAVShow: Codable, Identifiable, Equatable {
    static func == (lhs: WAVShow, rhs: WAVShow) -> Bool {
        lhs.id == rhs.id
    }

    let id: Int
    let date: String
    let title: Title
    let mixcloudURL: String
    let embedded: Embedded

    enum CodingKeys: String, CodingKey {
        case id, date, title
        case mixcloudURL = "mixcloud_url"
        case embedded = "_embedded"
    }

    static var autoplay = true

    var name: String {
        title.rendered
    }
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date!)
    }
    var mixcloudWidget: URL {
        let range = mixcloudURL.range(of: "mixcloud.com")!
        let slug = String(mixcloudURL[range.upperBound...])
        let widgetURL = "https://www.mixcloud.com/widget/iframe/?hide_cover=1&mini=1&hide_artwork=1" +
        "&autoplay=\(WAVShow.autoplay ? "1" : "0")" +
        "&feed=" +
        "\(slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!)"
        return URL(string: widgetURL)!
    }
    var pictureURL: URL {
        URL(string: embedded.wpFeaturedmedia.first!.sourceURL)!
    }

    struct Embedded: Codable {
        let wpFeaturedmedia: [WpFeaturedmedia]
        enum CodingKeys: String, CodingKey {
            case wpFeaturedmedia = "wp:featuredmedia"
        }
    }
    struct WpFeaturedmedia: Codable {
        let sourceURL: String
        enum CodingKeys: String, CodingKey {
            case sourceURL = "source_url"
        }
    }
    struct Title: Codable {
        let rendered: String
    }

    static let preview = WAVShow(
        id: 1,
        date: "2022-12-24T17:43:55",
        title: WAVShow.Title(rendered: "Random WAV Show Title"),
        mixcloudURL: "https://www.mixcloud.com/WeAreVarious/privat-live-aus-at-de-nor-08-07-22/",
        embedded: WAVShow.Embedded(
            wpFeaturedmedia:
                [
                    WAVShow.WpFeaturedmedia(
                        sourceURL:
                            "https://wearevarious.com/wp-content/uploads/2022/12/common-divisor-nikolai-23-12-2022-300x300.jpeg"
                    )
                ]
        )
    )

}
