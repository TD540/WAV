//
//  ArchiveItem.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI

struct ArchiveItem: View {
    @Environment(\.colorScheme) var colorScheme
    @State var categories: WAVCategories = []
    var infiniteViewModel: InfiniteView.ViewModel
    let index: Int
    var wavShow: WAVShow {
        infiniteViewModel.wavShows[index]
    }
    var isPlayingBinding: Binding<Bool> {
        Binding {
            wavShow == infiniteViewModel.archiveDataController.state.selectedShow
            &&
            infiniteViewModel.archiveDataController.state.isPlaying
        } set: { _ in }
    }
    let spacing: Double = 4
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            Button {
                if infiniteViewModel.archiveDataController.state.selectedShow != wavShow {
                    UINotificationFeedbackGenerator().notificationOccurred(.success)
                    infiniteViewModel.archiveDataController.state.selectedShow = wavShow
                    // print("WAV: now loading \(wavShow.mixcloudWidget)")
                } else {
                    infiniteViewModel.archiveDataController.state.playPause.toggle()
                }
            } label: {
                image()
            }
            archiveItemInfo()
        }
    }
    func image() -> some View {
        ZStack {
            AsyncImage(url: wavShow.pictureURL) { image in
                image
                    .centerCropped()
                    .aspectRatio(100/66.7, contentMode: .fit)
                    .overlay {
                        PixelButton(isPlaying: isPlayingBinding)
                            .blendMode(.hardLight)
                            .frame(maxWidth: 60, maxHeight: 90)
                    }
            } placeholder: {
                ProgressView()
                    .frame(maxWidth: .infinity, maxHeight: .infinity)
                    .aspectRatio(1.5, contentMode: .fit)
                    .background(.black.opacity(0.1))
            }
        }
//        .onAppear {
//            /*
//             load categories and tags
//             and
//             https://wearevarious.com/wp-json/wp/v2/tags?post=104390&_fields=name
//             */
//        }
    }
    func archiveItemInfo() -> some View {
        VStack(alignment: .leading, spacing: spacing) {
            Group {
                Group {
                    Text(wavShow.name.uppercased())
                        .wavBlack()
                    FlexibleView(
                        availableWidth: UIScreen.main.bounds.width,
                        data: categories.map {
                            $0.name.stringByDecodingHTMLEntities
                        },
                        spacing: 4,
                        alignment: .leading
                    ) { item in
                        Text(verbatim: item)
                            .wavBlack(size: 10)
                    }
                }
                .frame(alignment: .leading)
                Text(wavShow.dateFormatted.uppercased())
                    .padding(.vertical, 4)
                    .font(.custom("pixelmix", size: 10))
            }
        }
        .onAppear {
            self.loadCategories()
        }
    }
    func loadCategories() {
        let url = URL(string: "https://wearevarious.com/wp-json/wp/v2/categories?post=\(wavShow.id)&_fields=name")!
        // print("WAV: loadCategories \(url.description)")
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Error: no data received")
                return
            }
            do {
                let categories = try JSONDecoder().decode(WAVCategories.self, from: data)
                DispatchQueue.main.async {
                    self.categories = categories
                }
            } catch let error {
                print("Error decoding JSON: \(error)")
            }
        }
        task.resume()
    }
}

struct ArchiveItem_Previews: PreviewProvider {
    static var previews: some View {
        ArchiveItem(
            infiniteViewModel: InfiniteView.ViewModel.preview,
            index: 0
        )
        .padding()
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(.white.opacity(0.15))
        .preferredColorScheme(.dark)
    }
}
