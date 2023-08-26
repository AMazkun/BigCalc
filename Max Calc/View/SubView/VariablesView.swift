//
//  VariablesView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI


struct VariablesView: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        
        Text("Variables: ").font(.title).bold()
            .padding()

        // variables list
        List(calculator.getVariables) { variable in
            if (variable.id > 0) && !String(variable.value).isEmpty {
                HStack {
                    Text( String(variable.id) + ": " )
                    Text(variable.value)
                }
                .onTapGesture {
                    calculator.onPaste(variable.value)
                    coordinator.event(.VariablesDismiss)
                }
            }
        }
        .listStyle(.plain)
        
        // Botton menu
        HStack {
            Spacer()
            Button("clear ALL") { calculator.clearMemory();  coordinator.event(.VariablesDismiss)}
                .tint(.red)
                .controlSize(.regular) // .large, .regular or .small
                .buttonStyle(.borderedProminent)
            
            Spacer()
            
            Button("dismiss") { coordinator.event(.VariablesDismiss) }
            .buttonStyle(.borderedProminent)

            Spacer()
        }
        .padding(.bottom)
    }
}

struct VariablesView_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        VariablesView().environmentObject(calculator).environmentObject(coordinator)
    }
}
