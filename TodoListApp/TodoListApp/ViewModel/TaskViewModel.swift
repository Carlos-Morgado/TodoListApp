//
//  NoteViewModel.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 31/7/25.
//

import Foundation
import SwiftUI
import SwiftData

@MainActor
final class TaskViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var ascendingOrder = true

    private let context: ModelContext

    init(context: ModelContext) {
        self.context = context
    }
    
    var filteredTasks: [TaskModel] {
        let descriptor = FetchDescriptor<TaskModel>(
            predicate: searchText.isEmpty ? nil :
                #Predicate { $0.title.localizedStandardContains(searchText) },
            sortBy: [
                SortDescriptor(\.title, order: ascendingOrder ? .forward : .reverse)
            ]
        )
        
        do {
            return try context.fetch(descriptor)
        } catch {
            print("Error fetching tasks: \(error)")
            return []
        }
    }

    func addNewTask(title: String, details: String) {
        let task = TaskModel(title: title, taskDescription: details)
        context.insert(task)
        try? context.save()
    }

    func toggleTask(_ task: TaskModel) {
        task.isDone.toggle()
        try? context.save()
    }

    func deleteTask(_ task: TaskModel) {
        context.delete(task)
        try? context.save()
    }
}

