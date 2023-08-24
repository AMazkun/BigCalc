//
//  ContentView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct ContentView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var calculator : CalculatorLogic

    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()

    var body: some View {
        coordinator.router.view()
        .onReceive(orientationChanged)
        { _ in
            let _orientation = UIDevice.current.orientation
            if ![.faceUp, .faceDown, .portraitUpsideDown, .unknown]
                 .contains(_orientation) {
                coordinator.orientation = _orientation
            }
        }
    }
}

struct ContentView_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        ContentView().environmentObject(calculator).environmentObject(coordinator)
    }
}
