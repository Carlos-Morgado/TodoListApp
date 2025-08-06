//
//  ContentView.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 30/7/25.
//

import SwiftUI

struct ContentView: View {
    @State private var tasks: [TaskModel] = (1...5).map { TaskModel(title: "Tarea \($0)", description: "Descripción") }
    @State private var searchText: String = ""
    @State private var ascendingOrder = true
    
    @State private var showingNewTaskSheet = false
    @State private var newTitle = ""
    @State private var newDescription = ""

    var filteredTasks: [TaskModel] {
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
                        TaskRowView(task: task) {
                            toggleTask(task)
                        }
                    }
                    .onDelete(perform: deleteTask)
                }
                .listStyle(.plain)
            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        
                        Button(action: {
                            showingNewTaskSheet = true
                        }) {
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                                .sheet(isPresented: $showingNewTaskSheet) {
                                    NewTaskSheet(
                                        title: $newTitle,
                                        description: $newDescription,
                                        onDone: {
                                            addNewTask()
                                            showingNewTaskSheet = false
                                        }
                                    )
                                }
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
    
    func toggleTask(_ task: TaskModel) {
        if let index = tasks.firstIndex(where: { $0.id == task.id }) {
            tasks[index].isDone.toggle()
        }
    }

    func deleteTask(at offsets: IndexSet) {
        tasks.remove(atOffsets: offsets)
    }
    
    func addNewTask() {
        let trimmedTitle = newTitle.trimmingCharacters(in: .whitespaces)
        guard !trimmedTitle.isEmpty else { return }

        let task = TaskModel(title: trimmedTitle, description: newDescription)
        tasks.append(task)

        // Reset campos
        newTitle = ""
        newDescription = ""
    }
}


#Preview {
    ContentView()
}
