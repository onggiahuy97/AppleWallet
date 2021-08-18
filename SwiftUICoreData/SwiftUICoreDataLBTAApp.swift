//
//  SwiftUICoreDataLBTAApp.swift
//  SwiftUICoreDataLBTA
//
//  Created by Huy Ong on 7/20/21.
//

import SwiftUI

@main
struct SwiftUICoreDataLBTAApp: App {
    let persistenceController = PersistenceController.shared

    var body: some Scene {
        WindowGroup {
            MainView()
                .environment(\.managedObjectContext, persistenceController.container.viewContext)
//            PlaygroundSwiftUI()
        }
    }
}
