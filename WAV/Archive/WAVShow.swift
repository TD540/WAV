//
//  WAVShow.swift
//  WAV
//
//  Created by Thomas on 01/01/2023.
//

import Foundation
import SwiftUI

struct WAVShow {
    let id: Int
    let date: String
    let link: String
    let title: WAVShow.Title
    let sticky: Bool
    let categories, tags: [Int]
    let mixcloudURL, tracklist: String
    let embedded: WAVShow.Embedded
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
        let wpFeaturedmedia: [WpFeaturedmedia]
        enum CodingKeys: String, CodingKey {
            case wpFeaturedmedia = "wp:featuredmedia"
        }
    }
    struct WpFeaturedmedia: Codable {
        let sourceURL: String
        let mediaDetails: MediaDetails
        enum CodingKeys: String, CodingKey {
            case sourceURL = "source_url"
            case mediaDetails = "media_details"
        }
    }
    struct MediaDetails: Codable {
        let sizes: Sizes
    }
    struct Sizes: Codable {
            let mediumLarge: MediumLarge?
            enum CodingKeys: String, CodingKey {
                case mediumLarge = "medium_large"
            }
    }
    struct MediumLarge: Codable {
        let sourceURL: String
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
    static let preview = WAVShow(
        id: 109399,
        date: "2022-12-24T17:43:55",
        link: "https://wearevarious.com/bent-von-bent/gemu-xiv-dec22/",
        title: Title(rendered: "Random WAV Show Title"),
        sticky: false,
        categories: [1040],
        tags: [1073, 368],
        mixcloudURL: "https://www.mixcloud.com/WeAreVarious/privat-live-aus-at-de-nor-08-07-22/",
        tracklist: "#todo",
        embedded: WAVShow.Embedded(
            wpFeaturedmedia:
                [
                    WAVShow.WpFeaturedmedia(
                        sourceURL:
                            "https://wearevarious.com/wp-content/uploads/2022/12/common-divisor-nikolai-23-12-2022-300x300.jpeg",
                        mediaDetails: WAVShow.MediaDetails(
                            sizes: Sizes(
                                mediumLarge: WAVShow.MediumLarge(
                                    sourceURL: "https://wearevarious.com/wp-content/uploads/2022/12/common-divisor-nikolai-23-12-2022-300x300.jpeg"
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
        let date = dateFormatter.date(from: date)
        dateFormatter.dateFormat = "MMMM d, yyyy"
        return dateFormatter.string(from: date!)
    }
    var colorScheme: ColorScheme {
        if #available(iOS 13.0, *) {
            return UIScreen.main.traitCollection.userInterfaceStyle == .dark ? .dark : .light
        } else {
            return .light
        }
    }
    var mixcloudWidget: URL {
        let range = mixcloudURL.range(of: "mixcloud.com")!
        let slug = String(mixcloudURL[range.upperBound...])
        var urlComponents = URLComponents(
            string: "https://www.mixcloud.com/widget/iframe"
        )!
        urlComponents.queryItems = [
            URLQueryItem(name: "light", value: colorScheme == .light ? "1" : "0"),
            URLQueryItem(name: "hide_cover", value: "1"),
            URLQueryItem(name: "mini", value: "1"),
            URLQueryItem(name: "hide_artwork", value: "1"),
            URLQueryItem(name: "autoplay", value: WAVShow.autoplay ? "1" : "0"),
            URLQueryItem(name: "feed", value: slug.addingPercentEncoding(withAllowedCharacters: .urlPathAllowed)!),
        ]
        return urlComponents.url!
    }
    var pictureURL: URL {
        if let mediumLarge = embedded.wpFeaturedmedia.first?.mediaDetails.sizes.mediumLarge {
            return URL(string: mediumLarge.sourceURL)!
        } else {
            return URL(string: embedded.wpFeaturedmedia.first!.sourceURL)!
        }
    }
}

typealias WAVShows = [WAVShow]
