//
//  NoteViewModel.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 31/7/25.
//

import Foundation
import SwiftUI
import SwiftData

enum SortOption: String, Codable {
    case titleAsc, titleDesc
    case dateAsc, dateDesc
    case priorityAsc, priorityDesc
}

@MainActor
final class TaskViewModel: ObservableObject {
    @Published var searchText = ""
    @Published var ascendingOrder = true
    @Published var sortOption: SortOption {
            didSet {
                saveSortOption()
            }
        }

    private let context: ModelContext
    private var preferences: UserPreferences?

    init(context: ModelContext) {
        self.context = context
        let descriptor = FetchDescriptor<UserPreferences>()
           if let preference = try? context.fetch(descriptor).first {
               self.preferences = preference
               self.sortOption = SortOption(rawValue: preference.sortOption) ?? .titleAsc
           } else {
               let newPreference = UserPreferences()
               context.insert(newPreference)
               try? context.save()
               self.preferences = newPreference
               self.sortOption = .titleAsc
           }
    }
    
    func filteredTasks(from tasks: [TaskModel]) -> [TaskModel] {
        let text = searchText.trimmingCharacters(in: .whitespacesAndNewlines)
        let base = tasks.filter { text.isEmpty || $0.title.localizedStandardContains(text) }
        switch sortOption {
        case .titleAsc:
            return base.sorted { $0.title.localizedCompare($1.title) == .orderedAscending }
        case .titleDesc:
            return base.sorted { $0.title.localizedCompare($1.title) == .orderedDescending }
        case .dateAsc:
            return base.sorted { $0.createdAt < $1.createdAt }
        case .dateDesc:
            return base.sorted { $0.createdAt > $1.createdAt }
        case .priorityAsc:
            return base.sorted { $0.priority.rank < $1.priority.rank }
        case .priorityDesc:
            return base.sorted { $0.priority.rank > $1.priority.rank }
        }
    }
    
    private func saveSortOption() {
        preferences?.sortOption = sortOption.rawValue
        try? context.save()
    }

    func addNewTask(title: String, details: String, priority: TaskPriority) {
        let task = TaskModel(title: title, taskDescription: details, priority: priority)
        context.insert(task)
        try? context.save()
    }

    func toggleDoneTask(_ task: TaskModel) {
        task.isDone.toggle()
        try? context.save()
    }

    func deleteTask(_ task: TaskModel) {
        context.delete(task)
        try? context.save()
    }
    
    func updateTask(_ task: TaskModel, title: String, details: String, priority: TaskPriority) {
        task.title = title
        task.taskDescription = details
        task.priority = priority
        try? context.save()
    }
}

