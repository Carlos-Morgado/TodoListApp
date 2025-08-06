//
//  File.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 31/7/25.
//

import Foundation

struct TaskModel: Identifiable, Codable {
    let id: String
    var title: String
    var description: String
    var isDone: Bool
    
    init(id: String = UUID().uuidString, title: String, description: String, isDone: Bool = false) {
        self.id = id
        self.title = title
        self.description = description
        self.isDone = isDone
    }
}
