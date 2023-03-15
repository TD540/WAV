//
//  TESTView.swift
//  WAV
//
//  Created by Thomas on 02/12/2022.
//

import SwiftUI

struct WAVGlobe: View {
    @State var start = Date().timeIntervalSinceReferenceDate
    
    var body: some View {
        TimelineView(.animation) { timeline in
            canvas(timeline)
        }
        .scaledToFit()
    }
    
    func canvas(_ timeline: TimelineViewDefaultContext) -> some View {
        Canvas { context, size in
            
            // setup variables
            
            let maxSize: CGFloat = size.width > size.height ? size.height : size.width
            // example: 1000
            
            let edgeLine: CGFloat = maxSize / 50
            // example: 1000 / 50 = 20
            
            let waveLine: CGFloat = maxSize / 50
            // example: 1000 / 50 = 20
            
            let rippleLine: CGFloat = maxSize / 250
            // example: 1000 / 250 = 4
            
            let fitSize: CGFloat = maxSize - edgeLine
            // example: 1000 - 20 = 980
            
            let fitRect = CGRect(
                x: size.width / 2 - fitSize / 2,
                y: size.height / 2 - fitSize / 2,
                width: fitSize,
                height: fitSize
            )
            
            // draw globe edge
            let edge = Path(ellipseIn: fitRect)
            context.drawLayer { innerContext in
                innerContext.stroke(edge,
                                    with: .foreground,
                                    lineWidth: edgeLine
                )
            }
            
            let age = timeline.date.timeIntervalSinceReferenceDate - start
            
            // draw ripples
            let maxRippleSize = maxSize - edgeLine
            let amount = 7
            let rippleRange = 0...amount
            let rippleCount = CGFloat(rippleRange.count)
            let rippleLength: CGFloat = 0.32
            let rippleCycle = CGFloat(rippleCount * age * rippleLength).truncatingRemainder(dividingBy: rippleCount)
            let interval = maxSize / rippleCount
            let quantifier: CGFloat = rippleCycle / rippleCount
            let rippleSizes = rippleRange.map { maxRippleSize * (1.0/CGFloat(rippleRange.count) * CGFloat($0)) }
            context.drawLayer { innerContext in
                // draw left ripples
                for rippleSize in rippleSizes {
                    let rippleSize = rippleSize + interval * quantifier
                    innerContext.stroke(
                        Path(ellipseIn: CGRect(
                            x: edgeLine/2,
                            y: size.height / 2 - rippleSize / 2,
                            width: rippleSize,
                            height: rippleSize
                        )),
                        with: .foreground,
                        lineWidth: rippleLine
                    )
                }
                // draw right ripples
                for rippleSize in rippleSizes {
                    let rippleSize = rippleSize + interval * quantifier
                    innerContext.stroke(
                        Path(ellipseIn: CGRect(
                            x: maxSize - edgeLine/2 - rippleSize,
                            y: size.height / 2 - rippleSize / 2,
                            width: rippleSize,
                            height: rippleSize
                        )),
                        with: .foreground,
                        lineWidth: rippleLine
                    )
                }
            }
            
            // draw sound wave
            let waveCount: Int = 20
            let amplitude: CGFloat = 1
            var samples = [0.0]
            for _ in 0..<waveCount {
                samples.append(CGFloat.random(in: -amplitude...amplitude))
            }
            samples.append(0.0)
            context.drawLayer { innerContext in
                innerContext.stroke(
                    Path { path in
                        let yOffset = fitRect.height / 2
                        let stepWidth = fitRect.width / CGFloat(samples.count)
                        
                        path.move(to: CGPoint(x: 0, y: yOffset))
                        
                        for (index, sample) in samples.enumerated() {
                            let xPos = CGFloat(index) * stepWidth
                            let yPos = yOffset + (sample * yOffset)
                            path.addLine(to: CGPoint(x: xPos, y: yPos))
                        }
                    },
                    with: .foreground,
                    style: StrokeStyle(lineWidth: waveLine, lineJoin: .round)
                )
            }
        }
    }
}

struct WAVGlobe_Previews: PreviewProvider {
    static var previews: some View {
        WAVGlobe()
    }
}
