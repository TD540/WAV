//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct Radio: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.safeAreaInsets) var safeAreaInsets

    var isOnAir: Bool {
        dataController.radioIsOffAir == false
    }

    var body: some View {
        VStack(spacing: 20) {
            Image("WAVLogo")
                .resizable()
                .renderingMode(.template)
                .foregroundColor(.accentColor)
                .scaledToFit()

            Group {
                if isOnAir {
                    Button {
                        dataController.radioIsPlaying == false ? dataController.playRadio() : dataController.stopRadio()
                    } label: {

                        WAVGlobe(
                            isPlaying: $dataController.radioIsPlaying,
                            isLive: .constant(isOnAir)
                        )
                        .foregroundColor(.accentColor)
                        .mask {
                            RadialGradient(
                                gradient: Gradient(colors: [.black.opacity(0.35), .black]),
                                center: .center,
                                startRadius: 80,
                                endRadius: 90
                            )
                        }
                        .overlay {
                            PixelButton(isPlaying: Binding { dataController.radioIsPlaying })
                                .scaleEffect(0.25)
                        }

                    }
                    .buttonStyle(NoHighlightButtonStyle())
                } else {
                    Image("WAVBol")
                        .resizable()
                        .renderingMode(.template)
                        .foregroundColor(.accentColor)
                        .scaledToFit()
                        .opacity(0.3)
                }
            }
            .padding()

        }
        .padding(40)
        .background(.black)
        .onReceive(dataController.radioPlayer.$isPlaying) { isPlaying in
            dataController.radioIsPlaying = isPlaying
        }
    }
}

#Preview {
    let dataController = DataController()
    dataController.radioTitle = "Title"
    dataController.radioIsOffAir = false
    return Radio()
        .environmentObject(dataController)
}
