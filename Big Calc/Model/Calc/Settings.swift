//
//  Settings.swift
//  Big Calc
//
//  Created by admin on 23.08.2023.
//

import Foundation

let maxDigits = 16

enum Appearence: String, CaseIterable, Identifiable, Codable {
    case Automatic, Portrait, Landscape
    var id: Self { self }
}

enum ShowExpression: String, CaseIterable, Identifiable, Codable {
    case Automatic, Never, Always
    var id: Self { self }
}

struct SetupValues : Codable {
    internal init(appearence: Appearence = .Automatic, showExpression: ShowExpression = .Automatic, dp: Int = 4, dpEE: Int = 8, allowEE: Bool = true, forceDP: Bool = false) {
        do {
            if let data = UserDefaults.standard.data(forKey: "BigCalcSetup") {
                let saved = try JSONDecoder().decode(SetupValues.self, from: data)
                self.appearence = saved.appearence
                self.showExpression = saved.showExpression
                self.dp = saved.dp
                self.dpEE = saved.dpEE
                self.allowEE = saved.allowEE
                self.forceDP = saved.forceDP
            }
        } catch {
            self.appearence = appearence
            self.showExpression = showExpression
            self.dp = dp
            self.dpEE = dpEE
            self.allowEE = allowEE
            self.forceDP = forceDP
        }
    }
    
    var appearence : Appearence = .Automatic
    var showExpression : ShowExpression = .Automatic // show expression in first line dispite orientation

    var dp : Int = 4            // digital plases
    var dpEE: Int = 8           // digital paces for Engeneering format
    var allowEE : Bool = true   // allow EE output
    var forceDP : Bool = false  // fix digital plases
    
    func save() {
        let data = try! JSONEncoder().encode(self)
        UserDefaults.standard.set(data, forKey: "BigCalcSetup")
    }
}
