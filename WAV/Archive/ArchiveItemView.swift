//
//  ArchiveItemView.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI
import SDWebImageSwiftUI

struct ArchiveItemView: View {
    @EnvironmentObject var dataController: DataController
    @Environment(\.colorScheme) var colorScheme
    
    var wavShow: WAVShow
    var playPauze: () -> Void
    
    @State var categories: WAVCategories = []
    @State var tags: WAVTags = []
    @State var imageLoaded = false
    
    var isPlayingBinding: Binding<Bool> {
        Binding {
            wavShow == dataController.state.selectedShow
            &&
            dataController.state.wavShowIsPlaying
        } set: { _ in }
    }
    
    let spacing: Double = 4
    
    var body: some View {
        VStack(alignment: .leading, spacing: spacing) {
            
            // Show image with play button overlay
            Button {
                playPauze()
            } label: {
                GeometryReader { geo in
                    WebImage(url: wavShow.pictureURL)
                        .placeholder {
                            ProgressView()
                        }
                        .onSuccess { _, _, _ in
                            imageLoaded = true
                        }
                        .resizable()
                        .scaledToFill()
                        .frame(width: geo.size.width, height: geo.size.height)
                        .clipped()
                        .background(.black.opacity(0.1))
                        .overlay {
                            // a play button
                            // todo: loading state
                            VStack {
                                Spacer()
                                HStack {
                                    PixelButton(isPlaying: isPlayingBinding, color: .white)
                                        .frame(maxWidth: geo.size.height/100*10, maxHeight: geo.size.height/100*10)
                                        .opacity(imageLoaded ? 1 : 0)
                                        .animation(.easeOut, value: imageLoaded)
                                        .padding(10)
                                        .background(Color.black.opacity(0.7))
                                    Spacer()
                                }
                                .frame(maxWidth: .infinity)
                            }
                            .frame(maxWidth: .infinity, maxHeight: .infinity)
                            
                        }
                }
                .aspectRatio(100/66.7, contentMode: .fit)
            }
            
            // Show Tags and Categories
            VStack(alignment: .leading, spacing: spacing) {
                Group {
                    Group {
                        TypeWriterView(wavShow.name.uppercased())
                            .wavBlack()
                        ScrollView(.horizontal, showsIndicators: true) {
                            HStack(spacing: 4) {
                                ForEach(categories) { category in
                                    TypeWriterView(category.name.stringByDecodingHTMLEntities.uppercased())
                                        .wavBlack(size: 14)
                                }
                                ForEach(tags) { tag in
                                    TypeWriterView(tag.name.stringByDecodingHTMLEntities.uppercased())
                                        .wavBlue(size: 14)
                                }
                            }
                        }
                    }
                    .frame(alignment: .leading)
                    Text(wavShow.dateFormatted.uppercased())
                        .padding(.vertical, 2)
                        .padding(.leading, colorScheme == .light ? 0 : 8)
                        .font(Font.custom("Helvetica Neue Medium", size: 12))
                }
            }
            .onAppear {
                self.loadCategories()
                self.loadTags()
            }
        }
    }
    func loadCategories() {
        let url = URL(string: "https://wearevarious.com/wp-json/wp/v2/categories?post=\(wavShow.id)&_fields=id,name")!
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
    func loadTags() {
        let url = URL(string: "https://wearevarious.com/wp-json/wp/v2/tags?post=\(wavShow.id)&_fields=id,name")!
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
                let tags = try JSONDecoder().decode(WAVTags.self, from: data)
                DispatchQueue.main.async {
                    self.tags = tags
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
        ArchiveItemView(wavShow: WAVShow.preview, playPauze: {})
            .environmentObject(DataController())
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white.opacity(0.15))
    }
}
