//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct RadioView: View {
    @StateObject var radio: Radio
    var body: some View {
        VStack(spacing: 0) {

            RadioViewHeader()

            // Radio Artwork
            if let artURL = radio.artURL {
                AsyncImage(url: artURL) { image in
                    Artwork(image: image)
                } placeholder: {
                    ArtworkPlaceholder()
                }
                .padding(.top, -70)
            }

            if radio.isOffAir == false {
                Button {
                    if radio.isPlaying {
                        radio.stop()
                    } else {
                        radio.play()
                    }
                } label: {
                    PixelButton(isPlaying: $radio.isPlaying)
                }
                .shadow(color: .black.opacity(0.3), radius: 25, x: 0.0, y: -10.0)
                .padding(.top, -80)
            }

            RadioMarquee(text: radio.title, size: 24)
                .padding(.top, 20)

        }
        .padding(.bottom, 20)
        .onAppear {
            radio.updateState()
        }
    }
}

struct NoButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        let radio = Radio()
        //                radio.artURL = URL(string: "https://thumbnailer.mixcloud.com/unsafe/288x288/extaudio/5/4/b/2/b201-d6f9-4688-b1e5-efcc63dc8100")
        radio.title = "Title"
        return RadioView(radio: radio)
    }
}
