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
    internal init(stateMachine: StateMachine = StateMachine(), setupValues: SetupValues = SetupValues(), showConformation: Bool = false) {
        self.stateMachine = stateMachine
        self.setupValues = setupValues
        self.showConformation = showConformation
    }

    @Published var stateMachine : StateMachine = StateMachine()
    @Published var setupValues = SetupValues()
    @Published var showConformation : Bool = false
    
    var getVariables : [MemoryIdentifiable] {
        var result : [MemoryIdentifiable] = []
        for i in 0...stateMachine.memory.count-1 {
            result.append(MemoryIdentifiable(id: i, value: stateMachine.memory[i]))
        }
        return result
    }
    
    func run(_ indx : Int) {
        let stateBeforeResult =  stateMachine.stateStack.state.isResult
        stateMachine.run(indx)
        if stateMachine.stateStack.state.isFirstDigitEnter && stateBeforeResult {
            stateMachine.registers.argument1.line = displayFormatter(stateMachine.registers.argument1.line)
        }
        showConformation = stateMachine.showConformation
    }
    
    func button(_ index : Int) -> CalcButton {
        return stateMachine.keyArray[index]
    }

    func displayFormatter(_ val : String) -> String {
        // debugPrint(val)
        if val == "0" || val == "" {return val}
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
            if registers.argument2.op == .percent {
                return displayFormatter(registers.argument1.line) + " " + registers.argument1.op.rawValue + " " + displayFormatter(registers.argument2.line) + registers.argument2.op.rawValue
            } else {
                return displayFormatter(registers.argument1.line) + " " + registers.argument1.op.rawValue + " " + displayFormatter(registers.argument2.line)
            }
        }
    }

    func firstLine() -> String {
        if Coordinator.shared.isPortrait && !(setupValues.showExpression == .Always) {
            // short view
            let meanState = stateMachine.stateStack.seekNonMemory()
            
            switch meanState {
            case .firstDigitEnter:
                return stateMachine.registers.argument1.line
//            case .result:
//                return displayFormatter(stateMachine.registers.result.line) + " " + stateMachine.registers.argument1.op.rawValue
            default:
                return displayFormatter(stateMachine.registers.argument1.line) + " " + stateMachine.registers.argument1.op.rawValue
            }
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
            if stateMachine.registers.argument2.line == ""  {return ""}
            if (meanState.isSecondDigitEnter) {return stateMachine.registers.argument2.line}
            return displayFormatter(stateMachine.registers.argument2.line)
        }
    }

    var errorState : Bool  {
        return (stateMachine.stateStack.state == .error)
    }
    
    var historyNotEmpty : Bool {
        return stateMachine.history.count > 0
    }

    func removeHistory() {
        stateMachine.history.removeAll()
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
