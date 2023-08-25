//
//  CalcButtomView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//


import SwiftUI

struct HistoryListView: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    @State private var newItem = ""
    var body: some View {
        VStack (alignment: .leading) {
            Text("History:").font(.title).bold()
                .padding()
            
            if calculator.historyNotEmpty {
                
                var headers : [String] {
                    Array(Set(calculator.stateMachine.history.map{$0.date}))
                }
                
                List {
                    ForEach(headers,  id:\.self) { group in
                        Section(header: Text(group)) {
                            
                            var dateGroup : [Registers] {
                                calculator.stateMachine.history.filter {$0.date == group}
                            }
                            
                            ForEach(dateGroup, id:\.self)
                            { item in
                                // display the view of matchItem
                                VStack{
                                    Text(calculator.showCalcExpression(item))
                                        .frame(maxWidth: .infinity, alignment: .trailing)

                                    Text( "= " + calculator.displayFormatter(item.result.line))
                                        .font(.title)
                                        .foregroundColor(.yellow)
                                        .frame(maxWidth: .infinity, alignment: .trailing)
                                }
                                .onTapGesture {
                                    calculator.onPaste(item.result.line)
                                    coordinator.event(.HistoryDismiss)
                                }
                            }
                        }
                    }
                }
                .listStyle(.plain)
            } else {
                Text("History is empty")
                Image("emptylist")
                    .resizable()
                    .scaledToFit()
            }
            
            Spacer()
            
            // Bottom buttons
            HStack {
                Spacer()
                
                if calculator.historyNotEmpty {
                    Button("clear") { calculator.removeHistory();  coordinator.event(.HistoryDismiss)}
                        .tint(.red)
                        .controlSize(.regular) // .large, .regular or .small
                        .buttonStyle(.borderedProminent)
                    
                    Spacer()
                }
                
                Button("dismiss") { coordinator.event(.HistoryDismiss) }
                Spacer()
            }
            .padding(25)
        }
    }
}

