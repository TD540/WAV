//
//  TESTView.swift
//  WAV
//
//  Created by Thomas on 02/12/2022.
//

import SwiftUI

class DrawingModel: ObservableObject {
    var angle = 0.0
}

struct TESTView: View {
    @StateObject private var model = DrawingModel()

    var body: some View {
        ZStack {
            Image("WAVIcon").resizable().aspectRatio(contentMode: .fit)
            TimelineView(.animation) { timeline in
                Canvas { context, size in

                    let fitSize = size.width > size.height ? size.height : size.width

                    let edgeLineWidth: CGFloat = fitSize/45

                    let maxSize = CGSize(width: fitSize-edgeLineWidth, height: fitSize-edgeLineWidth)

                    let fitRect = CGRect(x: size.width/2-maxSize.width/2, y: size.height/2-maxSize.height/2, width: maxSize.width, height: maxSize.height)

                    let circle1 = Path(ellipseIn: fitRect)

                    context.stroke(circle1, with: .foreground, style: StrokeStyle(lineWidth: edgeLineWidth))

                    print("UPDATE \(timeline.date)")
                    // _ = timeline.date // make it update at every frame !!
                }
            }
            .border(.blue) //dev
            .padding(30) //dev
            .foregroundColor(.red) //dev
            .aspectRatio(0.5, contentMode: .fit) //dev
        }

    }
}

struct TESTView_Previews: PreviewProvider {
    static var previews: some View {
        TESTView()
    }
}
