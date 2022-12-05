//
//  WAVGlobeAnimation.swift
//  WAV
//
//  Created by Thomas on 25/11/2022.
//

import SwiftUI

struct WAVGlobeAnimation: View {
    let bol = StrokeStyle(lineWidth: 10)
    let wave = StrokeStyle(lineWidth: 3)
    var body: some View {
        ZStack {
            Circle()
                .mask {
                    ZStack {
                        Group {
                            FlatWave(delay: 0, anchor: .leading)
                            FlatWave(delay: 1, anchor: .leading)
                            FlatWave(delay: 2, anchor: .leading)
                            FlatWave(delay: 3, anchor: .leading)
                            FlatWave(delay: 4, anchor: .leading)
                            FlatWave(delay: 5, anchor: .leading)
                            FlatWave(delay: 6, anchor: .leading)
                        }
//                        Group {
//                            FlatWave(delay: 0, anchor: .trailing)
//                            FlatWave(delay: 1, anchor: .trailing)
//                            FlatWave(delay: 2, anchor: .trailing)
//                            FlatWave(delay: 3, anchor: .trailing)
//                            FlatWave(delay: 4, anchor: .trailing)
//                            FlatWave(delay: 5, anchor: .trailing)
//                            FlatWave(delay: 6, anchor: .trailing)
//                        }
                    }
                }
                .overlay {
                    Circle()
                        .strokeBorder(style: bol)
                }
        }
        .foregroundColor(.accentColor)
        .aspectRatio(contentMode: .fit)
    }
}

struct WAVGlobeAnimation_Previews: PreviewProvider {
    static var previews: some View {
        WAVGlobeAnimation()
    }
}

struct FlatWave: View {
    @State var animationAmount: CGFloat = 0
    let bol = StrokeStyle(lineWidth: 10)
    var delay: Double = 2
    var anchor: UnitPoint
    var easeOutForever: Animation {
        .easeOut(duration: 4)
        .repeatForever(autoreverses: false)
    }
    var body: some View {
        Circle()
            .stroke(Color.accentColor, lineWidth: 10)
            .scaleEffect(
                x: animationAmount,
                y: animationAmount,
                anchor: anchor
            )
            .onAppear {
              // This is the animation that will run forever, with a delay of 2 seconds before it starts.
              // After the first animation cycle, the delay is set to 0 seconds.
              withAnimation(
                Animation.easeOut(duration: 7)
                  .repeatForever(autoreverses: false)
                  .delay(delay)
              ) {
                self.animationAmount = 1
              }
            }
    }
}
