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

    private var columns: [GridItem] = [
        GridItem(.fixed(50), spacing: 16, alignment: .leading),
        GridItem(.flexible(), alignment: .trailing)]
    
    var body: some View {
        
        Text("Memory: ").font(.title).bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()

        // variables list
        List(calculator.getVariables) { variable in
            if (variable.id > 0) && !String(variable.value).isEmpty {
                HStack {
                    Text( "M\(variable.id): " )
                        .foregroundColor(Color("memoryBackground"))
                        .frame(maxWidth: 50, alignment: .trailing)
                    Text(variable.value)
                        .bold()
                        .frame(maxWidth: .infinity, alignment: .trailing)
                        .foregroundColor(Color("displayForeground"))
                    Spacer()
                }
                .padding()
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
