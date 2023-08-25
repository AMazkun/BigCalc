//
//  StateMacine.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 23.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation
import AVFoundation

extension String {
    var ajastInput: String {

        var x = self.trimmingCharacters(in: .whitespacesAndNewlines).replacingOccurrences(of: ",", with: ".").replacingOccurrences(of: " ", with: "")

        if let dot = x.firstIndex(of: "."), x.suffix(from: dot) == ".0" {
            x = String(x.prefix(upTo: dot))
        }

        if x == "" || x == "-" || x == "." || x == "0E0" {return "0"}
        return  x
    }
}

class StateMachine {
    internal init(stateStack: StateStack = StateStack(initState: .firstDigitEnter(.clearBefore)), registers: Registers = Registers(), keyArray: [CalcButton] = mainKeyArray, memory: [String] = Array(repeating: "", count: 10), history: [Registers] = [], historyRecMax: Int = historyStep, showConformation: Bool = false) {
        self.stateStack = stateStack
        self.registers = registers
        self.keyArray = keyArray
        self.memory = memory
        self.historyRecMax = historyRecMax
        self.showConformation = showConformation
        self.history = history

        do {
            if let data = UserDefaults.standard.data(forKey: "BigCalcHistory") {
                let saved = try JSONDecoder().decode( [Registers].self, from: data)
                self.history = saved
            }
        } catch {
            self.history = history
        }
    }
    
    
    var stateStack : StateStack
    var registers : Registers
    var keyArray : [CalcButton]
    var memory = Array(repeating: "", count: 10)
    var history : [Registers]
    var historyRecMax : Int
    var showConformation : Bool

    func appendHistory() {
        if stateStack.state != .error {
            // Exclude duplicates
            if history.isEmpty || history[0] != registers {
                // revers history order, new - first
                history.insert(registers, at: 0)
            }
            // trimming history to maximum
            let recToDrop = history.count - historyRecMax
            if recToDrop > 0 {
                history = history.dropLast(recToDrop)
            }
        }
    }
    
    func saveHistory() {
        let data = try! JSONEncoder().encode(history)
        UserDefaults.standard.set(data, forKey: "BigCalcHistory")
    }
    
    func clear () {
        registers  = Registers()
        stateStack = StateStack(initState: .firstDigitEnter(.clearBefore))
    }
    
    func clearMemory() {
        memory = Array(repeating: "", count: 10)
        
        for i in 0..<keyArray.count {
            switch keyArray[i] {
            case .digit(_):
                if let n = Int(keyArray[i].title) {
                    keyArray[i] = .digit(abs(n))
                }
            default: break
            }
        }
    }
    
    
    func run( _ indx : Int) {
//        print("run:", keyArray[indx].description, stateStack.checkStr)

        switch keyArray[indx] {
        case .command(let command):    runCommand(indx, command); break
        case .digit(_):                runDigit(indx); break
        case .dot:                     runDot(); break
        case .op(let op):              runOp(indx, op); break
        case .memory(let memory):      runMemory(indx, memory); break
        }

//        print("run:<<", stateStack.checkStr, registers.argument1.line, registers.argument2.line, registers.result.line)
    }
}
