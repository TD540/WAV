//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct Radio: View {
    @EnvironmentObject var dataController: DataController

    var isOnAir: Bool {
        dataController.radioIsOffAir == false
        || dataController.DEBUG_radio
    }

    var body: some View {
        VStack(spacing: 30) {
            Image("WAVLogo")
                .renderingMode(.template)
                .resizable()
                .foregroundColor(.accentColor)
                .scaledToFit()

            Group {
                if isOnAir {
                    Button {
                        dataController.radioIsPlaying == false ?
                        dataController.playRadio() :
                        dataController.stopRadio()
                    } label: {
                        WAVGlobe(
                            isPlaying: $dataController.radioIsPlaying,
                            isLive: .constant(isOnAir)
                        )
                        .foregroundColor(.accentColor)
                        .overlay {
                            Circle()
                                .fill(.black.opacity(0.6))
                                .scaleEffect(0.65)
                        }
                        .overlay {
                            PixelButton(isPlaying: Binding { dataController.radioIsPlaying })
                                .scaleEffect(0.25)
                        }
                    }

                } else {
                    Image("WAVBol")
                        .renderingMode(.template)
                        .resizable()
                        .foregroundColor(.accentColor)
                        .scaledToFit()
                }
            }
            .padding(.horizontal, 30)
        }
        .padding(30)
        .onReceive(dataController.radioPlayer.$isPlaying) { isPlaying in
            dataController.radioIsPlaying = isPlaying
        }
    }
}

struct NoButtonStyle: PrimitiveButtonStyle {
    func makeBody(configuration: Configuration) -> some View {
        configuration.label
    }
}

struct Radio_Previews: PreviewProvider {
    static var previews: some View {
        let dataController = DataController()
        // radio.artURL = URL(string: "https://thumbnailer.mixcloud.com/unsafe/288x288/extaudio/5/4/b/2/b201-d6f9-4688-b1e5-efcc63dc8100")
        dataController.radioTitle = "Title"
        return Radio()
            .environmentObject(dataController)
    }
}
