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

struct VariablesView: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        
        Text("Memory: ").font(.title).bold()
            .frame(maxWidth: .infinity, alignment: .leading)
            .padding()
        
        // variables list

//        Using Grid
//        Grid(alignment: .leading) {
//             Text("Memory cell: value")
//             ForEach(calculator.getVariables) { variable in
//                 if (variable.id > 0) && !String(variable.value).isEmpty {
//                     GridRow {
//                         Text( "M\(variable.id): " )
//                             .foregroundColor(Color("memoryBackground"))
//                         Text(variable.value)
//                             .bold()
//                             .foregroundColor(Color("displayForeground"))
//                     }
//                     .padding()
//                     .onTapGesture {
//                         calculator.onPaste(variable.value)
//                         coordinator.event(.VariablesDismiss)
//                     }
//                 }
//             }
//         }
//         .padding()

//      Using alignmentGuide
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
        
//        List(calculator.getVariables) { variable in
//            if (variable.id > 0) && !String(variable.value).isEmpty {
//                HStack {
//                    Text( "M\(variable.id): " )
//                        .foregroundColor(Color("memoryBackground"))
//                        .frame(maxWidth: 50, alignment: .trailing)
//                    Text(variable.value)
//                        .bold()
//                        .frame(maxWidth: .infinity, alignment: .trailing)
//                        .foregroundColor(Color("displayForeground"))
//                    Spacer()
//                }
//                .padding()
//                .onTapGesture {
//                    calculator.onPaste(variable.value)
//                    coordinator.event(.VariablesDismiss)
//                }
//            }
//        }
//        .listStyle(.plain)
        
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
