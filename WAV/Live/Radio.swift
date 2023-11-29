//
//  RadioView.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

import SwiftUI

struct Radio: View {
    @EnvironmentObject var dataController: DataController
    @State private var scale: CGFloat = 1.0

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
                    .scaleEffect(scale)
                    .onTapGesture {
                        withAnimation(.spring(response: 0.1, dampingFraction: 0.3, blendDuration: 0)) {
                            self.scale = 0.75
                        }
                        withAnimation(.spring(response: 0.1, dampingFraction: 0.3, blendDuration: 0).delay(0.1)) {
                            self.scale = 1
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

#Preview {
    let dataController = DataController()
    dataController.radioTitle = "Title"
    return Radio()
        .environmentObject(dataController)
}
