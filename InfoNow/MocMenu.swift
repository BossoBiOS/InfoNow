//
//  Untitled.swift
//  InfoNow
//
//  Created by Stefan kund on 17/10/2025.
//

import SwiftUI

struct MocMenu: ViewModifier {
    var mocEscapeAction: ()->Void
    @State var rotationAngle = 0.0
    @State var showMocMenu: Bool = false
    func body(content: Content) -> some View {
#if DEBUG
        content
            .onTapGesture(count: 2) {
                showMocMenu = true
            }
            .overlay {
                if showMocMenu {
                    VStack {
                        
                        ForEach(MockRequet.Scenario.allCases) {scenario in
                            Button("Moc: \(scenario.name())", action: {
                                MocManager.shared.addMoc(mocScenario: scenario)
                                mocEscapeAction()
                                showMocMenu.toggle()
                            })
                        }.padding()
                        Button("Cancel", action: {
                            MocManager.shared.stopMocing()
                            mocEscapeAction()
                            showMocMenu.toggle()
                        })
                        .padding()
                    }
                    .foregroundStyle(Color.white)
                    .font(.title)
                    .fontWeight(.bold)
                    .background(RoundedRectangle(cornerRadius: 15).foregroundStyle(Color.black.opacity(0.9)))
                }
            }
        
#endif
    }
}

extension View {
    
    func mocMenu(mocEscapeAction: @escaping ()->Void) -> some View {
        modifier(MocMenu(mocEscapeAction: mocEscapeAction))
    }
    
}
