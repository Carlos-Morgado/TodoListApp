//
//  NoteViewModel.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 31/7/25.
//

import Foundation
import SwiftUI

final class TaskViewModel: ObservableObject {
    @Published var tasks: [TaskModel] = (1...5).map { TaskModel(title: "Tarea \($0)", description: "Descripción") }
    @Published var searchText: String = ""
    @Published var ascendingOrder = true
    @Published private var newTitle = ""
    @Published private var newDescription = ""

    var filteredTasks: [TaskModel] {
        tasks
            .filter { searchText.isEmpty || $0.title.lowercased().contains(searchText.lowercased()) }
            .sorted {
                ascendingOrder ? $0.title < $1.title : $0.title > $1.title
            }
    }

    func addNewTask(title: String, description: String) {
        let trimmedTitle = title.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }

        let task = TaskModel(title: trimmedTitle, description: description)
        tasks.append(task)
    }

    func toggleTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}
