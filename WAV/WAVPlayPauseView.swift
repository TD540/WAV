//
//  WAVPlayPauseView.swift
//

import SwiftUI

struct WAVPlayPauseView: View {
    var color = Color.accentColor
    @Binding var isPlaying: Bool
    @State private var grid = Grid()
    private let pauseGrid = Grid(
        lines: [
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
    )
    private let playGrid = Grid(
        lines: [
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
    )
    var body: some View {
        Canvas { context, size in
            var path = Path()
            let size = size.width / Double(12)
            for line in 0 ..< grid.lines.count {
                for pixel in 0 ..< grid.lines[line].count {
                    if grid.lines[line][pixel] == 1 {
                        let startX = size * Double(pixel)
                        let startY = size * Double(line)
                        let rect = CGRect(x: startX, y: startY, width: size, height: size)
                        path.addRect(rect)
                    }

                }
            }
            context.fill(path, with: .color(color))
        }
        .aspectRatio(6/9, contentMode: .fit)
        .onAppear {
            grid = isPlaying ? pauseGrid : playGrid
        }
        .onChange(of: isPlaying, perform: { _ in
            let transition = pixelGridTransition()
            var count = 0
            Timer.scheduledTimer(withTimeInterval: 0.015, repeats: true) { timer in
                grid = Grid(lines: transition.grids[count].lines)
                count += 1
                if count == transition.grids.count {
                    timer.invalidate()
                }
            }
        })
    }
    private func randomGrid(from first: Grid, to second: Grid) ->  Grid {
        var randomGrid = Grid()
        var index = 0
        for line in first.lines {
            var pIndex = 0
            var nextLine = [Int]()
            for pixel in line {
                let newPixel = second.lines[index][pIndex]
                if pixel == newPixel {
                    nextLine.append(pixel)
                } else {
                    let odds = Int.random(in: 0...100)
                    nextLine.append(
                        odds < 10 ? newPixel : pixel
                    )
                }
                pIndex += 1
            }
            randomGrid.lines.append(nextLine)
            index += 1
        }
        return randomGrid
    }
    private func pixelGridTransition() -> Transition {
        let first = isPlaying ? playGrid : pauseGrid
        let last = isPlaying ? pauseGrid : playGrid
        let steps = 10
        var transition = Transition()
        transition.grids.append(first)
        for _ in 0...steps {
            transition.grids.append(
                randomGrid(from: transition.grids.last!, to: last)
            )
        }
        transition.grids.append(last)
        return transition
    }
    private struct Grid {
        var lines = [[Int]]()
    }
    private struct Transition {
        var grids = [Grid]()
    }
}

struct PixelButton_Previews: PreviewProvider {
    static var previews: some View {
        PixelButtonTest()
    }
}

struct PixelButtonTest: View {
    @State var isPlaying = false
    var body: some View {
        WAVPlayPauseView(isPlaying: $isPlaying)
            .onAppear {
                isPlaying = true
            }
            .onTapGesture {
                isPlaying.toggle()
            }
    }
}
