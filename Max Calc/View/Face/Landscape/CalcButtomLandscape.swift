//
//  CalcButtomLandscape.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct CalcButtomLandscape: View {
    @EnvironmentObject var calculator : CalculatorLogic

    var body: some View {
        VStack(spacing: 4) {
            Spacer()
            HStack(spacing: 4){
                CalcButtomView(index: 0)
                CalcButtomView(index: 1)
                CalcButtomView(index: 2)
                CalcButtomView(index: 3)
                CalcButtomView(index: 4)
                CalcButtomView(index: 5)
            }
            HStack(spacing: 4){
                CalcButtomView(index: 6)
                CalcButtomView(index: 7)
                CalcButtomView(index: 8)
                CalcButtomView(index: 9)
                CalcButtomView(index: 10)
                CalcButtomView(index: 11)
            }
            HStack(spacing: 4){
                CalcButtomView(index: 12)
                CalcButtomView(index: 13)
                CalcButtomView(index: 14)
                CalcButtomView(index: 15)
                CalcButtomView(index: 16)
                CalcButtomView(index: 17)
            }
            HStack(spacing: 4){
                CalcButtomView(index: 18)
                CalcButtomView(index: 19)
                CalcButtomView(index: 20)
                CalcButtomView(index: 21)
                CalcButtomView(index: 22)
                CalcButtomView(index: 23)
            }
            HStack(spacing: 4){
                CalcButtomView(index: 24)
                CalcButtomView(index: 25)
                CalcButtomView(index: 26)
                CalcButtomView(index: 27)
                CalcButtomView(index: 28)
                CalcButtomView(index: 29)
            }
            HStack(spacing: 4){
                CalcButtomView(index: 30)
                CalcButtomView(index: 31)
                CalcButtomView(index: 32)
                CalcButtomView(index: 33)
                CalcButtomView(index: 34)
                CalcButtomView(index: 35)
            }
        }
    }
}

struct CalcButtomPadLandscape_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        CalcButtomLandscape().environmentObject(calculator)
            .previewInterfaceOrientation(.landscapeLeft)
    }
}
