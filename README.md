# BigCalc
iPhone iPad calculator based SwiftUI

Every real programmer writes two codes:
1. Hello Word for console application
2. Calculator for testing UI

I'm not an exception

# iOS Calculator 
(screenshots attached)

 Features:
 --------
- Portrait (Simple) / Landscape (Math) mode / Autorotate
- Togle first line: argument or expression (Portraite / Landscape)
- Very Big Buttons
- 9 cells memory storage (access button 'M' then digit '1' - '9',  'M' 'M' - shows all list) with indication used cell
- All universal Math functions as root(value, base), log(value, base), pwr(value, base)
- Constants Pi and e
- History
- Memory operations indicator
- Copy/paste result and arguments
- Extended result formatting:
  - engeneering format
  - fixed digital plases for fraction

Used:
- SwiftUI, Forms
- Router + Coordinator patters
- View Controller / Logic Separation, trying
- @EnvironmentObject / @State patterns
- Test Units, a little example
- Full FSM (Mealy machine):
  - Switch / Case implementation (a big pain (long unreadable coding, do it better!) ... in progress)
  - State in stack organisation

# FSM States Tree
enum ClearSign {

    case clearBefore = "clearBefore"
    case continueInput = "continueInput"
}

enum MemoryOp {

    case erase = "MC"
    case store = "MS"
    case recall = "M"
    case pi = "𝛑"
    case e = "e"
}

enum CalcRunState {

    case error
    case firstDigitEnter(ClearSign)
    case secondDigitEnter(ClearSign)
    case firstDigitMemory(MemoryOp)
    case secondDigitMemory(MemoryOp)
    case resultMemory(MemoryOp)
    case memoryClear
    case result
}

# Inspiration:
- Designing A Calculator with FSM Logic
https://rvunabandi.medium.com/making-a-calculator-in-javascript-64193ea6a492
- Finite-state machine
https://en.wikipedia.org/wiki/Finite-state_machine
- Mealy machine
https://en.wikipedia.org/wiki/Mealy_machine
