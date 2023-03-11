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
    @State var imageLoaded = false

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
                    .onSuccess { _, _, _ in
                        imageLoaded = true
                    }
                    .resizable()
                    .scaledToFill()
                    .frame(width: geo.size.width, height: geo.size.height)
                    .clipped()
                    .overlay {
                        // a play button
                        // todo: loading state
                        VStack {
                            Spacer()
                            HStack {
                                PixelButton(
                                    color: .white,
                                    isPlaying: Binding() {
                                        wavShow == dataController.selectedShow
                                        &&
                                        dataController.archiveShowIsPlaying
                                    } set: { _ in }
                                )
                                .frame(maxWidth: geo.size.height/100*10, maxHeight: geo.size.height/100*10)
                                .opacity(imageLoaded ? 1 : 0)
                                .animation(.easeOut, value: imageLoaded)
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
