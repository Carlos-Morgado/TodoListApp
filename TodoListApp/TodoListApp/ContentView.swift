//
//  ContentView.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 30/7/25.
//

import SwiftUI

struct Task: Identifiable {
    let id = UUID()
    var title: String
    var isCompleted: Bool = false
}

struct ContentView: View {
    @State private var tasks: [Task] = (1...20).map { Task(title: "Tarea \($0)") }
    @State private var searchText: String = ""
    @State private var ascendingOrder = true

    var filteredTasks: [Task] {
        tasks
            .filter { searchText.isEmpty || $0.title.lowercased().contains(searchText.lowercased()) }
            .sorted {
                ascendingOrder ? $0.title < $1.title : $0.title > $1.title
            }
    }

    var body: some View {
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Text("Todo List")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.blue)
                    Spacer()
                    Button {
                        ascendingOrder.toggle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar...", text: $searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                List {
                    ForEach(filteredTasks) { task in
                        HStack {
                            Image(systemName: task.isCompleted ? "checkmark.circle.fill" : "circle")
                                .foregroundColor(task.isCompleted ? .green : .gray)
                                .onTapGesture {
                                    toggleTask(task)
                                }
                            
                            Text(task.title)
                                .strikethrough(task.isCompleted)
                                .foregroundColor(task.isCompleted ? .gray : .primary)
                        }
                        .contentShape(Rectangle())
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(.plain )
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            // Acción del botón
                        }) {
                            Image(systemName: "plus")
                                .font(.title3) // Tamaño del ícono
                                .foregroundColor(.white)
                                .padding(7) // Aumenta tamaño del círculo
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }

                        Spacer()
                    }
                    .frame(maxWidth: .infinity)
                }
            }
        }
    }
}

// MARK: - Extensions

extension ContentView {
    
    func toggleTask(_ task: Task) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isCompleted.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
}


#Preview {
    ContentView()
}
