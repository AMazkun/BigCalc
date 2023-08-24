//
//  Settings.swift
//  Big Calc
//
//  Created by admin on 23.08.2023.
//

import Foundation

let maxDigits = 16

enum Appearence: String, CaseIterable, Identifiable {
    case Automatic, Portrait, Landscape
    var id: Self { self }
}

enum ShowExpression: String, CaseIterable, Identifiable {
    case Automatic, Never, Always
    var id: Self { self }
}

struct SetupValues {
    var appearence : Appearence = .Automatic
    var showExpression : ShowExpression = .Automatic // show expression in first line dispite orientation

    var dp : Int = 4            // digital plases
    var dpEE: Int = 8           // digital paces for Engeneering format
    var allowEE : Bool = true   // allow EE output
    var forceDP : Bool = false  // fix digital plases
}
