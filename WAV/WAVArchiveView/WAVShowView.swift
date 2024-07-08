//
//  WAVShowView.swift
//  WAV
//

import SwiftUI
import Kingfisher

struct WAVShowView: View {
    @EnvironmentObject var dataController: DataController
    var wavShow: WAVShow
    var category: WAVCategory?
    var tag: WAVTag?
    @State private var progress: CGFloat = 0

    var isPlaying: Bool {
        dataController.selectedShow == wavShow
        &&
        dataController.archiveShowIsPlaying
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            Button {
                if dataController.selectedShow != wavShow {
                    dataController.selectedShow = wavShow
                }
            } label: {
                GeometryReader { geometry in
                    KFImage(wavShow.pictureURL)
                        .placeholder {
                            WAVShowImagePlaceholder(loaded: progress)
                        }
                        .onProgress { receivedSize, totalSize in
                            self.progress = CGFloat(receivedSize) / CGFloat(totalSize)
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .clipped()
                }
                .aspectRatio(100/66.7, contentMode: .fit)
            }
            .overlay(alignment: .bottomLeading) {
                if isPlaying == false {
                    ZStack {
                        Color.black.opacity(0.5)
                            .aspectRatio(1, contentMode: .fit)
                        Image("play-pixels")
                            .resizable()
                            .renderingMode(.template)
                            .foregroundColor(.white)
                            .scaledToFit()
                            .scaleEffect(0.5)
                    }
                    .scaleEffect(0.17, anchor: .bottomLeading)
                }
            }


            Text(wavShow.name.uppercased())
                .wavBlack(size: 13, vPadding: 6)
                .lineSpacing(5)

            if category == nil {
                WAVShowCategories(wavShow: wavShow, hideCategory: category)
            }

            Text(wavShow.dateFormatted.uppercased())
                .foregroundColor(.white)
                .padding(.vertical, 2)
                .padding(.horizontal, 4)
                .font(Font.custom("Helvetica Neue Medium", size: 13))

            ScrollView(.horizontal, showsIndicators: false) {
                if tag == nil {
                    WAVShowTags(wavShow: wavShow, hideTag: tag)
                        .padding(.trailing, 50)
                }
            }
            .mask(
                LinearGradient(gradient: Gradient(stops: [
                    .init(color: .white, location: 0),
                    .init(color: .white, location: 0.80),
                    .init(color: .clear, location: 0.98)
                ]), startPoint: .leading, endPoint: .trailing)
                .frame(height: 100)
            )
        }
    }
}

#Preview {
    let dataController = DataController()
    var wavShow = WAVShow.preview

    // Safely handle the assignment
    if wavShow.embedded.wpFeaturedmedia[0].mediaDetails?.sizes.mediumLarge == nil {
        wavShow.embedded.wpFeaturedmedia[0].mediaDetails?.sizes.mediumLarge = WAVShow.MediumLarge(sourceURL: "https://wearevarious.com/wp-content/uploads/2023/11/BTWAV6.jpg")
    } else {
        wavShow.embedded.wpFeaturedmedia[0].mediaDetails?.sizes.mediumLarge?.sourceURL = "https://wearevarious.com/wp-content/uploads/2023/11/BTWAV6.jpg"
    }

    dataController.selectedShow = wavShow
    dataController.archiveShowIsPlaying = false

    return WAVShowView(wavShow: wavShow)
        .environmentObject(dataController)
        .background(.black)
}
