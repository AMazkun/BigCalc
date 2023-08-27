//
//  LandscapeBody.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct LandscapeBody: View {
    @EnvironmentObject var calculator : CalculatorLogic

    var body: some View {
        GeometryReader { geometry in
            let displayHeight = geometry.size.height / 3.0
            let buttonsHeight = geometry.size.height  - displayHeight
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing, spacing: 5.0){
                DisplayArea()
                    .frame(height: displayHeight, alignment: .topTrailing)
                CalcButtomLandscape()
                    .frame(height: buttonsHeight, alignment: .bottomTrailing)
            }
        }
    }
}

struct LandscapeBody_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic(stateMachine: StateMachine(registers: Registers(
        argument1: Register(op: .plus,  line: "12345.67"),
        argument2: Register(op: .plus,    line: "345.33"),
        result:    Register(op: .percent, line: "956.75")
    )))
    static var previews: some View {
        Group {
            LandscapeBody().environmentObject(calculator)
                .previewDevice(PreviewDevice(rawValue: "iPad Pro (12.9-inch) (6th generation)"))
            LandscapeBody().environmentObject(calculator)
                .previewDevice(PreviewDevice(rawValue: "iPhone 14 Pro Max"))
                .previewInterfaceOrientation(.landscapeRight)
        }
    }
}
