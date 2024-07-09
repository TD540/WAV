//
//  WAVMarqueeView.swift
//

import SwiftUI

struct WAVMarqueeView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.safeAreaInsets) var safeAreaInsets

    var isOnAir: Bool {
        dataController.radioIsOffAir == false
    }

    var body: some View {

        let cleanTitle = dataController.radioTitle.applyingTransform(.stripDiacritics, reverse: false)!.uppercased()

        HStack(spacing: 0) {
            if isOnAir {
                Button {
                    dataController.radioIsPlaying == false ? dataController.playRadio() : dataController.stopRadio()
                } label: {
                    WAVPlayPauseView(isPlaying: Binding { dataController.radioIsPlaying })
                }
                .frame(maxHeight: 30)
                .padding(.horizontal, 12)
                .zIndex(1)
            }
            HStack {
                MarqueeView(targetVelocity: 50, spacing: 30) {
                    HStack {
                        if dataController.radioIsOffAir == false {
                            Text("NOW PLAYING:")
                                .foregroundColor(.black)
                        }
                        Text(cleanTitle)
                            .foregroundColor(dataController.radioIsOffAir ?? false ? .black.opacity(0.6) : .accentColor)
                    }
                    .font(.custom("Helvetica Neue Medium", size: 14))
                    .frame(height: Constants.marqueeHeight)
                }
            }
            .clipped()
        }
        .padding(.top, safeAreaInsets.top)

        .background {
            ZStack {
                BlurView(style: .dark)
                LinearGradient(
                    gradient: Gradient(stops: [
                        .init(color: Color.black.opacity(0.8), location: 0.0),
                        .init(color: Color.black.opacity(0.1), location: 1.0)
                    ]),
                    startPoint: .top,
                    endPoint: .bottom
                )
                .frame(height: safeAreaInsets.top)
                .edgesIgnoringSafeArea(.all)

                Color.white
                    .padding(.top, safeAreaInsets.top)
            }
        }
        .shadow(radius: 30)
        .edgesIgnoringSafeArea(.top)

    }
}

#Preview {
    VStack {
        WAVMarqueeView()
        Spacer()
    }
    .background(.gray)

}
