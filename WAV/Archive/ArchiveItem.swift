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
    var body: some View {
        VStack(alignment: .leading) {
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
                .resizable()
                .scaledToFit()
        } placeholder: {
            ProgressView()
                .frame(maxWidth: .infinity, maxHeight: .infinity)
                .aspectRatio(1.5, contentMode: .fit)
                .background(.black.opacity(0.1))
        }
    }
    func archiveItemInfo(record: WAVPost) -> some View {
        VStack(alignment: .leading) {
            Group {
                Text(record.name.uppercased())
                    .foregroundColor(.white)
                    .padding(8)
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
        ArchiveItem(
            record: WAVPost(
                id: 1,
                date: "2022-12-24T17:43:55",
                title: WAVPost.Title(rendered: "88 Black Gravity X-Mas Rhythms for the brain"),
                mixcloudURL: "https://www.mixcloud.com/WeAreVarious/privat-live-aus-at-de-nor-08-07-22/",
                embedded: WAVPost.Embedded(
                    wpFeaturedmedia:
                        [
                            WAVPost.WpFeaturedmedia(
                                sourceURL:
                                    "https://dev.wearevarious.com/wp-content/uploads/2022/07/privat-live-at-de-nor-.jpg"
                            )
                        ]
                )
            )
        ) { /* action */ }
    }
}
