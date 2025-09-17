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
            ZStack {
                Color(.systemBackground)
                    .ignoresSafeArea()
                VStack(alignment: .leading, spacing: 25) {
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("newTaskSheet_label_title")
                            .font(.headline)
                        TextField("newTaskSheet_placeholder_title", text: $title)
                            .multilineTextAlignment(.leading)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                            .overlay(
                                RoundedRectangle(cornerRadius: 12)
                                    .stroke(title.trimmingCharacters(in: .whitespaces).isEmpty ? Color.red : Color.clear, lineWidth: 1)
                            )
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("newTaskSheet_label_description")
                            .font(.headline)
                        TextField("newTaskSheet_placeholder_description", text: $description, axis: .vertical)
                            .lineLimit(3...6)
                            .padding(8)
                            .background(
                                RoundedRectangle(cornerRadius: 12)
                                    .fill(Color(UIColor.secondarySystemBackground))
                            )
                    }
                    
                    Divider()
                    
                    VStack(alignment: .leading, spacing: 10) {
                        Text("newTaskSheet_label_priority")
                            .font(.headline)
                            .foregroundColor(.primary)
                        HStack(spacing: 20) {
                            ForEach(TaskPriority.allCases) { priority in
                                VStack(spacing: 10) {
                                    ZStack {
                                        Circle()
                                            .fill(priority.color)
                                            .frame(width: 50, height: 50)
                                            .scaleEffect(priorities == priority ? 1.3 : 1.0)
                                            .shadow(color: priorities == priority ? priority.color.opacity(0.6) : .clear,
                                                    radius: 6, x: 0, y: 3)
                                            .animation(.spring(response: 0.3, dampingFraction: 0.6), value: priorities)
                                            .onTapGesture {
                                                priorities = priority
                                            }
                                        
                                        if priorities == priority {
                                            Image(systemName: "checkmark")
                                                .font(.headline.bold())
                                                .foregroundColor(.white)
                                                .transition(.scale)
                                        }
                                    }
                                    
                                    Text(priority.title)
                                        .font(.caption.bold())
                                        .foregroundColor(priorities == priority ? priority.color : .secondary)
                                }
                            }
                        }
                        .padding(.vertical, 12)

                    }
                    Spacer()
                    
                }.padding(20)
            }
            .navigationTitle(taskToEdit == nil ? "newTaskSheet_navigation_newTask" : "newTaskSheet_navigation_editTask")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("newTaskSheet_button_done") {
                        onDone(title, description, priorities)
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("newTaskSheet_button_cancel") {
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


