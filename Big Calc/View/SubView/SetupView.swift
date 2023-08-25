//
//  SetupView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct SetupView: View {
    @EnvironmentObject var calculator : CalculatorLogic
    @EnvironmentObject var coordinator: Coordinator

    var body: some View {
        VStack  {
            Text("Setup:").font(.title).bold()
                .frame(maxWidth: .infinity, alignment: .leading)
                .padding()
            
            Form {
                Picker("Appearence", selection: $calculator.setupValues.appearence) {
                    Text("Automatic").tag(Appearence.Automatic)
                    Text("Portrait").tag(Appearence.Portrait)
                    Text("Landscape").tag(Appearence.Landscape)
                }
                
                Picker("Show expression", selection: $calculator.setupValues.showExpression) {
                    Text("Automatic").tag(ShowExpression.Automatic)
                    Text("Never").tag(ShowExpression.Never)
                    Text("Always").tag(ShowExpression.Always)
                }
                
                Section( header: Text("Fixed format")) {
                    Section { // fixed digital places
                        Stepper(value: $calculator.setupValues.dp, in: 0...maxDigits) {
                            Text("Fixed digital places: " + String(calculator.setupValues.dp))}
                        
                        Toggle("Force fixed dp", isOn: $calculator.setupValues.forceDP)
                            .onChange(of: self.calculator.setupValues.forceDP ){ newValue in calculator.setupValues.allowEE = !newValue && calculator.setupValues.allowEE }
                    }
                }
                
                // engeneering format
                Section( header: Text("Engineering format")) {
                    if !calculator.setupValues.forceDP {
                        
                        Toggle("Allow EE format", isOn: $calculator.setupValues.allowEE)
                        
                        if calculator.setupValues.allowEE {
                            Stepper(value: $calculator.setupValues.dpEE, in: 1...maxDigits) {
                                Text("EE digital places: " + String(calculator.setupValues.dpEE))}
                        }
                    }
                }
            }
            
            Spacer()
            // Botton menu
            HStack {
                Spacer()
                Button("dismiss") {
                    calculator.setupValues.save()
                    coordinator.event(.SetupDismiss)
                }
                    .buttonStyle(.borderedProminent)
                Spacer()
            }
            .padding(.bottom)
        }
    }
}

struct Setup_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        SetupView().environmentObject(calculator).environmentObject(coordinator)
    }
}
