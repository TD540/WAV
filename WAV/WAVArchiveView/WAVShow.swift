//
//  WAVShow.swift
//  WAV
//

import Foundation
import SwiftUI

struct WAVShow: Identifiable {
    let id: Int
    let date: String
    let link: String
    let title: WAVShow.Title
    let sticky: Bool
    let categories, tags: [Int]
    let mixcloudURL, tracklist: String
    var embedded: WAVShow.Embedded
}

// static settings //dev
extension WAVShow {
    static var autoplay = true
}

// WP Rest API stuff
extension WAVShow: Codable {
    struct Title: Codable {
        let rendered: String
    }
    struct Embedded: Codable {
        var wpFeaturedmedia: [WpFeaturedmedia]
        enum CodingKeys: String, CodingKey {
            case wpFeaturedmedia = "wp:featuredmedia"
        }
    }
    struct WpFeaturedmedia: Codable {
        var sourceURL: String?
        var mediaDetails: MediaDetails?
        enum CodingKeys: String, CodingKey {
            case sourceURL = "source_url"
            case mediaDetails = "media_details"
        }
    }
    struct MediaDetails: Codable {
        var sizes: Sizes
    }
    struct Sizes: Codable {
        var mediumLarge: MediumLarge?
        enum CodingKeys: String, CodingKey {
            case mediumLarge = "medium_large"
        }
    }
    struct MediumLarge: Codable {
        var sourceURL: String
        enum CodingKeys: String, CodingKey {
            case sourceURL = "source_url"
        }
    }
    enum CodingKeys: String, CodingKey {
        case id, date, link, title,
             sticky, categories, tags,
             tracklist
        case mixcloudURL = "mixcloud_url"
        case embedded = "_embedded"
    }
}

// static preview
extension WAVShow {
    static var preview = WAVShow(
        id: 109399,
        date: "2022-12-24T17:43:55",
        link: "https://wearevarious.com/bent-von-bent/gemu-xiv-dec22/",
        title: Title(rendered: "Random WAV Show Title"),
        sticky: false,
        categories: [1040],
        tags: [1073, 368],
        //mixcloudURL: "https://www.mixcloud.com/WeAreVarious/privat-live-aus-at-de-nor-08-07-22/",
        mixcloudURL: "https://soundcloud.com/we-are-various-wav/dj-aldolino-for-we-are-various-28-11-23",
        tracklist: "#todo",
        embedded: WAVShow.Embedded(
            wpFeaturedmedia:
                [
                    WAVShow.WpFeaturedmedia(
                        sourceURL:
                            "https://wearevarious.com/wp-content/uploads/2023/02/cover-10-jaar-vleugel-fou-uai-548x365.jpg",
                        mediaDetails: WAVShow.MediaDetails(
                            sizes: Sizes(
                                mediumLarge: WAVShow.MediumLarge(
                                    sourceURL: "https://wearevarious.com/wp-content/uploads/2023/02/cover-10-jaar-vleugel-fou-uai-548x365.jpg"
                                )
                            )
                        )
                    )
                ]
        )
    )
}

extension WAVShow: Equatable {
    static func == (lhs: WAVShow, rhs: WAVShow) -> Bool {
        lhs.id == rhs.id
    }
}

// computed properties
extension WAVShow {
    var name: String {
        title.rendered.stringByDecodingHTMLEntities
    }
    var dateFormatted: String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ss"
        dateFormatter.locale = Locale(identifier: "en_US_POSIX")
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date!)
    }
    var isMixcloud: Bool {
        mixcloudURL.lowercased().contains("mixcloud.com")
    }
    var isSoundcloud: Bool {
        mixcloudURL.lowercased().contains("soundcloud.com")
    }
    var widgetURL: URL? {
        if isMixcloud {
            guard let range = mixcloudURL.range(of: "mixcloud.com", options: .caseInsensitive) else {
                return nil
            }
            let slug = String(mixcloudURL[range.upperBound...])
            var urlComponents = URLComponents(
                string: "https://www.mixcloud.com/widget/iframe"
            )!
            urlComponents.queryItems = [
                URLQueryItem(name: "light", value: "0"),
                URLQueryItem(name: "hide_cover", value: "1"),
                URLQueryItem(name: "mini", value: "1"),
                URLQueryItem(name: "hide_artwork", value: "1"),
                URLQueryItem(name: "autoplay", value: WAVShow.autoplay ? "1" : "0"),
                URLQueryItem(name: "feed", value: slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!),
            ]
            return urlComponents.url
        } else if (isSoundcloud) {
            var urlComponents = URLComponents(
                string: "https://w.soundcloud.com/player/"
            )!
            urlComponents.queryItems = [
                URLQueryItem(name: "url", value: mixcloudURL),
                URLQueryItem(name: "color", value: "2B44F5"),
                URLQueryItem(name: "auto_play", value: "true"),
                URLQueryItem(name: "hide_related", value: "true"),
                URLQueryItem(name: "show_comments", value: "false"),
                URLQueryItem(name: "show_user", value: "false"),
                URLQueryItem(name: "show_reposts", value: "false"),
                URLQueryItem(name: "show_teaser", value: "false"),
                URLQueryItem(name: "visual", value: "false")
            ]
            return urlComponents.url
        } else {
            return nil
        }
    }
    var pictureURL: URL? {
        if let mediumLargeURL = embedded.wpFeaturedmedia.first?.mediaDetails?.sizes.mediumLarge?.sourceURL {
            return URL(string: mediumLargeURL)
        } else if let url = embedded.wpFeaturedmedia.first?.sourceURL {
            return URL(string: url)
        } else {
            return nil
        }
    }
}

typealias WAVShows = [WAVShow]
