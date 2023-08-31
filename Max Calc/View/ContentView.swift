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
    @Environment(\.scenePhase) var scenePhase
    
    // set device orientation
    func setOrientation() {
        switch UIDevice.current.orientation {
        case .portrait, .faceUp, .faceDown, /*.portraitUpsideDown,*/ .unknown:
            coordinator.isPortrait = true
        default :
            coordinator.isPortrait = false
        }
    }

    let orientationChanged = NotificationCenter.default.publisher(for: UIDevice.orientationDidChangeNotification)
        .makeConnectable()
        .autoconnect()

    var body: some View {
        coordinator.router.view()
        .onChange(of: scenePhase) { newPhase in
            if newPhase == .background {
                calculator.saveWork()
            }
        }
        .onAppear() {
            setOrientation()
        }
        .onReceive(orientationChanged) { _ in
            setOrientation()
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
