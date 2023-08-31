//
//  CalculyatorLogic+Format.swift
//  Max Calc
//
//  Created by admin on 31.08.2023.
//

import Foundation

extension CalculatorLogic {
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
        // EE format only if > 1_000_000, less 0.000_000_000_1, but not 0, nil - in fixed format
        let goEE = setupValues.allowEE && (abs_val != 0) && ((abs_val > 1_000_000_000) || (abs_val < 0.000_000_000_1))
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
        case .under, .tanh, .cos, .rad, .sin, .tg:
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
}
