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
    
    var body: some View {
        VStack(spacing: 0) {
            // Hint superior solo esquinas de arriba
            Rectangle()
                .fill(task.isDone ? Color(red: 230/255, green: 230/255, blue: 230/255) : task.priority.color)
                .frame(height: 12)
                .clipShape(RoundedCorner(radius: 12, corners: [.topLeft, .topRight]))
            
            HStack(spacing: 0) {
                Image(systemName: task.isDone ? "checkmark.circle.fill" : "circle")
                    .foregroundColor(task.isDone ? .green : Color(red: 230/255, green: 230/255, blue: 230/255))
                    .font(.system(size: 28))
                    .onTapGesture { toggleDone() }
                
                VStack(alignment: .leading) {
                    Text(task.title)
                        .font(.headline.weight(.bold))
                        .foregroundColor(task.isDone ? Color(red: 230/255, green: 230/255, blue: 230/255) : .primary)
                    
                    Text(task.createdAt.formatted(date: .abbreviated, time: .shortened))
                        .font(.footnote)
                        .foregroundColor(task.isDone ? Color(red: 230/255, green: 230/255, blue: 230/255) : .primary)
                    
                    if !task.taskDescription.isEmpty {
                        Rectangle()
                            .fill(task.isDone ? Color(red: 230/255, green: 230/255, blue: 230/255) : .secondary)
                            .frame(maxWidth: 30, maxHeight: 1)
                            .padding(.top, 8)
                        
                        Text(task.taskDescription)
                            .font(.subheadline)
                            .foregroundColor(task.isDone ? Color(red: 230/255, green: 230/255, blue: 230/255) : .secondary)
                    }
                }
                .padding(.leading, 16)
                
                Spacer()
                
                HStack(spacing: 10) {
                    Button(action: onEdit) {
                        Image(systemName: "square.and.pencil")
                            .foregroundColor(.blue)
                    }
                    Button(action: onDelete) {
                        Image(systemName: "trash")
                            .foregroundColor(.red)
                    }
                }
            }
            .padding(.horizontal, 16)
            .padding(.vertical, 16)
        }
        .background(
            RoundedRectangle(cornerRadius: 12)
                .stroke(task.isDone ? Color(red: 230/255, green: 230/255, blue: 230/255) : task.priority.color, lineWidth: 2)
                .background(Color.white)
        )
        .clipShape(RoundedRectangle(cornerRadius: 12))
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
