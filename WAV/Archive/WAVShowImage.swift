//
//  WAVShowImage.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI
import Kingfisher

struct WAVShowImage: View {
    @EnvironmentObject var dataController: DataController
    var wavShow: WAVShow

    @State var pixelBGColor = Color.black.opacity(0.4)

    var isPlaying: Bool {
        dataController.selectedShow == wavShow
        &&
        dataController.archiveShowIsPlaying
    }

    var body: some View {
        Button {
            if dataController.selectedShow != wavShow {
                dataController.selectedShow = wavShow
            }
        } label: {
            GeometryReader { geo in
                KFImage.url(wavShow.pictureURL)
                .scaledToFill()
                .allowsHitTesting(false)
                .frame(width: geo.size.width, height: geo.size.height)
                .clipped()
                .overlay {
                    if isPlaying == false {
                        // show play button
                        VStack {
                            Spacer()
                            HStack {
                                PixelButton(
                                    color: .white,
                                    isPlaying: .constant(false) // false shows play button
                                )
                                .frame(maxWidth: geo.size.height/100*7, maxHeight: geo.size.height/100*7)
                                .padding(15)
                                .shadow(color: .black.opacity(0.5), radius: 10, x: 10, y: -10)
                                .background(pixelBGColor)
                                .onChange(of: isPlaying) { _ in
                                    withAnimation {
                                        pixelBGColor = isPlaying ? Color.accentColor : .black.opacity(0.4)
                                    }
                                }
                                Spacer()
                            }
                            .frame(maxWidth: .infinity)
                        }
                        .clipped()
                        .frame(maxWidth: .infinity, maxHeight: .infinity)
                    }
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
