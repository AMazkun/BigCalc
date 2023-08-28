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
            if let data = UserDefaults.standard.data(forKey: "BigCalcHistory") {
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

    func displayFormatter(_ val : String) -> String {
        // debugPrint(val)
        if val == "0" || val == "0." || val == "" || val == "-0" || val == "-" {return val}
        if let val = Double(val) {
            return displayFormatter(val) }
        else {
            return "err?"
        }
    }
    
    func displayFormatter(_ val : Double) -> String {
        let formatter = NumberFormatter()
        let abs_val = abs(val)
        let goEE = setupValues.allowEE && ((abs_val > 1_000_000_000) || (abs_val < 0.000_000_000_1))
        formatter.numberStyle = goEE ? .scientific : .decimal
        formatter.minimumFractionDigits = (setupValues.forceDP) ? setupValues.dp : 0
        formatter.usesGroupingSeparator = false
        formatter.allowsFloats = (setupValues.dp > 0)
        formatter.maximumFractionDigits = setupValues.allowEE ? setupValues.dpEE : setupValues.dp
        let format = formatter.string(from: val as NSNumber)
        let res = format ?? "arg?"
        // debugPrint(format, res)
        return res
    }
    
    func showCalcExpression(_ registers: Registers) -> String {
        switch registers.argument1.op {
        case .under, .arctg, .cos, .rad, .sin, .tg:
            return String ("\(registers.argument1.op.rawValue) ( \(displayFormatter(registers.argument1.line)) )")
        case .root, .pwr, .log :
            return String ("\(registers.argument1.op.rawValue) ( \(displayFormatter(registers.argument1.line)), \(displayFormatter(registers.argument2.line)) )")
        default:
            var line2 = displayFormatter(registers.argument2.line)
            if let val = Double(line2.ajastInput), val < 0 {line2 = "(" + line2 + ")"}
            if registers.argument2.op == .percent {
                return displayFormatter(registers.argument1.line) + " " + registers.argument1.op.rawValue + " " + line2 + registers.argument2.op.rawValue
            } else {
                return displayFormatter(registers.argument1.line) + " " + registers.argument1.op.rawValue + " " + line2
            }
        }
    }

    func firstLine() -> String {
        let meanState = stateMachine.stateStack.seekNonMemory()
        if meanState.isFirstDigitEnter {
            return stateMachine.registers.argument1.line
        }
        
        if Coordinator.shared.isPortrait && !(setupValues.showExpression == .Always) {
            // short view
            return displayFormatter(stateMachine.registers.argument1.line) + " " + stateMachine.registers.argument1.op.rawValue
        } else {
            return showCalcExpression(stateMachine.registers)
        }
    }
    
    func secondLine() -> String {
        let meanState = stateMachine.stateStack.seekNonMemory()

        switch meanState {
        case .result :
            return displayFormatter(stateMachine.registers.result.line) + " " + stateMachine.registers.result.op.rawValue
        default:
            if stateMachine.registers.argument2.line == ""  {
                return ""
            }
            if (meanState.isSecondDigitEnter) {
                return stateMachine.registers.argument2.line
            }
            return displayFormatter(stateMachine.registers.argument2.line)
        }
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
        UserDefaults.standard.set(data, forKey: "BigCalcHistory")
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
