//
//  Binding-readOnly.swift
//  WAV
//
//  Created by thomas on 11/03/2023.
//

import SwiftUI

extension Binding {
    init(get: @escaping () -> Value) {
        self.init(get: get, set: { _ in })
    }
}
