//
//  TryoutView.swift
//  WAV
//
//  Created by thomas on 15/03/2023.
//

import SwiftUI

struct TryoutView: View {
    var body: some View {
        WaveformView(samples: [0, -0.2, 0.3, -0.4, 0.5, -0.6, 0.2, -0.2, 0.5, -0.7, 0])
    }
}

struct TryoutView_Previews: PreviewProvider {
    static var previews: some View {
        TryoutView()
    }
}

struct WaveformView: View {
    let samples: [CGFloat]
    var body: some View {
        Canvas {context, size in
            context.stroke(
                Path { path in
                    let yOffset = size.height / 2
                    let stepWidth = size.width / CGFloat(samples.count)
                    
                    path.move(to: CGPoint(x: 0, y: yOffset))
                    
                    for (index, sample) in samples.enumerated() {
                        let xPos = CGFloat(index) * stepWidth
                        let yPos = yOffset + (sample * yOffset)
                        path.addLine(to: CGPoint(x: xPos, y: yPos))
                    }
                },
                with: .foreground,
                style: StrokeStyle(lineWidth: 10, lineJoin: .round)
            )
        }
    }
}

