//
//  VarViewClassic.swift
//  Max Calc
//
//  Created by Anatoly Mazkun on 18.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct VarViewClassic: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
            VStack {
                Text("Memory: ").font(.title).bold()
                    .frame(maxWidth: .infinity, alignment: .leading)
                    //.foregroundColor(Color("buttomForeground"))x
                    .padding()
                
                
                List(calculator.getVariables) { variable in
                    if (variable.id > 0) && !String(variable.value).isEmpty {
                        HStack {
                            Text( "M\(variable.id): " )
                                .foregroundColor(Color("memoryBackground"))
                                .frame(maxWidth: 50, alignment: .trailing)
                            Text(variable.value)
                                .bold()
                                .frame(maxWidth: .infinity, alignment: .trailing)
                                .foregroundColor(Color("operatorBackground"))
                            Spacer()
                        }
                        //.background(.black)
                        //.listRowBackground(Color.black)
                        .padding()
                        .onTapGesture {
                            calculator.onPaste(variable.value)
                            coordinator.event(.VariablesDismiss)
                        }
                    }
                }
                //.background(.pink)
                //.scrollContentBackground(.hidden)
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
}

struct VarViewClassic_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic(stateMachine: StateMachine(memory: [
        "", "1324.34", "", "0.245256", "", "14", "", "", "80.93", ""
    ]))

    static var previews: some View {
        VarViewClassic().environmentObject(calculator).environmentObject(coordinator)
    }
}
