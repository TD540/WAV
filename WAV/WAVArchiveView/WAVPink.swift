//
//  WAVPink.swift
//  WAV
//

import SwiftUI

struct WAVPinkModifier: ViewModifier {
    let size: CGFloat
    let padding: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.vertical, padding)
            .padding(.horizontal, 8)
            .foregroundColor(.black)
            .background(Color("WAVPink"))
            .font(.custom("pixelmix", size: size))
            .lineSpacing(4)
    }
}
extension View {
    func wavPink(size: CGFloat = 14, vPadding: CGFloat = 8) -> some View {
        self.modifier(WAVPinkModifier(size: size, padding: vPadding))
    }
}

struct WAVPink_Previews: PreviewProvider {
    static var previews: some View {
        Text(".wavPink(size: 20)")
            .wavPink(size: 20)
    }
}
