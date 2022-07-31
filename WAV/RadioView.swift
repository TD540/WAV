//
//  Radio.swift
//  WAV
//
//  Created by Thomas on 22/07/2022.
//

// todo: enable music in silent mode
// todo: show title in ios control center
// todo: refresh title every 10 seconds
// todo: animate button's pixels (with Canvas?)
// todo: should I use player.pause() or stop player with player.replaceCurrentItem(with: nil) ?

import SwiftUI
import AVKit

struct RadioView: View {
    let url = URL(string: "https://icecast.wearevarious.com/live.mp3")!
    @State var title: String?
    @State var player = AVPlayer(playerItem: nil)
    @State var isPlaying = false

    var body: some View {
        VStack {
            Button {
                if isPlaying {
                    stop()
                } else {
                    play()
                }
            } label: {
                Image(isPlaying ? "pause" : "play")
                    .resizable()
                    .aspectRatio(contentMode: .fit)
                    .padding()
            }
            if (title != nil) {
                Text(title!)
                    .font(Font.custom("pixelmix", size: 30))
                    .lineSpacing(15)
                    .padding()
            }
        }
        .task() {
            title = await RadioState.title()
        }
    }
    func play() {
        player.replaceCurrentItem(with: AVPlayerItem(url: url))
        player.play()
        isPlaying = true
    }
    func stop() {
        player.replaceCurrentItem(with: nil)
        isPlaying = false
    }
}

struct RadioState: Decodable {
    static let url = URL(string: "https://icecast.wearevarious.com/status-json.xsl")
    static func title() async -> String? {
        guard let url = url else { return nil }
        do {
            let (data, _) = try await URLSession.shared.data(from: url)
            if let naughtyJSON = String(data: data, encoding: .utf8) {
                let fixedJSON = naughtyJSON.replacingOccurrences(of: ":-,", with: ":\"\",")
                let fixedData = fixedJSON.data(using: .utf8)!
                do {
                    let decodedIcestats = try JSONDecoder().decode(RadioState.self, from: fixedData)
                    return(decodedIcestats.icestats.source.title)
                } catch {
                    print("oops: \(String(describing: error))")
                }
            }
        } catch {
            print("URLSession failed \(String(describing: error))")
        }
        return nil
    }

    let icestats: Icestats
    struct Icestats: Decodable {
        let source: Source
        struct Source: Decodable {
            let title: String
        }
    }
}

struct RadioView_Previews: PreviewProvider {
    static var previews: some View {
        RadioView(title: "preview title")
    }
}
