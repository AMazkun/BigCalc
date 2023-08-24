//
//  Router.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import Foundation
import SwiftUI

public protocol NavigationRouter {
    
    associatedtype V: View

    var transition: AnyTransition { get }
    
    /// Creates and returns a view of assosiated type
    ///
    @ViewBuilder
    func view() -> V
}

public enum MapRouter: NavigationRouter {
    
    case history
    case variables
    case face
    case setup
    
    public var transition: AnyTransition {
        switch self {
        case .history, .variables, .setup:
            return .slide
        case .face:
            return .opacity
        }
    }
    
    @ViewBuilder
    public func view() -> some View {
        switch self {
        case .face:
            FaceView()//.transition(self.transition)
        case .history:
            HistoryListView().transition(self.transition)
        case .variables:
            VariablesView().transition(self.transition)
        case .setup:
            SetupView().transition(self.transition)
        }
    }

}
