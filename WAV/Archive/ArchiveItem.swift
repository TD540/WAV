//
//  ArchiveItem.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI

struct ArchiveItem: View {
    let record: WAVPost
    let action: () -> Void
    let spacing: Double = 5
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Button {
                action()
            } label: {
                archiveItemButtonLabel(record: record)
            }
            archiveItemInfo(record: record)
        }
    }
    func archiveItemButtonLabel(record: WAVPost) -> some View {
        AsyncImage(url: record.pictureURL) { image in
            image
                .centerCropped()
                .aspectRatio(100/66.7, contentMode: .fit)
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1.5, contentMode: .fit)
                .background(.black.opacity(0.1))
        }
    }
    func archiveItemInfo(record: WAVPost) -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            Group {
                Text(record.name.uppercased())
                    .frame(alignment: .leading)
                    .padding(8)
                    .foregroundColor(.white)
                    .background(.black)
                Text(record.dateFormatted.uppercased())
            }
            .lineSpacing(8)
            .font(.custom("pixelmix", size: 14))
        }
    }
}

struct ArchiveItem_Previews: PreviewProvider {
    static var previews: some View {
        let wavPost = WAVPost(
            id: 1,
            date: "2022-12-24T17:43:55",
            title: WAVPost.Title(rendered: "88 Black Gravity X-Mas Rhythms for the brain"),
            mixcloudURL: "https://www.mixcloud.com/WeAreVarious/privat-live-aus-at-de-nor-08-07-22/",
            embedded: WAVPost.Embedded(
                wpFeaturedmedia:
                    [
                        WAVPost.WpFeaturedmedia(
                            sourceURL:
                                "https://wearevarious.com/wp-content/uploads/2022/12/common-divisor-nikolai-23-12-2022-300x300.jpeg"
                        )
                    ]
            )
        )
        ArchiveItem(
            record: wavPost
        ) { /* action */ }
    }
}

extension Image {
    func centerCropped() -> some View {
        GeometryReader { geo in
            self
                .resizable()
                .scaledToFill()
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
        }
    }
}
