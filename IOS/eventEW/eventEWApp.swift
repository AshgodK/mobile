//
//  eventEWApp.swift
//  eventEW
//
//  Created by Mac Mini on 22/11/2023.
//

import SwiftUI

@main
struct eventEWApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            ContentView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
        }
    }
}
