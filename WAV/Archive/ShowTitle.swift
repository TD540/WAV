//
//  ShowTitle.swift
//
//  Created by Thomas on 23/12/2022.
//

import SwiftUI

struct ShowTitle: View {
    var string = "Lorem ipsum dolor sit amet, consectetur adipiscing elit."

    var editedString: String {
        let replacements: [String: String] = [
            :
            // "w/ ": "with "
        ]
        var updatedParagraph = string
        for (oldString, newString) in replacements {
            updatedParagraph = updatedParagraph.replacingOccurrences(of: oldString, with: newString, options: .caseInsensitive)
            print(oldString)
        }
        return updatedParagraph.uppercased()
    }

    var lines: [String] {
        let words = string.components(separatedBy: " ")
        let lineMax = 3
        var arrayOfStrings: [String] = []
        for index in stride(from: 0, to: words.count, by: lineMax) {
            var next = words[index..<min(index + lineMax, words.count)].joined(separator: " ")
            next = next.trimmingCharacters(in: .whitespacesAndNewlines)
            arrayOfStrings.append(next)
        }
        return arrayOfStrings
    }

    var body: some View {
        VStack(alignment: .leading, spacing: 2) {
            ForEach(lines, id: \.self) { string in
                Text(string.uppercased())
                    .foregroundColor(.white)
                    .padding(8)
                    .background(.black)
                    .lineSpacing(8)
                    .font(.custom("pixelmix", size: 16))
            }
        }
    }
}

struct ShowTitle_Previews: PreviewProvider {
    static var previews: some View {
        ShowTitle()
    }
}
