//
//  WAVBlack.swift
//  WAV
//

import SwiftUI

struct WAVBlackModifier: ViewModifier {
    let size: CGFloat
    let padding: CGFloat
    func body(content: Content) -> some View {
        content
            .padding(.vertical, padding)
            .padding(.horizontal, 4)
            .foregroundColor(.white)
            .background(.black)
            .font(.custom("pixelmix", size: size))
    }
}
extension View {
    func wavBlack(size: CGFloat = 20, vPadding: CGFloat = 8) -> some View {
        self.modifier(WAVBlackModifier(size: size, padding: vPadding))
    }
}

struct WAVBlack_Previews: PreviewProvider {
    static var previews: some View {
        Text(".wavBlack(size: 20)")
            .wavBlack()
    }
}
