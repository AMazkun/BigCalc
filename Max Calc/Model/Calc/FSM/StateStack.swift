//
//  StateStack.swift
//  Big Calc
//
//  Created by Anatoly Mazkun  on 24.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation

enum ClearSign : String {
    case clearBefore    = "clearBefore"
    case continueInput  = "continueInput"
}

enum CalcRunState : Equatable {
    case error
    case firstDigitEnter(ClearSign)
    case secondDigitEnter(ClearSign)
    case firstDigitMemory(MemoryOp)
    case secondDigitMemory(MemoryOp)
    case resultMemory(MemoryOp)
    case memoryClear
    case result
    
    var title: String {
        switch self {
            
        case .error:
            return "error"
        case .firstDigitEnter(let input):
            return "firstDigitEnter(\(input.rawValue))"
        case .secondDigitEnter(let input):
            return "secondDigitEnter(\(input.rawValue))"
        case .firstDigitMemory(let digit):
            return "firstDigitMemory(\(digit.rawValue))"
        case .secondDigitMemory(let digit):
            return "secondDigitMemory(\(digit.rawValue))"
        case .resultMemory(let digit):
            return "resultMemory(\(digit.rawValue))"
        case .memoryClear:
            return "memoryClear"
        case .result:
            return "result"
        }
    }
    
    var isMemoryOperation : Bool {
        switch self {
        case .firstDigitMemory(_), .secondDigitMemory(_), .resultMemory(_),
             .memoryClear :
            return true
        default:
            return false
        }
    }
    
    var isSecondDigitEnter : Bool {
        switch self {
        case .secondDigitEnter(_):
            return true
        default:
            return false
        }
    }
    
    var isFirstDigitEnter : Bool {
        switch self {
        case .firstDigitEnter(_):
            return true
        default:
            return false
        }
    }

    var isResult : Bool {
        switch self {
        case .result:
            return true
        default:
            return false
        }
    }
    
    var getMemoryOpSign : String {
        var opSign : String
        switch self {
        case .firstDigitMemory(.store), .secondDigitMemory(.store), .resultMemory(.store) :
            opSign = "MS"
        case .firstDigitMemory(.recall), .secondDigitMemory(.recall), .resultMemory(.recall) :
            opSign = "M "
        case .memoryClear :
            opSign = "MC"
        default:
            opSign = ""
        }
        return opSign
    }

}

class StateStack {
    internal init(initState: CalcRunState) {
        self.stack = [initState]
    }
    
    private var stack : [CalcRunState] = []
    
    var check : [CalcRunState] {
        return stack
    }
    
    var checkStr : String {
        return stack.map( { $0.title }).description
    }
    
    var state : CalcRunState {
        get {
            if let state = stack.last  { return state }
            else { return .error }
        }
        set {
            if stack.isEmpty {stack.append(newValue) }
            else { stack[stack.count-1] = newValue }
        }
    }
    
    func push(_ state: CalcRunState) {
        stack.append(state)
    }
    
    func pop() -> CalcRunState {
        return stack.popLast() ?? .error
    }
    
    func popToNonMemory() -> CalcRunState {
        repeat {
            if state.isMemoryOperation {  _ = stack.popLast() }
            else {
                return state
            }
        }
        while stack.isEmpty;
                
        return .error
    }
    func seekNonMemory() -> CalcRunState {
        let res = stack.last(where: {!$0.isMemoryOperation}) ?? .error
        return res
    }
}
