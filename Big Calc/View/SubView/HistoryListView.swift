//
//  CalcButtomView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//


import SwiftUI

extension Array where Element: Comparable {

    mutating func unic() -> Array<Element> {
        if self.count < 2 { return  self}
        var first = 0; var last = self.count - 1
        while first < last {
            if self[first] == self[last] {
                self.remove(at: last)
            }
            last -= 1
            if last == first {
                first += 1
                last = self.count - 1
            }
        }
        return self
    }
}

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
                    var res = calculator.history.map{$0.date}
                    return res.unic()
                }
                
                List {
                    ForEach(headers,  id:\.self) { group in
                        Section(header: Text(group)) {
                            
                            var dateGroup : [Registers] {
                                calculator.history.filter {$0.date == group}
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

