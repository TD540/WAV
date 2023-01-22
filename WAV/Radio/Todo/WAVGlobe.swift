//
//  TESTView.swift
//  WAV
//
//  Created by Thomas on 02/12/2022.
//

import SwiftUI

struct WAVGlobe: View {
    @State private var count: CGFloat = 0

    var body: some View {
        ZStack {
            Image("WAVGlobe").resizable().aspectRatio(contentMode: .fit)

            TimelineView(.animation) { timeline in
                Canvas { context, size in

                    // maximum size I can fit in
                    let fitSize = size.width > size.height ? size.height : size.width

                    let edgeLine: CGFloat = fitSize / 55
                    let waveLine: CGFloat = fitSize / 200

                    let maxSize = fitSize - edgeLine

                    let fitRect = CGRect(
                        x: size.width / 2 - maxSize / 2,
                        y: size.height / 2 - maxSize / 2,
                        width: maxSize,
                        height: maxSize
                    )


                    let wavesAmount = 7
                    let tweenSize = maxSize / CGFloat(wavesAmount)

                    

                    if count < maxSize {
                        count += 1
                    } else {
                        count = 0
                    }



                    context.drawLayer { innerContext in
                        let edge = Path(ellipseIn: fitRect)
                        innerContext.stroke(edge, with: .foreground, style: StrokeStyle(lineWidth: edgeLine))


                        let wave1Size: CGFloat = count
                        let wave1Rect = CGRect(
                            x: 0,
                            y: size.height / 2 - wave1Size / 2,
                            width: wave1Size,
                            height: wave1Size
                        )
                        let wave1 = Path(ellipseIn: wave1Rect)
                        innerContext.stroke(wave1, with: .foreground, style: StrokeStyle(lineWidth: waveLine))


                    }

                    // update every frame
//                     _ = timeline.date
                }
            }
            .border(.blue) //dev
            .foregroundColor(.accentColor) //dev
        }

    }
}

struct WAVGlobe_Previews: PreviewProvider {
    static var previews: some View {
        WAVGlobe()
    }
}
