//
//  ExpenseTrackerAppApp.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI
import CoreData

@main
struct ExpenseTrackerAppApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainTabView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
