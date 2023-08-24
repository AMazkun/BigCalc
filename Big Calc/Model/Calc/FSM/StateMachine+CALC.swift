//
//  StateMachine+CALC.swift
//  Big Calc
//
//  Created by Anatoly Mazkun  on 24.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation
import AVFoundation

extension StateMachine {
    
    func logC(val: Double, forBase base: Double) -> Double {
        if base ==  2.0  { return log2(val)}
        if base ==  10.0 { return log10(val)}
        if base ==  M_E  { // should work !!! tested
            return log(val)
        }
        return log(val)/log(base)
    }
    
    func rootC(val: Double, forBase base: Double) -> Double {
        if base ==  2.0  {
            let result = sqrtl(val)
            return result
        }
        return pow(val,  1.0 / base)
    }
    
    
    func calc1ArgFunc(_ op : Op) {
        if let operand1 = Double(registers.argument1.line.ajastInput) {
            var result : Double
            switch op {
            case  .arctg :
                result = atan(operand1)
            case  .cos:
                result = cos(operand1)
            case  .deg:
                result = operand1 / .pi * 180.0
            case  .rad:
                result = operand1 * .pi / 180.0
            case  .sin:
                result = sin(operand1)
            case  .tg:
                result = tan(operand1)
            case  .under:
                result = 1.0 / operand1
                
            default: return;
            }
            
            registers.argument1.op = op
            registers.argument2.op = .calc
            
            stateStack.state = result.isNormal ?  .result : .error
            registers.result.line = String(result).ajastInput
            registers.result.op = .calc
            appendHistory()

        } else {
            stateStack.state = .error
        }
    }
    
    func calcResult(go : Bool) {
        if let operand1 = Double(registers.argument1.line.ajastInput) {
            if let operand2 = Double(registers.argument2.line.ajastInput) {
                var result : Double
                switch registers.argument1.op {
                case .plus :
                    result = operand1 + operand2; break;
                case .minus:
                    result = operand1 - operand2; break;
                case .multiply:
                    result = operand1 * operand2
                case .divide:
                    result = operand1 / operand2
                case .pwr:
                    result = pow(operand1,  operand2)
                case  .x10:
                    result = operand1 * pow(10.0, operand2)
                case .root:
                    result = rootC(val: operand1, forBase: operand2); break;
                case .log:
                    result = logC(val: operand1, forBase: operand2); break;
                default: return;
                }
                // ajast appeasrence
                registers.argument2.line = String(operand2).ajastInput
                if result.isFinite {
                    if go {
                        stateStack.state = .secondDigitEnter(.clearBefore)
                        registers.result.line = String(result).ajastInput
                        registers.result.op = .calc
                        appendHistory()
                        registers.argument1.line = String(result).ajastInput
                    } else  {
                        stateStack.state = .result
                        registers.result.line = String(result).ajastInput
                        registers.result.op = .calc
                        appendHistory()
                    }
                } else {
                    stateStack.state = .error
                    registers.result.line = String(result.description)
                }
            } else {
                stateStack.state = .error
            }
        } else {
            stateStack.state = .error
        }
    }
    
    func calcPercent() {
        if let operand1 = Double(registers.argument1.line.ajastInput) {
            if let operand2 = Double(registers.argument2.line.ajastInput) {
                var result : Double
                switch registers.argument1.op {
                case .plus :
                    result = operand1 * (1 +  operand2 / 100.0); break;
                case .minus:
                    result = operand1 * (1 -  operand2 / 100.0); break;
                case .multiply:
                    result = operand1 * (operand2 / 100.0); break;
                case .divide:
                    result = operand1 / (operand2 / 100.0); break;
                default: return;
                }
                stateStack.state = (result.isFinite) ? .result : .error
                
                // ajast appeasrence
                registers.argument2.line = String(operand2).ajastInput
                registers.result.line = String(result).ajastInput
                
                appendHistory()
                registers.result.op = .percent
            } else {
                stateStack.state = .error
            }
        } else {
            stateStack.state = .error
        }
    }
}
