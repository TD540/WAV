//
//  WAVGlobeScope.swift
//  WAV
//
//  Created by Thomas on 21/03/2023.
//

import SwiftUI

struct WAVGlobeScope: View {
    let start = Date()
    @Binding var isPlaying: Bool
    
    var body: some View {
        VStack {
            TimelineView(.periodic(from: .now, by: 0.1)) { timeline in
                canvas(timeline)
            }
            .scaledToFit()
        }
    }
    
    func canvas(_ timeline: TimelineViewDefaultContext) -> some View {
        Canvas { context, size in

            // setup variables
            
            let maxSize: CGFloat = size.width > size.height ? size.height : size.width
            // example: 1000
            
            let edgeLine: CGFloat = maxSize / 50
            // example: 1000 / 50 = 20
            
            let waveLine: CGFloat = maxSize / 80
            // example: 1000 / 50 = 20

            
            let fitSize: CGFloat = maxSize - edgeLine
            // example: 1000 - 20 = 980
            
            let fitRect = CGRect(
                x: size.width / 2 - fitSize / 2,
                y: size.height / 2 - fitSize / 2,
                width: fitSize,
                height: fitSize
            )

            if isPlaying {
            // scope wave
            let waveCount: Int = 18
            let amplitude: CGFloat = 0.5
            var samples = [0.0]
            for _ in 0..<waveCount {
                samples.append(CGFloat.random(in: -amplitude...amplitude))
            }
            samples.append(0.0)
            context.drawLayer { innerContext in
                innerContext.stroke(
                    Path { path in
                        let yOffset = fitRect.height / 2
                        let stepWidth = fitRect.width / CGFloat(samples.count-1)

                        path.move(to: CGPoint(x: 0, y: yOffset))

                        for (index, sample) in samples.enumerated() {
                            let xPos = CGFloat(index) * stepWidth
                            let yPos = yOffset + (sample * yOffset)
                            path.addLine(to: CGPoint(x: xPos, y: yPos))
                        }
                    },
                    with: .foreground,
                    style: StrokeStyle(lineWidth: waveLine, lineCap: .round, lineJoin: .round)
                )
            }
            } else {
                context.stroke (
                    Path { path in
                        path.move(to: CGPoint(x: 0, y: fitRect.height / 2 + 4))
                        path.addLine(to: CGPoint(x: fitRect.width, y: fitRect.height / 2 + 4))
                    },
                    with: .foreground,
                    style: StrokeStyle(lineWidth: waveLine, lineCap: .round)
                )
            }
        }
    }
}

struct WAVGlobeScope_Previews: PreviewProvider {
    static var previews: some View {
        WAVGlobeScope(isPlaying: .constant(true))
    }
}
