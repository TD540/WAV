//
//  PixelButton.swift
//  WAV
//
//  Created by Thomas on 17/08/2022.
//

import SwiftUI

struct PixelButton: View {
    // @Binding
    @State
    var isPlaying: Bool = false
    @State var lastUpdate = Date()
    var color = Color.accentColor
    let pauseGrid = [
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 0, 0, 1, 1, 1, 1, 1]
    ]
    let playGrid = [
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 1],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 1, 1, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 1, 1, 1, 1, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 1, 1, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0],
        [1, 1, 0, 0, 0, 0, 0, 0, 0, 0, 0, 0]
    ]
    func nextGrid(firstGrid: [[Int]], secondGrid: [[Int]]) ->  [[Int]] {
        var nextGrid = [[Int]]()
        var index = 0
        for line in firstGrid {
            var pIndex = 0
            var nextLine = [Int]()
            for pixel in line {
                let newPixel = secondGrid[index][pIndex]
                if pixel == newPixel {
                    nextLine.append(pixel)
                } else {
                    let odds = Int.random(in: 0...100)
                    nextLine.append(
                        odds < 50 ? newPixel : pixel
                    )
                }
                pIndex += 1
            }
            nextGrid.append(nextLine)
            index += 1
        }
        return nextGrid
    }
    func randomTransitionGrids() -> [[[Int]]] {
        let randomGrid1 = nextGrid(firstGrid: playGrid, secondGrid: pauseGrid)
        let randomGrid2 = nextGrid(firstGrid: randomGrid1, secondGrid: pauseGrid)
        let randomGrid3 = nextGrid(firstGrid: randomGrid2, secondGrid: pauseGrid)
        return [playGrid, randomGrid1, randomGrid2, randomGrid3, pauseGrid]
    }
    func pixelButtonView(for date: Date) -> some View {
        if date > lastUpdate  {
            Date.now
        }
        lastUpdate = date
        return VStack(spacing: 0) {
            ForEach(playGrid, id:\.self) { line in
                HStack(spacing: 0) {
                    ForEach(line, id:\.self) { pixel in
                        Rectangle()
                            .fill(pixel == 1 ? color : .clear)
                }
                    .aspectRatio(1, contentMode: .fit)
                }
            }
        }
    }
    var body: some View {
        VStack {
            Text(isPlaying ? "playing" : "not playing")

            TimelineView(.animation) { context in
                pixelButtonView(for: context.date)
            }
            .onTapGesture {
                isPlaying.toggle()
            }
        }
    }
}

struct PixelButton_Previews: PreviewProvider {
    static var previews: some View {
        PixelButton(isPlaying: true)
    }
}
