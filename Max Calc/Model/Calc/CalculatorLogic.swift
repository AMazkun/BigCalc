//
//  CalculatorLogic.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation
import SwiftUI
import AVFoundation

struct MemoryIdentifiable: Identifiable {
    let id : Int
    let value: String
}

final class CalculatorLogic : ObservableObject  {
    internal init(stateMachine: StateMachine = StateMachine(), setupValues: SetupValues = SetupValues(), history: [Registers] = [], showConformation: Bool = false) {
        self.setupValues = setupValues
        self.stateMachine = stateMachine
        self.showConformation = showConformation
        self.history = history
        
        // read saved history from UserDefaults
        do {
            if let data = UserDefaults.standard.data(forKey: "MaxCalcHistory") {
                let saved = try JSONDecoder().decode( [Registers].self, from: data)
                self.history = saved
            }
        } catch {
            self.history = history
        }
    }
    
    @Published var setupValues  : SetupValues
    @Published var stateMachine : StateMachine
    @Published var showConformation : Bool
    @Published var history : [Registers]
    
    var getVariables : [MemoryIdentifiable] {
        var result : [MemoryIdentifiable] = []
        for i in 0...stateMachine.memory.count-1 {
            result.append(MemoryIdentifiable(id: i, value: stateMachine.memory[i]))
        }
        return result
    }
    
    var isResult : Bool  {
        return (stateMachine.stateStack.state == .result ||
                // In arithmetic flow .result state omitted, and we have .secondDigitEnter instead
                // so have to add thi way
                // Have to think
                stateMachine.registers.argument2.op == .calc
        )
    }
    
    var isError : Bool  {
        return (stateMachine.stateStack.state == .error)
    }
    
    func saveWork() {
        saveHistory()
        stateMachine.saveMemory()
    }

    func run(_ keyIndx : Int) {
        // RUN
        stateMachine.run(keyIndx)
        
        // Store all results
        if isResult { appendHistory() }
        showConformation = stateMachine.showConformation
    }
    
    func button(_ index : Int) -> CalcButton {
        return stateMachine.keyArray[index]
    }

    var historyNotEmpty : Bool {
        return history.count > 0
    }

    func removeHistory() {
        history.removeAll()
        saveHistory()
    }
    
    func appendHistory() {
        // Exclude duplicates
        if history.isEmpty || history[0] != stateMachine.registers {
            // revers history order, new - first
            history.insert(stateMachine.registers, at: 0)
        }
        // trimming history to maximum
        let recToDrop = history.count - setupValues.history
        if recToDrop > 0 {
            history = history.dropLast(recToDrop)
        }
    }
    
    func saveHistory() {
        let data = try! JSONEncoder().encode(history)
        UserDefaults.standard.set(data, forKey: "MaxCalcHistory")
    }
    
    
    // clrear ALL memotry cells
    func clearMemory() {
        stateMachine.clearMemory()
    }
    
    func onCopy() -> String {
        switch stateMachine.stateStack.state {
            case .firstDigitEnter:
            return stateMachine.registers.argument1.line.ajastInput
            case .secondDigitEnter:
            return stateMachine.registers.argument2.line.ajastInput
            case .result:
            return stateMachine.registers.result.line.ajastInput
        default: return ""
        }
    }

    func onPaste(_ value : String) {
        switch stateMachine.stateStack.state {
        case .firstDigitEnter:
            stateMachine.registers.argument1 = Register(line: value)
            stateMachine.stateStack.state = .firstDigitEnter(.clearBefore)
        case .secondDigitEnter:
            stateMachine.registers.argument2 = Register(line: value)
        case .result:
            stateMachine.registers.argument1.line = stateMachine.registers.result.line
            stateMachine.registers.argument2 = Register(line: value)
            stateMachine.stateStack.state = .secondDigitEnter(.clearBefore)
        case .firstDigitMemory, .secondDigitMemory, .resultMemory, .memoryClear, .error:
            break
        }
    }
}
