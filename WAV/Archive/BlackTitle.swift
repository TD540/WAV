//
//  BlackTitle.swift
//
//  Created by Thomas on 23/12/2022.
//

import SwiftUI

struct BlackTitle: View {
    var string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

    var lines: [String] {
        let words = string
            .condenseWhitespace()
            .components(separatedBy: " ")
        let wordMax = 6
        var arrayOfStrings: [String] = []
        for index in stride(from: 0, to: words.count, by: wordMax) {
            let next = words[index..<min(index + wordMax, words.count)]
                .joined(separator: " ")
            arrayOfStrings.append(next)
        }
        return arrayOfStrings
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(lines, id: \.self) { string in
                Text(string.uppercased())
                    .foregroundColor(.white)
                    .padding(6)
                    .background(.black)
                    .lineSpacing(6)
                    .font(.custom("pixelmix", size: 12))
            }
        }
    }
}

struct BlackTitle_Previews: PreviewProvider {
    static var previews: some View {
        BlackTitle()
    }
}
