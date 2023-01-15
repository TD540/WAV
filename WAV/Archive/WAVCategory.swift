//
//  WAVCategory.swift
//  WAV
//
//  Created by Thomas on 14/01/2023.
//

import Foundation

struct WAVCategory: Codable, Identifiable, Hashable {
    var id: String {
        name
    }
    let name: String
}
typealias WAVCategories = [WAVCategory]
