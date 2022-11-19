//
//  LPView.swift
//  WeAreVarious
//
//  Created by Thomas on 21/05/2021.
//

import SwiftUI

struct RecordView: View {
    let pictureURL: URL?

    var body: some View {
        GeometryReader { geometryProxy in
            ZStack {
                Image("LP")
                    .resizable()
                AsyncImage(url: pictureURL) { image in
                    image.resizable()
                } placeholder: {
                    Color.black
                }
                .frame(
                    width: geometryProxy.size.width/2.7,
                    height: geometryProxy.size.height/2.7
                )
                .clipShape(Circle())
            }
            .frame(width: geometryProxy.size.width, height: geometryProxy.size.height)
        }
        .aspectRatio(contentMode: .fill)
    }
}

struct RecordView_Previews: PreviewProvider {
    static var previews: some View {
        RecordView(pictureURL: nil)
    }
}
