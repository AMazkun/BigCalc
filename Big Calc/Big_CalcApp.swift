//
//  Big_CalcApp.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI


@main
struct Big_CalcApp: App {
    @StateObject var coordinator = Coordinator.shared
    @StateObject var calculator = CalculatorLogic()
    
    var body: some Scene {
        WindowGroup {
            ContentView().environmentObject(calculator).environmentObject(coordinator)
        }
    }
}
