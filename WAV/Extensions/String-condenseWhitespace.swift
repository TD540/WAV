//
//  String-condenseWhitespace.swift
//
//  https://stackoverflow.com/a/33058765/147163
//

extension String {
    func condenseWhitespace() -> String {
        let components = self.components(separatedBy: .whitespacesAndNewlines)
        return components.filter { !$0.isEmpty }.joined(separator: " ")
    }
}
