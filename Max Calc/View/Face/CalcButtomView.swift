//
//  CalcButtomView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct CalcButtomView: View {
    @EnvironmentObject var calculator : CalculatorLogic
    
    var index : Int
    
    var body: some View {
        GeometryReader { geometry in
            
            let min = CGFloat.minimum(geometry.size.width, geometry.size.height)
            ZStack {
                Button(action: {
                    calculator.run(index)
                }) {
                    Text(calculator.button(index).title)
                        .frame(width: geometry.size.width, height: geometry.size.height)
                        .font(.system(size: calculator.button(index).fontSize(min)))
                        .minimumScaleFactor(0.5)
                        .lineLimit(1)
                        .foregroundColor(Color("buttomForeground"))
                        .background(Color(calculator.button(index).backgroundColorName))
                        .clipShape(RoundedRectangle(cornerSize: geometry.size))
                }
                if (calculator.button(index).stored) {
                    Circle()
                        .fill(Color(MemoryOp.store.backgroundColorName).opacity(0.8))
                        .position(x: -min/4, y: -min/4)
                        .frame( width: geometry.size.width / 4, height: geometry.size.height / 4)
                }
            }
        }
    }
}

struct CalcButtomView_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        CalcButtomView(index: 7).environmentObject(calculator)
    }
}
