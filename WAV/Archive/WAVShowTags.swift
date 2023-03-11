//
//  WAVShowTags.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI

struct WAVTag: Codable, Identifiable, Hashable {
    var id: Int
    let name: String
}

typealias WAVTags = [WAVTag]

struct WAVShowTags: View {
    var wavShow: WAVShow
    var hideTag: WAVTag?
    @State var tags: WAVTags = []

    var body: some View {
        HStack(spacing: 4) {
            ForEach(tags) { tag in
                NavigationLink {
                    InfiniteView(tag: tag)
                } label: {
                    Text(tag.name.stringByDecodingHTMLEntities.uppercased())
                        .lineLimit(1)
                        .wavBlue(size: 12, vPadding: 12)
                }
                .disabled(tag == hideTag)
                .fadeIn()
            }
        }
        .onAppear(perform: loadTags)
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

struct WAVShowTags_Previews: PreviewProvider {
    static var previews: some View {
        WAVShowTags(wavShow: WAVShow.preview)
            .environmentObject(DataController())
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white.opacity(0.15))
    }
}
