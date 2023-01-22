//
//  WAVPink.swift
//  WAV
//
//  Created by Thomas on 12/01/2023.
//

import SwiftUI

struct WAVPinkModifier: ViewModifier {
    let size: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(8)
            .foregroundColor(.white)
            .background(Color("WAVPink"))
            .font(.custom("pixelmix", size: size))
            .lineSpacing(4)
    }
}
extension View {
    func wavPink(size: CGFloat = 14) -> some View {
        self.modifier(WAVPinkModifier(size: size))
    }
}

struct WAVPink_Previews: PreviewProvider {
    static var previews: some View {
        Text(".wavPink(size: 20)")
            .wavPink(size: 20)
    }
}
