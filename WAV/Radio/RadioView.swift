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
            VStack(spacing: 0) {
                ZStack {
                    if let artURL = radio.artURL {
                        AsyncImage(url: artURL) { image in
                            image
                                .resizable()
                                .scaledToFit()
                        } placeholder: {
                            ZStack {
                                Rectangle()
                                    .fill(Color.accentColor)
                                    .scaledToFit()
                                ProgressView()
                                    .progressViewStyle(CircularProgressViewStyle(tint: .white))
                            }
                        }
                    } else {
                        ZStack(alignment: .bottom) {
                            Image("Globe")
                                .resizable()
                                .scaledToFit()
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
                            }
                        }
                        .aspectRatio(1, contentMode: .fit)
                    }
                }
                .modifier(ParallaxMotionModifier(manager: manager, magnitude: 10))
                .padding()

                Button {
                    if radio.isPlaying {
                        radio.stop()
                    } else {
                        radio.play()
                    }
                } label: {
                    PixelButton(isPlaying: $radio.isPlaying)
                }
                .offset(CGSize(width: 0, height: -70))
                .shadow(color: .black.opacity(0.3), radius: 15, x: 0.0, y: -30.0)
            }
        }
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
