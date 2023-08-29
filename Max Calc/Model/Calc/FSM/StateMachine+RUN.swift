//
//  StateMachine+RUN.swift
//  Big Calc
//
//  Created by Anatoly Mazkun  on 24.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation
import AVFoundation

extension StateMachine {
    
    func runCommand( _ indx : Int, _ command: Command) {
        if command == .clear { // reset is sacred, it can be pierced with nails
            clear(); return
        }
        
        switch stateStack.state {
        case .firstDigitEnter(let input):
            switch command {
            case .clear:
                clear()
            case .brackE:
                break;
            case .brackO:
                break;
            case .coma:
                break;
            case .back:
                if (registers.argument1.line.count > 0), let _ = Double(String(registers.argument1.line.dropLast())) {
                    registers.argument1.line = String(registers.argument1.line.dropLast())
                    stateStack.state = .firstDigitEnter(.continueInput)
                } else {
                    registers.argument1  = Register(line: "0")
                    stateStack.state = .firstDigitEnter(.clearBefore)
                }
                break;
            case .flip:
                if input == .clearBefore {
                    stateStack.state = .firstDigitEnter(.continueInput)
                    registers.argument1.line = "-"
                    break
                }
                if registers.argument1.line.count > 0 {
                    if registers.argument1.line.contains("-") {
                        registers.argument1.line = String(registers.argument1.line.dropFirst()).ajastInput
                    } else {
                        registers.argument1.line  = "-" + registers.argument1.line
                    }
                }
                break;
            }
        case .secondDigitEnter(let input):
            switch command {
            case .clear:
                clear()
            case .brackE:
                break;
            case .brackO:
                break;
            case .coma:
                break;
            case .back:
                if (registers.argument2.line.count > 0), let _ = Double(String(registers.argument2.line.dropLast())) {
                    registers.argument2.line = String(registers.argument2.line.dropLast())
                    stateStack.state = .secondDigitEnter(.continueInput)
                } else {
                    if input == .continueInput {
                        registers.argument2 = Register(line: "")
                        stateStack.state = .secondDigitEnter(.clearBefore)
                    } else {
                        registers.argument2 = Register(line: "")
                        stateStack.state = .firstDigitEnter(.continueInput)
                        registers.argument1.op = .nun
                    }
                }
            case .flip:
                if input == .clearBefore {
                    registers.argument2.line = "-"
                    stateStack.state = .secondDigitEnter(.continueInput)
                    break
                }
                if registers.argument2.line.count > 0 {
                    if registers.argument2.line.contains("-") {
                        registers.argument2.line = String(registers.argument2.line.dropFirst())
                    } else {
                        registers.argument2.line = "-" + registers.argument2.line
                    }
                }
                break;
            }
            break
        case .result:
            switch command {
            case .clear:
                clear()
            case .back:
                registers.argument2 = Register(line: "0")
                stateStack.state = .secondDigitEnter(.clearBefore)
            default:
                break
            }
            break;
        case .firstDigitMemory,
                .secondDigitMemory,
                .resultMemory,
                .memoryClear:
            if command == .clear {
                clear()
            } else {
                _=stateStack.popToNonMemory()
                showConformation = true
            }
        case .error:
            switch command {
            case .clear:
                clear()
            default: break
            }
        }
    }
    
    func runMemory(_ indx : Int, _ memoryOp : MemoryOp) {
        switch stateStack.state {
        case .firstDigitEnter:
            switch memoryOp {
            case .erase:
                stateStack.push(.memoryClear)
            case .recall, .store :
                stateStack.push(.firstDigitMemory(memoryOp))
            case .e : registers.argument1.line = String(M_E)
            case .pi : registers.argument1.line = String( Double.pi )
            case .gtp, .gtm:
                break
            }
        case .secondDigitEnter:
            switch memoryOp {
            case .erase:
                stateStack.push(.memoryClear)
            case .recall, .store :
                stateStack.push(.secondDigitMemory(memoryOp))
            case .e : registers.argument2.line = String(M_E)
            case .pi : registers.argument2.line = String(Double.pi)
            case .gtp, .gtm:
                break
            }
        case .result:
            switch memoryOp {
            case .erase:
                stateStack.push(.memoryClear)
            case .store:
                stateStack.push(.resultMemory(.store))
            case .recall:
                stateStack.push(.resultMemory(.recall))
            default:
                break
            }
        case .firstDigitMemory(let op),
             .secondDigitMemory(let op),
             .resultMemory(let op):
            if (memoryOp == .recall) && (op == .recall) {
                Coordinator.shared.event(.ShowVariables)
            } else {
                showConformation = true
            }
            _=stateStack.popToNonMemory()
        case .memoryClear:
            _=stateStack.popToNonMemory()
            showConformation = true
        case .error:
            break
        }
    }

    func runOp(_ indx : Int, _ op : Op) {
        switch stateStack.state {
        case .firstDigitEnter:
            switch op {
            case .plus, .minus, .multiply, .divide, .pwr, .root, .log, .x10:
                registers.argument2.line = "0"
                registers.argument1.op = op
                let ajusted = registers.argument1.line.ajastInput
                if let _ = Double(ajusted) {
                    registers.argument1.line = ajusted
                    stateStack.state = .secondDigitEnter(.clearBefore)
                } else {
                    registers.argument1.line = "err arg"
                    stateStack.state = .error
                }
            case .under, .tanh, .cos, .rad, .deg, .sin, .tg:
                calc1ArgFunc(op)
            default:
                break;
            }
        case .secondDigitEnter:
            switch op {
            case .plus, .minus, .multiply, .divide, .pwr, .root, .log, .x10:
                calcResult(go: true)
                registers.argument1.op = op
            case .calc:
                registers.argument2.op = op
                calcResult(go: false)
            case .percent:
                registers.argument2.op = op
                calcPercent()
            default:
                break;
            }
        case .result:
            switch op {
            // result as first argument
            case .plus, .minus, .multiply, .divide, .pwr, .root, .log, .x10:
                let ajustedArg = registers.result.line.ajastInput
                if let _ = Double(ajustedArg) {
                    registers.argument1.line = ajustedArg
                    registers.argument2 = Register(line: "0")
                    registers.argument1.op = op
                    stateStack.state = .secondDigitEnter(.clearBefore)
                } else {
                    registers.argument1.line = "err arg"
                    stateStack.state = .error
                }
                // repeat last op
            case .calc:
                registers.argument1.line = registers.result.line
                calcResult(go: false)
                // repeat last op
            case .percent:
                calcPercent()
                // repeat last one argemetf func on result
            case .under, .tanh, .cos, .rad, .deg, .sin, .tg:
                registers.argument1.line = registers.result.line
                calc1ArgFunc(op)
            default: break
            }
        case .firstDigitMemory,
                .secondDigitMemory,
                .memoryClear:
            _=stateStack.popToNonMemory()
            showConformation = true
        default:
            break
        }
    }
    
    func runDigit(_ indx : Int) {
        switch stateStack.state {
        case .firstDigitEnter(let input):
            if input == .clearBefore {registers.argument1.line = ""; stateStack.state = .firstDigitEnter(.continueInput)}
            if (registers.argument1.line.count <= maxDigits) {
                if registers.argument1.line == "0" {
                    registers.argument1.line = keyArray[indx].title
                } else {
                    registers.argument1.line += keyArray[indx].title
                }
            }
            break
        case .secondDigitEnter(let input):
            if input == .clearBefore {registers.argument2.line = ""; stateStack.state = .secondDigitEnter(.continueInput)}
            if (registers.argument2.line.count <= maxDigits) {
                if registers.argument2.line == "0" {
                    registers.argument2.line = keyArray[indx].title
                } else {
                    registers.argument2.line += keyArray[indx].title
                }
            }
            break
        case .result:
            stateStack.state = .firstDigitEnter(.clearBefore)
            registers.argument1 = Register(op:.nun, line:"0")
            registers.argument2 = Register(op:.nun, line: "")
        case .firstDigitMemory(let memOp):
            // wrong cell 0 - impossible
            if keyArray[indx].title == "0" {
                _=stateStack.popToNonMemory()
                return
            }
            switch memOp {
            case .recall:
                if let cell = Int(keyArray[indx].title), keyArray[indx].stored {
                    registers.argument1.line =  memory[abs(cell)]
                } else {
                    AudioServicesPlayAlertSound(SystemSoundID(1322))
                    showConformation = true
                }
            case .store:
                if let n = Int(keyArray[indx].title) {
                    let cell = abs(n)
                    memory[cell] = registers.argument1.line.ajastInput
                    keyArray[indx] = .digit(-cell)
                }
            default: break
            }
            _=stateStack.popToNonMemory()
        case .secondDigitMemory(let memOp):
            // wrong cell 0 - impossible
            if keyArray[indx].title == "0" {
                _=stateStack.popToNonMemory()
                return
            }
            switch memOp {
            case .recall:
                if stateStack.popToNonMemory() == .result {break}
                if let cell = Int(keyArray[indx].title), keyArray[indx].stored {
                    registers.argument2.line =  memory[abs(cell)]
                } else {
                    AudioServicesPlayAlertSound(SystemSoundID(1322))
                    showConformation = true
                }
            case .store:
                if let n = Int(keyArray[indx].title) {
                    let cell = abs(n)
                    if stateStack.popToNonMemory() == .result {memory[cell] = registers.result.line}
                    else {memory[cell] = registers.argument2.line}
                    keyArray[indx] = .digit(-cell)
                }
            default:
                _=stateStack.popToNonMemory()
            }
        case .resultMemory(let memOp):
            if keyArray[indx].title == "0" {
                _=stateStack.popToNonMemory()
                return
            }
            switch memOp {
            case .recall:
                if stateStack.popToNonMemory() == .result {break}
                if let cell = Int(keyArray[indx].title), keyArray[indx].stored {
                    registers.result.line =  memory[abs(cell)]
                } else {
                    AudioServicesPlayAlertSound(SystemSoundID(1322))
                    showConformation = true
                }
            case .store:
                if let n = Int(keyArray[indx].title) {
                    let cell = abs(n)
                    if stateStack.popToNonMemory() == .result {memory[cell] = registers.result.line}
                    else {memory[cell] = registers.result.line}
                    keyArray[indx] = .digit(-cell)
                }
            default:
                _=stateStack.popToNonMemory()
            }
        case .memoryClear:
            if let n = Int(keyArray[indx].title) {
                let cell = abs(n)
                memory[cell] = ""
                keyArray[indx] = .digit(cell)
            }
            _=stateStack.popToNonMemory()
        case .error:
            break
        }
    }
    
    func runDot() {
        switch stateStack.state {
        case .firstDigitEnter(let input):
            if input == .clearBefore {registers.argument1.line = "0."; stateStack.state = .firstDigitEnter(.continueInput)}
            if (registers.argument1.line.count <= maxDigits && !registers.argument1.line.contains(".")) {
                if registers.argument1.line == "" { registers.argument1.line =  "0."}
                else {registers.argument1.line +=  "."}
            }
            break
        case .secondDigitEnter(let input):
            // first simbol
            if input == .clearBefore {
                registers.argument2.line = "0."
                stateStack.state = .secondDigitEnter(.continueInput)
                break
            }
            // already has dot
            if registers.argument2.line.contains(".") {break}
            if (registers.argument2.line.count <= maxDigits && !registers.argument2.line.contains(".")) {
                if registers.argument2.line == "" { registers.argument2.line =  "0."}
                else {registers.argument2.line +=  "."}
            }
        case .result:
            stateStack.state = .firstDigitEnter(.continueInput)
            registers.argument1 = Register(op:.nun, line:"0.")
            registers.argument2 = Register(op:.nun, line: "")
        case .firstDigitMemory,
                .secondDigitMemory,
                .memoryClear:
            _=stateStack.popToNonMemory()
            showConformation = true
        default:
            break;
        }
    }
}
