//
//  ContentView.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 30/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    // Para obtener datos con @Query si los necesitas en algún momento
    @Query(sort: \TaskModel.title, order: .forward) private var tasks: [TaskModel]

    @StateObject private var viewModel: TaskViewModel
    @State private var showingNewTaskSheet = false

    // Inicializamos el StateObject con el viewModel que nos pasan desde el App
    init(viewModel: TaskViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }
    
    var filteredTasks: [TaskModel] {
        tasks
            .filter { viewModel.searchText.isEmpty || $0.title.localizedStandardContains(viewModel.searchText) }
            .sorted {
                viewModel.ascendingOrder ? $0.title < $1.title : $0.title > $1.title
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
                        viewModel.ascendingOrder.toggle()
                    } label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.blue)
                            .imageScale(.large)
                            .padding(8)
                            .background(Color.gray.opacity(0.2))
                            .clipShape(Circle())
                    }
                }

                // Barra de búsqueda
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar...", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)

                ScrollView {
                    LazyVStack(spacing: 12) {
                        ForEach(filteredTasks) { task in
                            TaskRowView(
                                task: task,
                                toggleDone: { viewModel.toggleTask(task) },
                                onDelete: { viewModel.deleteTask(task) }
                            )
                            .padding(.horizontal, 16)
                        }
                    }
                    .padding(.vertical, 8)
                }

            }
            .toolbar {
                ToolbarItem(placement: .bottomBar) {
                    HStack {
                        Spacer()
                        Button {
                            showingNewTaskSheet = true
                        } label: {
                            Image(systemName: "plus")
                                .font(.title3)
                                .foregroundColor(.white)
                                .padding(7)
                                .background(Color.blue)
                                .clipShape(Circle())
                                .shadow(radius: 4)
                        }
                        Spacer()
                    }
                }
            }
            .sheet(isPresented: $showingNewTaskSheet) {
                NewTaskSheet { title, details in
                    viewModel.addNewTask(title: title, details: details)
                    showingNewTaskSheet = false
                } onCancel: { showingNewTaskSheet = false }
            }
        }
    }
}


@MainActor
func previewContentView() -> some View {
    let container = try! ModelContainer(for: TaskModel.self)
    let ctx = container.mainContext
    // datos de ejemplo
    let sample = TaskModel(title: "Prueba", taskDescription: "Desc")
    ctx.insert(sample)
    try? ctx.save()

    return ContentView(viewModel: TaskViewModel(context: ctx))
        .modelContainer(container)
}

#Preview {
    previewContentView()
}

