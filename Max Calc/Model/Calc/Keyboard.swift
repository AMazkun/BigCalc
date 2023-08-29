//
//  Keyboard.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation

var mainKeyArray: [CalcButton] = 
[
    .command(.clear),   // 0
    .memory(.recall),   // 1
    .memory(.store),    // 2
    .memory(.erase),    // 3
    .op(.percent),      // 4
    .command(.back),    // 5

    .op(.under),        // 6
    .memory(.e),        // 7
    .memory(.pi),       // 8
    .op(.deg),          // 9
    .op(.rad),          // 10
    .op(.divide),       // 11
    
    .digit(7),          // 12
    .digit(8),          // 13
    .digit(9),          // 14
    .op(.sin),          // 15
    .op(.cos),          // 16
    .op(.multiply),     // 17
    
    .digit(4),          // 18
    .digit(5),          // 19
    .digit(6),          // 20
    .op(.tg),           // 21
    .op(.tanh),         // 22
    .op(.minus),        // 23
    
    .digit(1),          // 24
    .digit(2),          // 25
    .digit(3),          // 26
    .op(.pwr),          // 27
    .op(.x10),          // 28
    .op(.plus),         // 29
    
    .digit(0),          // 30
    .dot,               // 31
    .command(.flip),    // 32
    .op(.root),         // 33
    .op(.log),          // 34
    .op(.calc),         // 35
    
    .op(.cosh),         // 36
    .op(.sinh),         // 37
    .op(.factorial),    // 38
    .op(.rand),         // 39
    .memory(.gtp),      // 40
    .memory(.gtm)       // 41
]

class KeyArray {
    static let shared = KeyArray()
    var keyArray = mainKeyArray
}
