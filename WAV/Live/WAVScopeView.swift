//
//  WAVScopeView.swift
//

import SwiftUI

struct WAVScopeView: View {
    var start = Date()
    @Binding var isPlaying: Bool
    
    var body: some View {
        if isPlaying {
            TimelineView(.periodic(from: .now, by: 0.2)) { timeline in
                canvas(timeline)
            }
        } else {
            EmptyView()
        }
    }
    
    func canvas(_ timeline: TimelineViewDefaultContext) -> some View {
        Canvas { context, size in

            _ = timeline.date

            // setup variables
            
            let maxSize: CGFloat = size.width > size.height ? size.height : size.width
            // example: 1000
            
            let edgeLine: CGFloat = maxSize / 50
            // example: 1000 / 50 = 20
            
            let waveLine: CGFloat = maxSize / 60
            // example: 1000 / 50 = 20
            
            let fitSize: CGFloat = maxSize - edgeLine
            // example: 1000 - 20 = 980
            
            let fitRect = CGRect(
                x: size.width / 2 - fitSize / 2,
                y: size.height / 2 - fitSize / 2,
                width: fitSize,
                height: fitSize
            )

            // scope wave
            let waveCount: Int = 24
            let amplitude: CGFloat = 0.2
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
        }
    }
}

struct WAVGlobeScope_Previews: PreviewProvider {
    static var previews: some View {
        WAVScopeView(isPlaying: .constant(true))
    }
}
