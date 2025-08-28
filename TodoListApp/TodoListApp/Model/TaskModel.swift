//
//  File.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 31/7/25.
//

import Foundation
import SwiftData

@Model
class TaskModel: Identifiable {
    @Attribute(.unique) var id: UUID = UUID()
    var title: String
    var taskDescription: String
    var isDone: Bool
    var priority: TaskPriority
    var createdAt: Date
    
    init(title: String, taskDescription: String, isDone: Bool = false, priority: TaskPriority = .media, createdAt: Date = Date()) {
        self.title = title
        self.taskDescription = taskDescription
        self.isDone = isDone
        self.priority = priority
        self.createdAt = createdAt
    }
}
