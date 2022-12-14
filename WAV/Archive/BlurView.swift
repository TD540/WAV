//
//  BlurView.swift
//  WeAreVarious
//
//  https://blog.devgenius.io/blur-effect-with-vibrancy-in-swiftui-bada837fdf50
//

import SwiftUI
import UIKit

struct BlurView: UIViewRepresentable {
    let style: UIBlurEffect.Style

    init(style: UIBlurEffect.Style = .systemMaterial) {
        self.style = style
    }

    func makeUIView(context: Context) -> UIVisualEffectView {
        return UIVisualEffectView(effect: UIBlurEffect(style: self.style))
    }

    func updateUIView(_ uiView: UIVisualEffectView, context: Context) {
        uiView.effect = UIBlurEffect(style: self.style)
    }
}
