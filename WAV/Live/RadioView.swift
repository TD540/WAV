//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct RadioView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme
    
    var isPlayingBinding: Binding<Bool> {
        Binding {
            dataController.radioIsPlaying
        } set: { _ in }
    }

    var animatedScale: Double {
        dataController.radioIsPlaying ? 1.0 : 0.8
    }

    var body: some View {
        VStack {
            Image("WAVLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .scaledToFit()
                .padding()
                .padding(.horizontal, 30)

            if dataController.radioIsOffAir == false {
                Button {
                    if dataController.radioIsPlaying {
                        dataController.stopRadio()
                    } else {
                        dataController.playRadio()
                        dataController.state.selectedShow = nil
                    }
                } label: {
                    PixelButton(isPlaying: isPlayingBinding)
//                        .overlay {
//                            Image("WAVBol")
//                                .resizable()
//                                .renderingMode(.template)
//                                .foregroundColor(colorScheme == .light ? .white : .black)
//                                .shadow(color: .black.opacity(0.1), radius: 3, y: 7)
//                                .scaledToFill()
//                                .scaleEffect(animatedScale)
//                                .animation(.interactiveSpring(), value: animatedScale)
//                                .padding()
//                                .mask {
//                                    PixelButton(isPlaying: $radio.isPlaying)
//                                }
//
//                        }
                }
                .shadow(color: .black.opacity(0.1), radius: 3, y: 7)
                .padding()
            }
        }
        .padding()
        .onAppear {
            dataController.updateRadio()
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
        let dataController = DataController()
        // radio.artURL = URL(string: "https://thumbnailer.mixcloud.com/unsafe/288x288/extaudio/5/4/b/2/b201-d6f9-4688-b1e5-efcc63dc8100")
        dataController.radioTitle = "Title"
        return RadioView()
            .environmentObject(dataController)
    }
}
