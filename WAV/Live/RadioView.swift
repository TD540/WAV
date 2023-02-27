//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct RadioView: View {
    @Environment(\.colorScheme) var colorScheme
    @StateObject var radio: Radio

    var animatedScale: Double {
        radio.isPlaying ? 1.0 : 0.8
    }

    var body: some View {
        VStack {
            Image("WAVLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .scaledToFit()
                .padding()

            if radio.isOffAir == false {
                Button {
                    if radio.isPlaying {
                        radio.stop()
                    } else {
                        radio.play()
                    }
                } label: {
                    PixelButton(isPlaying: $radio.isPlaying)
                        .overlay {
                            Image("WAVBol")
                                .resizable()
                                .renderingMode(.template)
                                .foregroundColor(colorScheme == .light ? .white : .black)
                                .shadow(color: .black.opacity(0.1), radius: 3, y: 7)
                                .scaledToFill()
                                .scaleEffect(animatedScale)
                                .animation(.interactiveSpring(), value: animatedScale)
                                .padding()
                                .mask {
                                    PixelButton(isPlaying: $radio.isPlaying)
                                }

                        }
                }
                .padding()
            }
        }
        .padding()
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
        // radio.artURL = URL(string: "https://thumbnailer.mixcloud.com/unsafe/288x288/extaudio/5/4/b/2/b201-d6f9-4688-b1e5-efcc63dc8100")
        radio.title = "Title"
        return RadioView(radio: radio)
    }
}
