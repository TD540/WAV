//
//  TypeWriterView.swift
//  WAV
//
//  https://betterprogramming.pub/typewriter-effect-in-swiftui-ba81db10b570
//

import SwiftUI

struct TypeWriterView: View {
    var finalText: String = "Hello, World!"
    @State private var text: String = ""

    init(_ finalText: String) {
        self.finalText = finalText
    }

    var body: some View {
        Text(text)
            .onAppear {
                DispatchQueue.main.asyncAfter(deadline: .now() + 0.05) {
                    typeWriter()
                }
            }
    }
    func typeWriter(at position: Int = 0) {
        if position == 0 {
            text = ""
        }
        if position < finalText.count {
            DispatchQueue.main.asyncAfter(deadline: .now() + 0.02) {
                text.append(finalText[position])
                typeWriter(at: position + 1)
            }
        }
    }
}

struct TypeWriterView_Previews: PreviewProvider {
    static var previews: some View {
        TypeWriterView("hello there")
    }
}

extension String {
    subscript(offset: Int) -> Character {
        self[index(startIndex, offsetBy: offset)]
    }
}
