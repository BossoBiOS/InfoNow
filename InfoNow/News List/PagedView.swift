//
//  TabsView.swift
//  InfoNow
//
//  Created by Kundius on 21/10/2025.
//

import Foundation
import SwiftUI

struct PagedView<T>: View where T: View {
    @Binding var selection: Int

    let before: (Int) -> Int
    let after: (Int) -> Int
    let maxIndex: Int

    @ViewBuilder let view: (Int) -> T

    @State private var currentTab: Int = 0

    var body: some View {

        let previousIndex = before(selection)
        let nextIndex = after(selection)

        TabView(selection: $currentTab) {
            if previousIndex > -1 {
                view(previousIndex)
                    .tag(-1)
            }

            view(selection)
                .onDisappear() {
                    if currentTab != 0 {
                        selection = currentTab < 0 ? previousIndex : nextIndex
                        currentTab = 0
                    }
                }
                .tag(0)
            if nextIndex < maxIndex {
                view(nextIndex)
                    .tag(1)
            }

        }
        .tabViewStyle(.page(indexDisplayMode: .never))
        .disabled(currentTab != 0)
    }
}
