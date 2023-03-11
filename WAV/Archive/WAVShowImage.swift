//
//  WAVShowImage.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct WAVShowImage: View {
    @EnvironmentObject var dataController: DataController
    var wavShow: WAVShow
    var isPlaying: Bool {
        dataController.selectedShow == wavShow
        &&
        dataController.archiveShowIsPlaying
    }

    var body: some View {
        Button {
            // if selectedShow does not equal this item's wavShow
            if dataController.selectedShow != wavShow {
                dataController.playArchiveShow(wavShow: wavShow)
            } else {
                dataController.toggleArchiveShowPlayback()
            }
        } label: {
            GeometryReader { geo in
                WebImage(url: wavShow.pictureURL)
                    .placeholder {
                        ProgressView()
                    }
                    .resizable()
                    .scaledToFill()
                    .allowsHitTesting(false)
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .overlay {
                        VStack {
                            Spacer()
                            HStack {
                                PixelButton(
                                    color: .white,
                                    isPlaying: Binding { isPlaying }
                                )
                                .frame(maxWidth: geo.size.height/100*10, maxHeight: geo.size.height/100*10)
                                .padding(10)
                                .background(Color.black.opacity(0.7))
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
            }
            .aspectRatio(100/66.7, contentMode: .fit)
        }

    }
}

struct WAVShowImage_Previews: PreviewProvider {
    static var previews: some View {
        WAVShowImage(wavShow: WAVShow.preview)
            .environmentObject(DataController())
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white.opacity(0.15))
    }
}
