//
//  TaskRowView.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 6/8/25.
//

import SwiftUI

struct TaskRowView: View {
    var task: TaskModel
    var toggleDone: () -> Void

    var body: some View {
        HStack(alignment: .top) {
            Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                .foregroundColor(task.isDone ? .green : .gray)
                .onTapGesture {
                    toggleDone()
                }

            VStack(alignment: .leading, spacing: 4) {
                Text(task.title)
                    .font(.headline)
                    .strikethrough(task.isDone)
                    .foregroundColor(task.isDone ? .gray : .primary)

                if !task.description.isEmpty {
                    Text(task.description)
                        .font(.subheadline)
                        .foregroundColor(.secondary)
                }
            }

            Spacer()
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
    }
}

#Preview {
    TaskRowView(task: TaskModel(title:"Ejemplo de tarea", description: "Descripción opcional", isDone: false),
                toggleDone: {})
}
