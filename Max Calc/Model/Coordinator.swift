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
    @Published var isPortrait : Bool = true

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
