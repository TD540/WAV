//
//  WAVShowCategories.swift
//  WAV
//
//  Created by Thomas on 27/12/2022.
//

import SwiftUI

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
                    InfiniteView(category: category)
                } label: {
                    Text(category.name.stringByDecodingHTMLEntities.uppercased())
                        .lineLimit(1)
                        .wavBlack(size: 12, vPadding: 12)
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
                print("Error: \(error)")
                return
            }
            guard let data = data else {
                print("Error: no data received")
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
                print("Error decoding JSON: \(error)")
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
