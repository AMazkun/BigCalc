//
//  VarViewGrid.swift
//  Max Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct VarViewGrid: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Memory: ").font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            // variables list
            // Using Grid
            Grid(alignment: .leading) {
                Text("Memory cell: value")
                ForEach(calculator.getVariables) { variable in
                    if (variable.id > 0) && !String(variable.value).isEmpty {
                        GridRow {
                            Text( "M\(variable.id): " )
                                .foregroundColor(Color("memoryBackground"))
                            Text(variable.value)
                                .bold()
                                .foregroundColor(Color("displayForeground"))
                        }
                        .padding()
                        .onTapGesture {
                            calculator.onPaste(variable.value)
                            coordinator.event(.VariablesDismiss)
                        }
                    }
                }
            }
            .frame(maxHeight: .infinity,  alignment: .top)

            
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
}

struct VarViewGrid_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic(stateMachine: StateMachine(memory: [
        "", "1324.34", "", "0.245256", "", "14", "", "", "80.93", ""
    ]))

    static var previews: some View {
        VarViewGrid().environmentObject(calculator).environmentObject(coordinator)
    }
}
