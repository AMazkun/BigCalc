//
//  etc.swift
//  Max Calc
//
//  Created by Anatoly Mazkun on 29.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation

extension String {
    var ajastInput: String {

        let x = self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")
        if x == "" || x == "-" || x == "." || x == "0E0" {return "0"}
        return  x
    }
}

extension Array where Element: Comparable {

    mutating func unic() -> Array<Element> {
        if self.count < 2 { return  self}
        var first = 0; var last = self.count - 1
        while first < last {
            if self[first] == self[last] {
                self.remove(at: last)
            }
            last -= 1
            if last == first {
                first += 1
                last = self.count - 1
            }
        }
        return self
    }
}
