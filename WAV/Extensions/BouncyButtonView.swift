//
//  BouncyButton.swift
//  WAV
//

import SwiftUI

struct BouncyButtonView<Label: View>: View {
    var action: () -> Void
    var label: () -> Label
    @State private var scale: CGFloat = 1.0

    init(action: @escaping () -> Void, @ViewBuilder label: @escaping () -> Label) {
        self.action = action
        self.label = label
    }

    var body: some View {
        Button(action: {
            self.action()
            triggerBounce()
        }) {
            label()
        }
        .scaleEffect(scale)
        .buttonStyle(NoHighlightButtonStyle())
    }

    private func triggerBounce() {
        withAnimation(.interpolatingSpring(stiffness: 200, damping: 10)) {
            scale = 0.75
        }
        withAnimation(.interpolatingSpring(stiffness: 400, damping: 10).delay(0.03)) {
            scale = 1
        }
    }
}

struct NoHighlightButtonStyle: ButtonStyle {
    func makeBody(configuration: Self.Configuration) -> some View {
        configuration.label
    }
}

#Preview {
    BouncyButtonView { } label: {
        Text("Hello")
            .foregroundStyle(.white)
            .padding()
            .background(.blue)
            .clipShape(RoundedRectangle(cornerRadius: 5.0))
    }

}
