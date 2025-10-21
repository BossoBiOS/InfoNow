//
//  MainView_Extention.swift
//  InfoNow
//
//  Created by Stefan kund on 18/10/2025.
//

import Foundation
import UIKit
import SwiftUI

struct RotationEffect: ViewModifier {
    
    @State var rotationAngle = 0.0
    
    func body(content: Content) -> some View {
        content
            .rotationEffect(.degrees(rotationAngle))
            .onAppear {
                withAnimation(.linear(duration: 4).repeatForever(autoreverses: false)) {
                    rotationAngle = 360
                }
            }
            .onDisappear {
                rotationAngle = 0.0
            }
    }
}

extension View {
    func customRotationEffect() -> some View {
        modifier(RotationEffect())
    }
}
