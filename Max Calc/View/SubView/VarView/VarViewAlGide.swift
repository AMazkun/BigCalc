//
//  VariablesView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI


extension HorizontalAlignment {
    enum TwoColumnAlignment: AlignmentID {
        static func defaultValue(in context: ViewDimensions) -> CGFloat {
            context[HorizontalAlignment.center]
        }
    }

    static var twoColumnAlignment: HorizontalAlignment {
        HorizontalAlignment(TwoColumnAlignment.self)
    }
}

struct VarViewAlGide: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        VStack {
            Text("Memory: ").font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            // variables list
            // Using alignmentGuide
            List (calculator.getVariables) { variable in
                if (variable.id > 0) && !String(variable.value).isEmpty {
                    VStack(alignment: .twoColumnAlignment) {
                        HStack {
                            Text( "M\(variable.id): " )
                                .foregroundColor(Color("memoryBackground"))
                                .alignmentGuide(.twoColumnAlignment) { d in
                                    d[.trailing]}
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

struct VarViewAlGide_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic(stateMachine: StateMachine(memory: [
        "", "1324.34", "", "0.245256", "", "14", "", "", "80.93", ""
    ]))

    static var previews: some View {
        VarViewAlGide().environmentObject(calculator).environmentObject(coordinator)
    }
}
