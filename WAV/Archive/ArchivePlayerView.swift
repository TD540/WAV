//
//  ArchivePlayerView.swift
//  WeAreVarious
//
//  Created by Thomas on 16/04/2021.
//

import SwiftUI
import WebView

struct ArchivePlayerView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme

    var body: some View {
        WebView(webView: dataController.webViewStore.webView)
            .frame(height: 60)
            .onAppear {
                if let selectedShow = dataController.selectedShow {
                    dataController.webViewStore.webView.load(
                        URLRequest(url: selectedShow.mixcloudWidget)
                    )
                }
            }
            .onDisappear {
                dataController.webViewStore.webView.loadHTMLString("", baseURL: nil)
            }
            .onChange(of: dataController.selectedShow) { selectedShow in
                if let selectedShow {
                    dataController.webViewStore.webView.load(
                        URLRequest(url: selectedShow.mixcloudWidget)
                    )
                } else {
                    dataController.webViewStore.webView.loadHTMLString("", baseURL: nil)
                }
            }
    }

    //    func backgroundView() -> some View {
    //        ZStack {
    //            BlurView(style: .systemUltraThinMaterial)
    //            if state.selectedShow != nil {
    //                if colorScheme == .light {
    //                    Color("WAVPink")
    //                        .blendMode(.multiply)
    //                } else {
    //                    Color.accentColor
    //                        .blendMode(.multiply)
    //                }
    //            }
    //        }
    //        .edgesIgnoringSafeArea(.bottom)
    //    }

    //    func notPlayingView() -> some View {
    //        Text("WE ARE VARIOUS")
    //            .multilineTextAlignment(.center)
    //            .font(Font.custom("pixelmix", size: 16))
    //            .lineSpacing(16)
    //            .padding()
    //    }

    //    func rotatingRecordView(_ wavShow: WAVShow) -> some View {
    //        VStack {
    //            Button {
    //                withAnimation {
    //                    scrollProxy.scrollTo(state.selectedShow?.id, anchor: .center)
    //                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
    //                }
    //            } label: {
    //                RecordView(pictureURL: wavShow.pictureURL)
    //            }
    //            .frame(width: 256, height: 60)
    //            .buttonStyle(RotatingButtonStyle(isRotating: state.isPlaying))
    //            .rotation3DEffect(.degrees(40), axis: (x: 0.1, y: 0, z: 0), perspective: 0.5)
    //            .shadow(color: .black.opacity(0.6), radius: 10, x: 0.0, y: 15.0)
    //
    //            Text(wavShow.name)
    //                .foregroundColor(.white)
    //                .textCase(.uppercase)
    //                .multilineTextAlignment(.center)
    //                .font(Font.custom("pixelmix", size: 10))
    //                .lineSpacing(8)
    //                .padding(10)
    //                .shadow(color: .black, radius: 5, x: 0, y: 5)
    //        }
    //        .frame(maxWidth: .infinity)
    //    }

}

struct WebPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        let controller = DataController()
        controller.selectedShow = WAVShow.preview
        return VStack {
            Spacer()
            ArchivePlayerView()
                .environmentObject(controller)
        }
    }
}
