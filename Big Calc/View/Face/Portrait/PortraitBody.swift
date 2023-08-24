//
//  PortraitBody.swift
//  Big Calc
//
//  Created by Anatoly Mazkun on 13.08.2023.
//  anatoly.mazkun@gmail.com
//

import SwiftUI

struct PortraitBody: View {
    
    @EnvironmentObject var calculator : CalculatorLogic

    var body: some View {
        GeometryReader { geometry in
            let displayHeight = geometry.size.height / 4.0
            
            Color.black.edgesIgnoringSafeArea(.all)
            
            VStack(alignment: .trailing, spacing: 5.0){
                DisplayArea()
                    .frame(maxWidth: .infinity, maxHeight: displayHeight, alignment: .leading) //<-- Here

                CalcButtomPortrait()
            }
        }
    }
}


struct PortraitBody_Previews: PreviewProvider {
    @StateObject static var calculator = CalculatorLogic()

    static var previews: some View {
        PortraitBody().environmentObject(calculator)
        .previewInterfaceOrientation(.portrait)
    }
}
