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
        // Creamos el contenedor manualmente y lo reusamos para la vista y su viewModel
        let container = try! ModelContainer(for: TaskModel.self)

        WindowGroup {
            ContentView(viewModel: TaskViewModel(context: container.mainContext))
                .modelContainer(container)
        }
    }
}

