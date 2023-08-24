//
//  DisplaySignals.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct DisplaySignals: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        VStack {
            
            //SETUP
            ZStack {
                Image(systemName: "gearshape")
                    .resizable()
                    .scaledToFit()
                    .frame(width: elSize, height: elSize)
                    .foregroundColor(.gray)
                    .opacity(0.85)
                
                if calculator.setupValues.forceDP || calculator.setupValues.allowEE{
                    Text(calculator.setupValues.forceDP ? "FX" : "EE")
                        .font(.system(size: elSize / 2 )).bold()
                        .lineLimit(1)
                        .foregroundColor(.white)
                        .frame(width: elSize * 1.2, height: elSize * 1.2, alignment: .bottomTrailing)
                }
            }
            .onTapGesture {
                coordinator.event(.ShowSetup)
            }
            Spacer()
            
            // SHOW HISTORY
            Button (
                action: {coordinator.event(.ShowHistory)},
                label:{
                    Image(systemName: "arrowshape.turn.up.backward.badge.clock.fill")
                        .resizable()
                        .scaledToFit()
                        .frame(width: elSize, height: elSize)
                        .foregroundColor(.blue)
                        .opacity(calculator.historyNotEmpty ? 1 : 0)
                    //.rotationEffect(.degrees(90))
                }
            )
            Spacer()
            
            // MEMORY OPERATIONS
            let opMemSign = calculator.stateMachine.stateStack.state.getMemoryOpSign
            Text(opMemSign)
                .font(.system(size: elSize / 2.2 )).bold()
                .lineLimit(1)
                .foregroundColor(.white)
                .frame(width: elSize, height: elSize, alignment: .center)
                .background(RoundedRectangle(cornerRadius: 4).fill(.blue))
                .opacity(opMemSign == "" ? 0 : 1)
            Spacer()
            
            // ERROR
            Button (
                action: {},
                label:{
                    Image(systemName: "e.square")
                        .resizable()
                        .scaledToFit()
                        .frame(width: elSize, height: elSize)
                        .foregroundColor(.red)
                        .opacity(calculator.errorState ? 1 : 0)
                }
            )
            Spacer()
            
        }
        .padding(3)
    }
}

struct DisplaySignals_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic(stateMachine: StateMachine(registers: Registers(argument1: Register(op: .plus, line: "12345.67"), result: Register(op: .percent, line: "356.76"))))
    
    static var previews: some View {
        DisplaySignals().environmentObject(calculator).environmentObject(coordinator)
    }
}
