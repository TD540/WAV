//
//  RotatingButtonStyle.swift
//
//  Created by Thomas on 02/05/2021.
//  based on pausable animation sollution:
//  https://stackoverflow.com/a/64318967/147163
//

import SwiftUI

struct RotatingButtonStyle: ButtonStyle {
    var isRotating: Bool

    @State private var desiredAngle: CGFloat = 0.0
    @State private var currentAngle: CGFloat = 0.0

    var foreverAnimation: Animation {
        Animation.linear(duration: 2)
            .repeatForever(autoreverses: false)
    }
    var stoppingAnimation = Animation.linear(duration: 0)

    func makeBody(configuration: Configuration) -> some View {
        VStack {
            Text("currentAngle: \(currentAngle)")
            configuration.label
                .modifier(
                    PausableRotationEffect(
                        desiredAngle: desiredAngle,
                        currentAngle: $currentAngle
                    )
                )
                .onAppear {
                    if isRotating {
                        withAnimation(foreverAnimation) {
                            let startAngle = currentAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
                            let angleDelta = CGFloat.pi * 2
                            desiredAngle = startAngle + angleDelta
                        }
                    }
                }
                .onChange(of: isRotating, perform: { isRotatingChanged in
                    if isRotatingChanged == true {
                        withAnimation(foreverAnimation) {
                            let startAngle = currentAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
                            let angleDelta = CGFloat.pi * 2
                            desiredAngle = startAngle + angleDelta
                        }
                    } else {
                        withAnimation(stoppingAnimation) {
                            let startAngle = currentAngle.truncatingRemainder(dividingBy: CGFloat.pi * 2)
                            desiredAngle = startAngle
                        }
                    }
                })
        }

    }

    struct PausableRotationEffect: GeometryEffect {
        @Binding var currentAngle: CGFloat
        private var currentAngleValue: CGFloat = 0.0
        var animatableData: CGFloat {
            get { currentAngleValue }
            set { currentAngleValue = newValue }
        }
        init(desiredAngle: CGFloat, currentAngle: Binding<CGFloat>) {
            currentAngleValue = desiredAngle
            _currentAngle = currentAngle
        }
        func effectValue(size: CGSize) -> ProjectionTransform {
            DispatchQueue.main.async {
                currentAngle = currentAngleValue
            }
            let xOffset = size.width / 2
            let yOffset = size.height / 2
            let transform =
            CGAffineTransform(translationX: xOffset, y: yOffset)
                .rotated(by: currentAngleValue)
                .translatedBy(x: -xOffset, y: -yOffset)
            return ProjectionTransform(transform)
        }
    }
}

struct RotatingButtonStyle_Previews: PreviewProvider {
    static var previews: some View {
         PreviewRotatingButtonStyle()
    }
    struct PreviewRotatingButtonStyle: View {
        @State private var isPlaying: Bool = true
        var body: some View {
            TabView {
                Button {
                    isPlaying.toggle()
                } label: {
                    Text("💿")
                        .font(.system(size: 200))
                }
                .buttonStyle(RotatingButtonStyle(isRotating: isPlaying))
                .tabItem {
                    Label("RotatingButtonStyle", systemImage: "opticaldisc")
                }
                Text("Tapped away, now tap back")
                    .tabItem {
                        Label("Tap me", systemImage: "ellipsis")
                    }
            }
        }
    }
}
