//
//  CalcButton.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//
import SwiftUI

enum Op: String, Equatable {
    case plus = "+"
    case minus = "−"
    case multiply = "×"
    case divide = "÷"
    case calc = "="
    case percent = "%"
    case sin = "sin"
    case cos = "cos"
    case tg = "tg"
    case arctg = "arctg"
    case pwr = "pwr"
    case root = "root"
    case log = "log"
    case under = "1/x"
    case rad = "rad"
    case deg = "deg"
    case x10 = "10ˣ"
    case nun = ""
}

enum Command: String {
    case clear = "AC"
    case brackE = "("
    case brackO = ")"
    case coma = ","
    case back = "DEL"
    case flip = "±"
}

enum MemoryOp: String {
    case erase = "MC"
    case store = "MS"
    case recall = "M"
    case pi = "𝛑"
    case e = "e"
}

enum CalcButton {

    case digit(Int)
    case dot
    case op(Op)
    case command(Command)
    case memory(MemoryOp)

}

extension MemoryOp {
    var backgroundColorName : String
    { return "memoryBackground"}
}

extension Op {
    func fontSize(_ max: CGFloat) -> CGFloat{
        switch self {
        case .plus, .minus, .multiply,
                .divide, .calc : return max / 1.5
        case .percent: return max / 2
        default: return max / 2.5
        }
    }
}

extension CalcButton {
    
    var stored : Bool {
        switch self {
        case .digit(let value):
            return value < 0
        default: return false
        }
    }
    
    var title: String {
        switch self {
        case .digit(let value):
            return String(abs(value))
        case .dot:
            return "."
        case .op(let op):
            return op.rawValue
        case .command(let command):
            return command.rawValue
        case .memory(let memory):
            return memory.rawValue
        }
    }
    
    func size(_max : CGSize) -> CGSize {
        if case .digit(let value) = self, value == 0 {
            return CGSize(width: 88 * 2 + 8, height: 88)
        }
        return CGSize(width: 88, height: 88)
    }
    
    // dynamic font size for different display text length so that it does not exceed the control panel width
    func fontSize(_ max : CGFloat) -> CGFloat {
        switch self {
        case .digit, .dot:
            return max - 5
        case .op(let op): return op.fontSize(max)
        case .command(let command):
            switch command {
            case .flip: return max / 1.5
            case .clear, .back: return max / 3
            case .coma: return max - 5
               default: return max / 2.0;
            }
        case .memory(let memory):
            switch(memory) {
            case .e, .pi : return max / 2.0
            default: return max / 3.0
            }
        }
    }

    var backgroundColorName: String {
        switch self {
        case .digit, .dot:
            return "digitBackground"
        case .op(let op):
            switch op {
            case .arctg, .cos, .log, .sin, .tg, .pwr, .root, .under, .x10, .rad, .deg:
                    return "functionBackground"
            default:
                    return "operatorBackground"
            }
        case .command(let command):
            return (command == .clear || command == .back) ? "clearAccumulyator" : "commandBackground"
        case .memory(let mem):
            return mem.backgroundColorName
        }
    }
    
    var foregroundColor: Color {
        switch self {
        case .command:
            return Color("commandForeground")
        default:
            return .white
        }
    }
}

extension CalcButton: Hashable {}

extension CalcButton: CustomStringConvertible {
    var description: String {
        switch self {
        case .digit(let num): return String(num)
        case .dot: return "."
        case .op(let op): return op.rawValue
        case .command(let command): return command.rawValue
        case .memory(let memory): return memory.rawValue
        }
    }
}
