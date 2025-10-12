//
//  InfoNowApp.swift
//  InfoNow
//
//  Created by Stefan kund on 12/10/2025.
//

import SwiftUI
import CoreData

@main
struct InfoNowApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
