//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct RadioView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var radio: Radio
    @ObservedObject var manager = MotionManager()
    var body: some View {
        VStack {
            // Radio Image
            Group {
                if let artURL = radio.artURL {
                    AsyncImage(url: artURL) { image in
                        image
                            .resizable()
                            .scaledToFit()
                    } placeholder: {
                        ArtworkPlaceholder()
                    }
                } else {
                    NoArtwork()
                }
            }
            .shadow(color: .black.opacity(0.05), radius: 15, x: 0.0, y: 15.0)
            .padding(.bottom, -50)

            // Radio Button
            Button {
                if radio.isPlaying {
                    radio.stop()
                } else {
                    radio.play()
                }
            } label: {
                PixelButton(isPlaying: $radio.isPlaying)
                    .shadow(color: .black.opacity(0.3), radius: 25, x: 0.0, y: -10.0)
                    .padding(.top, -50)
            }

            // Radio Title
            if let title = radio.title {
                let cleanTitle = title.applyingTransform(.stripDiacritics, reverse: false)!
                MarqueeText(
                    text: cleanTitle,
                    font: UIFont(name: "pixelmix", size: 18)!,
                    leftFade: 0,
                    rightFade: 0,
                    startDelay: 2
                )
                .foregroundColor(.accentColor)
                .padding(.top, 30)
            }
        }
        .padding(.bottom, 50)
        .onAppear {
            radio.updateTitle()
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
        let radio = Radio.shared
        radio.title = "Title"
        return RadioView(radio: radio)
    }
}
