//
//  WAVShowTags.swift
//  WAV
//

import SwiftUI
import OSLog

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
                    WAVArchiveView(tag: tag)
                } label: {
                    Text(tag.name.stringByDecodingHTMLEntities.uppercased())
                        .lineLimit(1)
                        .wavBlue(size: 13, vPadding: 4)
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
                Logger.check.error("WAV: Error fetching tags for show \(wavShow.id): \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                Logger.check.error("WAV: Error: no data received")
                return
            }
            do {
                let tags = try JSONDecoder().decode(WAVTags.self, from: data)
                DispatchQueue.main.async {
                    self.tags = tags
                }
            } catch let error {
                Logger.check.error("WAV: Error decoding JSON: \(error.localizedDescription)")
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
