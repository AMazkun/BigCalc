//
//  CalcButtomPortrit.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct CalcButtomPortrait: View {
    @EnvironmentObject var calculator : CalculatorLogic
        
    var body: some View {
        VStack(spacing: 8) {
            HStack(spacing: 8){
                CalcButtomView(index: 0)
                CalcButtomView(index: 32)
                CalcButtomView(index: 4)
                CalcButtomView(index: 5)
                //Spacer()
            }
            HStack(spacing: 8){
                //Spacer()
                CalcButtomView(index: 1)
                CalcButtomView(index: 2)
                CalcButtomView(index: 3)
                CalcButtomView(index: 11)
                //Spacer()
            }
            HStack(spacing: 8){
                //Spacer()
                CalcButtomView(index: 12)
                CalcButtomView(index: 13)
                CalcButtomView(index: 14)
                CalcButtomView(index: 17)
                //Spacer()
            }
            HStack(spacing: 8){
                //Spacer()
                CalcButtomView(index: 18)
                CalcButtomView(index: 19)
                CalcButtomView(index: 20)
                CalcButtomView(index: 23)
                //Spacer()
            }
            HStack(spacing: 8){
                //Spacer()
                CalcButtomView(index: 24)
                CalcButtomView(index: 25)
                CalcButtomView(index: 26)
                CalcButtomView(index: 29)
                //Spacer()
            }
            HStack(spacing: 8){
                //Spacer()
                CalcButtomView(index: 30)
                HStack(spacing: 8){
                    CalcButtomView(index: 31)
                    CalcButtomView(index: 35)
                }
                //Spacer()
            }

        }
    }
    }

struct CalcButtomPadPortrit_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        CalcButtomPortrait().environmentObject(calculator)
        .previewInterfaceOrientation(.portrait)
    }
}
