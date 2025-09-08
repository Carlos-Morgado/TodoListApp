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
    var onDelete: () -> Void
    var onEdit: () -> Void
    @State private var showActions = false
    
    var body: some View {
        VStack(spacing: 0) {
            // Hint superior solo esquinas de arriba
            Rectangle()
                .fill(task.isDone ? Color(UIColor.secondarySystemBackground).opacity(0.5) : task.priority.color)
                .frame(height: 6)
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
            
            HStack(spacing: 0) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : Color.secondary)
                    .font(.system(size: 28))
                    .onTapGesture { toggleDone() }
                
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline.weight(.bold))
                        .foregroundColor(task.isDone ? Color.secondary.opacity(0.3) : Color.primary)
                    
                    Text(task.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                        .foregroundColor(task.isDone ? Color.secondary.opacity(0.3) : Color.primary)
                    
                    if !task.taskDescription.isEmpty {
                        Rectangle()
                            .foregroundColor(task.isDone ? Color.secondary.opacity(0.3) : Color.secondary)
                            .frame(maxWidth: 30, maxHeight: 1)
                            .padding(.top, 8)
                        
                        Text(task.taskDescription)
                            .font(.subheadline)
                            .foregroundColor(task.isDone ? Color.secondary.opacity(0.3) : Color.secondary)
                    }
                }
                .padding(.leading, 16)
                
                Spacer()
                
                VStack(spacing: 10) {
                    Button {
                        withAnimation(.spring(response: 0.4, dampingFraction: 0.7)) {
                            showActions.toggle()
                        }
                    } label: {
                        Image(systemName: "ellipsis")
                            .rotationEffect(.degrees(180))
                            .foregroundColor(.gray)
                            .padding(10)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                    
                    if showActions {
                        VStack(spacing: 20) {
                            Button(action: onEdit) {
                                Image(systemName: "square.and.pencil")
                                    .foregroundColor(.blue)
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                            
                            Button(action: onDelete) {
                                Image(systemName: "trash")
                                    .foregroundColor(.red)
                                    .transition(.move(edge: .trailing).combined(with: .opacity))
                            }
                        }
                        .padding(8)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .foregroundColor(Color.gray.opacity(0.2))
                        )
                    }
                }
                                
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 6)
                .fill(task.isDone ? Color(UIColor.secondarySystemBackground).opacity(0.5) : Color(UIColor.secondarySystemBackground))
        )
        .clipShape(RoundedRectangle(cornerRadius: 6))
    }
}


// Helper para redondear solo esquinas específicas
struct RoundedCorner: Shape {
    var radius: CGFloat = .infinity
    var corners: UIRectCorner = .allCorners
    
    func path(in rect: CGRect) -> Path {
        let path = UIBezierPath(
            roundedRect: rect,
            byRoundingCorners: corners,
            cornerRadii: CGSize(width: radius, height: radius)
        )
        return Path(path.cgPath)
    }
}


#Preview {
    TaskRowView(task: TaskModel(title:"Ejemplo de tarea",
                                taskDescription: "Descripción opcional. Este es un ejemplo para ver el tamaño que ocupa un texto descriptivo de la tarea",
                                isDone: false),
                toggleDone: {},
                onDelete: {},
                onEdit: {})
}
