//
//  NewTaskSheet.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 6/8/25.
//

import SwiftUI

struct NewTaskSheet: View {
    @State private var title: String = ""
    @State private var description: String = ""
    @State private var priorities: TaskPriority = .media
    
    var onDone: (String, String, TaskPriority) -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título")) {
                    TextField("Introduce el título", text: $title)
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
            .navigationTitle("Nueva Tarea")
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


