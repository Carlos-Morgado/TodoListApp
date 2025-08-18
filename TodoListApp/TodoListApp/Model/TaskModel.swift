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
    
    init(title: String, taskDescription: String, isDone: Bool = false) {
        self.title = title
        self.taskDescription = taskDescription
        self.isDone = isDone
    }
}
