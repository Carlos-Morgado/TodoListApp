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
    @Query private var tasks: [TaskModel]

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
        let filteredTasks = viewModel.filteredTasks(from: tasks)
        NavigationView {
            VStack(spacing: 16) {
                HStack {
                    Text("Todo List")
                        .font(.largeTitle)
                        .fontWeight(.black)
                        .foregroundColor(.blue)
                    Spacer()

                    Menu {
                        // Ordenar por título
                        Menu("Título") {
                            
                            Button {
                                viewModel.sortOption = .titleAsc
                            } label: {
                                Label("Ascendente", systemImage: "arrow.up")
                            }
                           
                            Button {
                                viewModel.sortOption = .titleDesc
                            } label: {
                                Label("Descendente", systemImage: "arrow.down")
                            }
                        }
                       
                        // Ordenar por fecha
                        Menu("Fecha de creación") {
                            
                            Button {
                                viewModel.sortOption = .dateAsc
                            } label: {
                                Label("Más antiguos primero", systemImage: "calendar")
                            }
                           
                            Button {
                                viewModel.sortOption = .dateDesc
                            } label: {
                                Label("Más recientes primero", systemImage: "calendar.badge.clock")
                            }
                        }
                       
                        // Ordenar por prioridad
                        Menu("Prioridad") {
                            
                            Button {
                                //  viewModel.sortOption = .priorityAsc
                            } label: {
                                Label("Alta a baja", systemImage: "flag")
                            }
                            
                            Button {
                                //    viewModel.sortOption = .priorityDesc
                            } label: {
                                Label("Baja a alta", systemImage: "flag.fill")
                            }
                        }
                        
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
                                toggleDone: { viewModel.toggleDoneTask(task) },
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
                NewTaskSheet { title, details, priority in
                    viewModel.addNewTask(title: title, details: details, priority: priority)
                    showingNewTaskSheet = false
                } onCancel: { showingNewTaskSheet = false }
            }
        }
    }
}

@MainActor
func previewContentView() -> some View {
    let config = ModelConfiguration(isStoredInMemoryOnly: true)
    let container = try! ModelContainer(for: TaskModel.self, configurations: config)
    let context = container.mainContext
    
    // datos de ejemplo
    let sample = TaskModel(title: "Título de prueba", taskDescription: "Descripción de prueba", priority: .alta)
    context.insert(sample)
    try? context.save()

    return ContentView(viewModel: TaskViewModel(context: context))
        .modelContainer(container)
}

#Preview {
    previewContentView()
}

