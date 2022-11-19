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
        VStack(spacing: 0) {
            RadioViewHeader()

            if let artURL = radio.artURL {
                // Show Radio Artwork
                Group {
                    AsyncImage(url: artURL) { image in
                        Artwork(image: image)
                    } placeholder: {
                        ArtworkPlaceholder()
                    }
                }
                .padding(.top, -70)
            }

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
                    .padding(.top, -70)
            }

            // Radio Title
            if let title = radio.title {
                let cleanTitle = title.uppercased().applyingTransform(.stripDiacritics, reverse: false)!
                MarqueeText(
                    text: cleanTitle,
                    font: UIFont(name: "pixelmix", size: 18)!,
                    leftFade: 0,
                    rightFade: 0,
                    startDelay: 2
                )
                .padding(.top, 20)
                .foregroundColor(.accentColor)
            }
        }
        .padding(.bottom, 20)
        .onAppear {
            radio.update()
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
//                radio.artURL = URL(string: "https://thumbnailer.mixcloud.com/unsafe/288x288/extaudio/5/4/b/2/b201-d6f9-4688-b1e5-efcc63dc8100")
                radio.title = "Title"
        return RadioView(radio: radio)
    }
}
