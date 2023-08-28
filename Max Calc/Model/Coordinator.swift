//
//  Coordinator.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

enum CoordinatorEvent {
    case HistoryDismiss
    case ShowHistory
    
    case VariablesDismiss
    case ShowVariables
    
    case SetupDismiss
    case ShowSetup
}

final class Coordinator: ObservableObject {
    static let shared = Coordinator()

    @Published var router: MapRouter
    @Published var orientation : UIDeviceOrientation = UIDevice.current.orientation

    var isPortrait : Bool {
        if orientation == .unknown {
            return [.portrait, .faceUp, .faceDown, .portraitUpsideDown, .unknown]
                .contains(UIDevice.current.orientation)
        } else {
            return [.portrait, .faceUp, .faceDown, .portraitUpsideDown, .unknown]
                .contains(orientation)
        }
    }

    public init( router: MapRouter = .face) {
        self.router = router
    }
    
    func event( _ event: CoordinatorEvent ) {
        withAnimation {
            switch event {
            case .ShowHistory:      router = .history
            case .ShowVariables:    router = .variables
            case .ShowSetup:        router = .setup
            default:
                router = .face
            }
        }
    }
    

}
