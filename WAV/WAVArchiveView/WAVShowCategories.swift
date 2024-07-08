//
//  WAVShowCategories.swift
//  WAV
//

import SwiftUI
import OSLog

struct WAVCategory: Codable, Identifiable, Hashable {
    var id: Int
    let name: String
}

typealias WAVCategories = [WAVCategory]

struct WAVShowCategories: View {
    var wavShow: WAVShow
    var hideCategory: WAVCategory?
    @State var categories: WAVCategories = []

    var body: some View {
        HStack(spacing: 4) {
            ForEach(categories) { category in
                NavigationLink {
                    WAVArchiveView(category: category)
                } label: {
                    Text(category.name.stringByDecodingHTMLEntities.uppercased())
                        .lineLimit(1)
                        .wavBlack(size: 14, vPadding: 4)
                }
                .fadeIn()
            }
        }
        .onAppear(perform: loadCategories)

    }
    func loadCategories() {
        let url = URL(string: "https://wearevarious.com/wp-json/wp/v2/categories?post=\(wavShow.id)&_fields=id,name")!
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            if let error = error {
                Logger.check.error("WAV: Error fetching categories for show \(wavShow.id): \(error.localizedDescription)")
                return
            }
            guard let data = data else {
                Logger.check.error("WAV: Error: no data received")
                return
            }
            do {
                var categories = try JSONDecoder().decode(WAVCategories.self, from: data)
                if let hideCategory {
                    categories.removeAll {
                        $0.id == hideCategory.id
                    }
                }
                DispatchQueue.main.async {
                    self.categories = categories
                }
            } catch let error {
                Logger.check.error("WAV: Error decoding JSON: \(error.localizedDescription)")
            }
        }
        task.resume()
    }
}

struct WAVShowCategories_Previews: PreviewProvider {
    static var previews: some View {
        WAVShowCategories(wavShow: WAVShow.preview)
            .environmentObject(DataController())
            .padding()
            .frame(maxWidth: .infinity, maxHeight: .infinity)
            .background(.white.opacity(0.15))
    }
}
