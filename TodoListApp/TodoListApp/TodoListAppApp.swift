//
//  TodoListAppApp.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 30/7/25.
//

import SwiftUI
import SwiftData

@main
struct TodoListAppApp: App {
    var body: some Scene {
        // Definimos el esquema con los modelos que queremos guardar
        let schema = Schema([TaskModel.self, UserPreferences.self])
        let config = ModelConfiguration(schema: schema)
        let container = try! ModelContainer(for: schema, configurations: config)

        WindowGroup {
            ContentView(viewModel: TaskViewModel(context: container.mainContext))
                .modelContainer(container)
        }
    }
}

