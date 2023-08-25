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
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.black)
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
        dataController.radioTitle = "Title"
        return Radio()
            .environmentObject(dataController)
    }
}
