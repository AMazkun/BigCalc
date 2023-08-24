//
//  Big_CalcTests.swift
//  Big CalcTests
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import XCTest
@testable import Big_Calc

final class Big_CalcTests: XCTestCase {
    
    private var calculator : CalculatorLogic!
    

    override func setUpWithError() throws {
        // Put setup code here. This method is called before the invocation of each test method in the class.
        calculator = CalculatorLogic()
    }

    override func tearDownWithError() throws {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        calculator = nil
    }
    
    func test_empty_history() {
        XCTAssertFalse(calculator.historyNotEmpty)
    }

    func test_pwr_2_4() {
        
        // perfoming input pwr(2,4)=
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.pwr))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(4))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.calc))!)
        
        XCTAssertEqual(calculator.stateMachine.registers.argument1.line, "2")
        XCTAssertEqual(calculator.stateMachine.registers.argument1.op, .pwr)
        XCTAssertEqual(calculator.stateMachine.registers.result.line, "16")
        XCTAssertEqual(calculator.stateMachine.registers.result.op, .calc)
    }

    func test_error() {
        // perfoming input 1/0
        calculator.run(mainKeyArray.firstIndex(of: .op(.under))!)
        
        XCTAssertTrue(calculator.errorState)
    }

    func test_25_per_of_100() {
        
        // perfoming input 100*25%
        calculator.run(mainKeyArray.firstIndex(of: .digit(1))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(0))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(0))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.multiply))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(5))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.percent))!)
        
        XCTAssertEqual(calculator.stateMachine.registers.argument1.line, "100")
        XCTAssertEqual(calculator.stateMachine.registers.argument1.op, .multiply)
        XCTAssertEqual(calculator.stateMachine.registers.result.line, "25")
        XCTAssertEqual(calculator.stateMachine.registers.result.op, .percent)
    }

    func test_25_mul_4_div_25() {
        
        // perfoming input . +/- 25 * 4 / 25 =
        // perfoming input -.25 * 4 / 25 =
        calculator.run(mainKeyArray.firstIndex(of: .dot)!)
        calculator.run(mainKeyArray.firstIndex(of: .command(.flip))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(5))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.multiply))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(4))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.divide))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(5))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.calc))!)
        
        XCTAssertEqual(calculator.stateMachine.registers.argument1.line, "-1")
        XCTAssertEqual(calculator.stateMachine.registers.argument1.op, .divide)
        XCTAssertEqual(calculator.stateMachine.registers.result.line, "-0.04")
        XCTAssertEqual(calculator.stateMachine.registers.result.op, .calc)
    }

    func test_memory() {
        
        // perfoming input -.25 * 4 / 25 =
        calculator.run(mainKeyArray.firstIndex(of: .dot)!)
        calculator.run(mainKeyArray.firstIndex(of: .command(.flip))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(5))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.multiply))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(4))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.calc))!)
        calculator.run(mainKeyArray.firstIndex(of: .memory(.store))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .command(.clear))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(6))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.minus))!)
        calculator.run(mainKeyArray.firstIndex(of: .memory(.recall))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.calc))!)
        
        XCTAssertEqual(calculator.stateMachine.registers.argument1.line, "6")
        XCTAssertEqual(calculator.stateMachine.registers.argument1.op, .minus)
        XCTAssertEqual(calculator.stateMachine.registers.result.line, "7")
        XCTAssertEqual(calculator.stateMachine.registers.result.op, .calc)
    }

    func mokeCalc () {
        calculator.run(mainKeyArray.firstIndex(of: .dot)!)
        calculator.run(mainKeyArray.firstIndex(of: .command(.flip))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(5))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.multiply))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(4))!)
        calculator.run(mainKeyArray.firstIndex(of: .memory(.store))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .command(.clear))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(6))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.minus))!)
        calculator.run(mainKeyArray.firstIndex(of: .memory(.recall))!)
        calculator.run(mainKeyArray.firstIndex(of: .digit(2))!)
        calculator.run(mainKeyArray.firstIndex(of: .op(.calc))!)
        calculator.run(mainKeyArray.firstIndex(of: .command(.clear))!)
    }
    
    func testPerformanceExample() throws {
        // This is an example of a performance test case.
        self.measure {
            for _ in 1...1000 {mokeCalc()}
        }
    }

}
