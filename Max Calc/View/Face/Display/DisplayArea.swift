//
//  DisplayArea.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

enum DisplayAreaEvent {
    case Delete
    case CopyToClipBoard
    case Paste
    case ShowHistory
}

let elSize = 25.0

// display area displays current result
struct DisplayArea: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator
    
    // conformin copy operetion and check value
    @State private var isShowingConfirmation = false
    
    var body: some View {
        HStack {
            
            // history, signals and setup
            DisplaySignals()
            
            // display 2 lines results
            VStack(alignment: .trailing, spacing: 0) {
                Text(calculator.firstLine())
                    .font(.system(size: 100))
                    .minimumScaleFactor(0.1)
                    .lineLimit(1)
                    .foregroundColor(Color("displayForeground"))
                    .frame(maxWidth: .infinity, alignment: .trailing)
                
                let secondLine = calculator.secondLine()
                
                if (secondLine != "") {
                    HStack (spacing: 5) {
                        Text(secondLine)
                            .font(.system(size: 100))
                            .minimumScaleFactor(0.1)
                            .lineLimit(1)
                            .foregroundColor(Color("displayForeground"))
                            .frame(maxWidth: .infinity, alignment: .trailing)
                    }
                }
            }
            .frame(maxWidth: .infinity, alignment: .trailing)
            // copy/paste menu
            .contextMenu {
                Button(action: {
                    self.onDisplayAreaClick(.CopyToClipBoard)
                }) {
                    Text("Copy")
                    Image(systemName: "doc.on.doc")
                }
                Button(action: {
                    self.onDisplayAreaClick(.Paste)
                }) {
                    Text("Paste")
                    Image(systemName: "doc.on.clipboard")
                }
            }
            .alert( "", isPresented: $isShowingConfirmation ) {
            }
        message: {
            Text((UIPasteboard.general.string ?? "Nothing")  + " copied")
        }
        .id(UUID.init())
        }
    }
    
    // callback functoin when user interacts with display area
    private func onDisplayAreaClick(_ event: DisplayAreaEvent) -> Void {
        switch event {
        case .CopyToClipBoard:
            UIPasteboard.general.string = calculator.onCopy()
            isShowingConfirmation = true
        case .Paste:
            let content = UIPasteboard.general.string
            guard content != nil else {
                return
            }
            calculator.onPaste(content!)
        default:
            break
        }
        print(event)
    }
}

struct DisplayArea_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic(
        stateMachine: StateMachine(registers: Registers(
            argument1: Register(op: .plus, line: "12345.67"),
            result: Register(op: .percent, line: "356.76"))))
    
    static var previews: some View {
        Group {
            DisplayArea().environmentObject(calculator)
                .previewInterfaceOrientation(.landscapeLeft)
                .previewDisplayName("DisplayArea: landscape")
            DisplayArea().environmentObject(calculator)
                .previewInterfaceOrientation(.portrait)
                .previewDisplayName("DisplayArea: portrait")
        }
    }
}
