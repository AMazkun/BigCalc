//
//  StateMacine.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 23.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation
import AVFoundation

class StateMachine {
    internal init(stateStack: StateStack = StateStack(initState: .firstDigitEnter(.clearBefore)), registers: Registers = Registers(), keyArray: [CalcButton] = mainKeyArray, memory: [String] = Array(repeating: "", count: 10), showConformation: Bool = false) {
        self.stateStack = stateStack
        self.registers = registers
        self.keyArray = keyArray
        self.memory = memory
        self.showConformation = showConformation
    }
    
    
    var stateStack : StateStack
    var registers : Registers
    var keyArray : [CalcButton]
    var memory = Array(repeating: "", count: 10)
    var showConformation : Bool

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
