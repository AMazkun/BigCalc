//
//  ContentView.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct FaceView: View {
    @EnvironmentObject var coordinator: Coordinator
    @EnvironmentObject var calculator : CalculatorLogic

    
    var isPortrait: Bool {
        switch calculator.setupValues.appearence {
            case .Landscape : return false
            case .Portrait : return true
            default: break
        }
        
        return coordinator.isPortrait
    }
    
    
    var body: some View {
        Group {
            if isPortrait {
                PortraitBody()
            } else {
                LandscapeBody()
            }
        }
    }
}

struct FaceView_Previews: PreviewProvider {
    @StateObject static var coordinator = Coordinator.shared
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        FaceView().environmentObject(calculator).environmentObject(coordinator)
    }
}
