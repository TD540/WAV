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

            let edgeLine: CGFloat = maxSize / 50 // todo: toch beter 55?
            // example: 1000 / 50 = 20

            let waveLine: CGFloat = maxSize / 250
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
            context.drawLayer { innerContext in
                let edge = Path(ellipseIn: fitRect)
                innerContext.stroke(edge,
                                    with: .foreground,
                                    style: StrokeStyle(lineWidth: edgeLine)
                )
            }

            // context.draw(Text("\(waveCycle)"), at: CGPoint(x: 160, y: 20))

            // draw waves
            context.drawLayer { innerContext in
                let maxWaveSize = maxSize - edgeLine
                let amount = 7
                let waveRange = 0...amount
                let waveCount = CGFloat(waveRange.count)
                let waveLength: CGFloat = 0.32
                let age = timeline.date.timeIntervalSinceReferenceDate - start
                let waveCycle = CGFloat(waveCount * age * waveLength).truncatingRemainder(dividingBy: waveCount)
                let interval = maxSize / waveCount
                let quantifier: CGFloat = waveCycle / waveCount
                let waveSizes = waveRange.map { maxWaveSize * (1.0/CGFloat(waveRange.count) * CGFloat($0)) }
                // draw left waves
                for waveSize in waveSizes {
                    let waveSize = waveSize + interval * quantifier
                    let waveRect = CGRect(
                        x: edgeLine/2,
                        y: size.height / 2 - waveSize / 2,
                        width: waveSize,
                        height: waveSize
                    )
                    let wave = Path(ellipseIn: waveRect)
                    innerContext.stroke(wave, with: .foreground, style: StrokeStyle(lineWidth: waveLine))
                }
                // draw right waves
                for waveSize in waveSizes {
                    let waveSize = waveSize + interval * quantifier
                    let waveRect = CGRect(
                        x: maxSize - edgeLine/2 - waveSize,
                        y: size.height / 2 - waveSize / 2,
                        width: waveSize,
                        height: waveSize
                    )
                    let wave = Path(ellipseIn: waveRect)
                    innerContext.stroke(wave, with: .foreground, style: StrokeStyle(lineWidth: waveLine))
                }
            }



        }
    }

}

struct WAVGlobe_Previews: PreviewProvider {
    static var previews: some View {
        WAVGlobe()
    }
}
