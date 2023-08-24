//
//  Registers.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 23.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation

struct Register: Hashable {
    internal init(op: Op = .nun, line: String = "") {
        self.op = op
        self.line = line
    }
    
    var op: Op
    var line: String
    
    static func == (lhs: Register, rhs: Register) -> Bool {
        return (lhs.line == rhs.line)
        && (lhs.op == rhs.op)
    }
}

struct Registers: Hashable {
    internal init(argument1: Register = Register(line: "0"), argument2: Register = Register(line: ""), result: Register = Register(line: "")) {
        self.argument1 = argument1
        self.argument2 = argument2
        self.result = result
    }
    
    static func == (lhs: Registers, rhs: Registers) -> Bool {
        return (lhs.argument1 == rhs.argument1)
        && (lhs.argument2 == rhs.argument2)
        && (lhs.result == rhs.result)
    }
    
    var argument1:  Register  = Register(line: "0")
    var argument2:  Register  = Register(line: "")
    var result:     Register  = Register(line: "")
    
}
