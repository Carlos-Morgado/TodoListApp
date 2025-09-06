//
//  NewTaskSheet.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 6/8/25.
//

import SwiftUI

struct NewTaskSheet: View {
    @State private var title: String
    @State private var description: String
    @State private var priorities: TaskPriority

    var taskToEdit: TaskModel?
    var onDone: (String, String, TaskPriority) -> Void
    var onCancel: () -> Void

    init(taskToEdit: TaskModel? = nil,
         onDone: @escaping (String, String, TaskPriority) -> Void,
         onCancel: @escaping () -> Void) {
        self.taskToEdit = taskToEdit
        _title = State(initialValue: taskToEdit?.title ?? "")
        _description = State(initialValue: taskToEdit?.taskDescription ?? "")
        _priorities = State(initialValue: taskToEdit?.priority ?? .media)
        self.onDone = onDone
        self.onCancel = onCancel
    }

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título")) {
                    TextField("Introduce un título obligatorio", text: $title)
                        .multilineTextAlignment(.leading)
                }

                Section(header: Text("Descripción")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        
                }
                
                Section(header: Text("Prioridad")) {
                    HStack(alignment: .center, spacing: 20) {
                        Spacer()
                        
                        ForEach(TaskPriority.allCases) { priority in
                            VStack {
                                RoundedRectangle(cornerRadius: 9)
                                    .fill(priority.color)
                                    .frame(width: 90, height: 30)
                                    .overlay(
                                        RoundedRectangle(cornerRadius: 9)
                                            .stroke(priorities == priority ? Color.primary : .clear, lineWidth: 2)
                                    )
                                    .onTapGesture {
                                        priorities = priority
                                    }
                                Text(priority.title)
                            }
                        }
                    
                        Spacer()
                    }
                }
            }
            .navigationTitle(taskToEdit == nil ? "Nueva Tarea" : "Editar Tarea")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone(title, description, priorities)
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        onCancel()
                    }
                }
            }
        }
    }
}

#Preview {
    NewTaskSheet { _, _, _ in } onCancel: {}
}


