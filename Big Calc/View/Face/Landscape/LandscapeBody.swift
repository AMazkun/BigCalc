//
//  LandscapeBody.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct LandscapeBody: View {
    @EnvironmentObject var calculator : CalculatorLogic

    var body: some View {
        GeometryReader { geometry in
            let displayHeight = geometry.size.height / 3.0
            let buttonsHeight = geometry.size.height  - displayHeight
            Color.black.edgesIgnoringSafeArea(.all)
            VStack(alignment: .trailing, spacing: 5.0){
                DisplayArea()
                    .frame(height: displayHeight, alignment: .topTrailing)
                CalcButtomLandscape()
                    .frame(height: buttonsHeight, alignment: .bottomTrailing)
            }
        }
    }
}

struct LandscapeBody_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic()
    static var previews: some View {
        LandscapeBody().environmentObject(calculator)
            .previewInterfaceOrientation(.landscapeRight)
    }
}
