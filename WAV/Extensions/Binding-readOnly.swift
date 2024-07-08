//
//  Binding-readOnly.swift
//  WAV
//

import SwiftUI

extension Binding {
    init(get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }
}
