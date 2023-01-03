//
//  ArchivePlayerView.swift
//  WeAreVarious
//
//  Created by Thomas on 16/04/2021.
//

import SwiftUI
import WebView

struct ArchivePlayerView: View {
    @StateObject private var model: ArchivePlayerViewModel
    @Environment(\.colorScheme) var colorScheme
    var scrollProxy: ScrollViewProxy
    init(archiveDataController: ArchiveDataController, scrollProxy: ScrollViewProxy) {
        let model = ArchivePlayerViewModel(archiveDataController: archiveDataController)
        _model = StateObject(wrappedValue: model)
        self.scrollProxy = scrollProxy
    }

    var body: some View {
        ZStack {
            WebView(webView: model.webViewStore.webView)
                .frame(width: 0, height: 0)
                .onChange(of: model.archiveDataController.state.selectedPost, perform: model.onPlayingRecordChanging)
                .onChange(of: model.archiveDataController.state.playPause) { _ in
                    model.playToggle()
                }

            if let wavPost = model.archiveDataController.state.selectedPost {
                playingView(wavPost)
                    .background(
                        backgroundView()
                    )
            }
        }
    }

    func backgroundView() -> some View {
        ZStack {
            BlurView(style: .systemUltraThinMaterial)
            if model.archiveDataController.state.selectedPost != nil {
                if colorScheme == .light {
                    Color("WAVPink")
                        .blendMode(.multiply)
                } else {
                    Color.accentColor
                        .blendMode(.multiply)
                }
            }
        }
        .edgesIgnoringSafeArea(.bottom)
    }

    func notPlayingView() -> some View {
        Text("WE ARE VARIOUS")
            .multilineTextAlignment(.center)
            .font(Font.custom("pixelmix", size: 16))
            .lineSpacing(16)
            .padding()
    }

    func playingView(_ wavPost: WAVPost) -> some View {
        VStack {
            Button {
                withAnimation {
                    scrollProxy.scrollTo(model.archiveDataController.state.selectedPost?.id, anchor: .center)
                    UINotificationFeedbackGenerator().notificationOccurred(.warning)
                }
            } label: {
                RecordView(pictureURL: wavPost.pictureURL)
            }
            .frame(width: 256, height: 60)
            .buttonStyle(RotatingButtonStyle(isRotating: model.archiveDataController.state.isPlaying))
            .rotation3DEffect(.degrees(40), axis: (x: 0.1, y: 0, z: 0), perspective: 0.5)
            .shadow(color: .black.opacity(0.6), radius: 10, x: 0.0, y: 15.0)

            Text(wavPost.name)
                .foregroundColor(.white)
                .textCase(.uppercase)
                .multilineTextAlignment(.center)
                .font(Font.custom("pixelmix", size: 10))
                .lineSpacing(8)
                .padding(10)
                .shadow(color: .black, radius: 5, x: 0, y: 5)
        }
        .frame(maxWidth: .infinity)
    }
}

struct WebPlayerView_Previews: PreviewProvider {
    static var previews: some View {
        WAVPost.autoplay = false
        let controller = ArchiveDataController.preview
        controller.state.selectedPost = WAVPost.preview
        controller.state.isPlaying = false
        return ScrollViewReader { scrollProxy in
            VStack {
                Spacer()
                ArchivePlayerView(archiveDataController: controller, scrollProxy: scrollProxy)
            }
        }
        // .preferredColorScheme(.dark)
    }
}
