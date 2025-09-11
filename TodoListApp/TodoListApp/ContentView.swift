//
//  ContentView.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 30/7/25.
//

import SwiftUI
import SwiftData

struct ContentView: View {
    @Query private var tasks: [TaskModel]

    @StateObject private var viewModel: TaskViewModel
    @State private var showingNewTaskSheet = false
    @State private var editingTask: TaskModel? = nil
    @State private var showMenu = false

    init(viewModel: TaskViewModel) {
        _viewModel = StateObject(wrappedValue: viewModel)
    }

    var body: some View {
        let filteredTasks = viewModel.filteredTasks(from: tasks)

        NavigationView {
            ZStack(alignment: .topTrailing) {
                VStack(spacing: 16) {
                    HStack {
                        Text("Todo List")
                            .font(.largeTitle)
                            .fontWeight(.black)
                            .foregroundColor(.blue)
                        Spacer()
                    }
                    
                    HStack {
                        Image(systemName: "magnifyingglass")
                            .foregroundColor(.gray)
                        TextField("Buscar...", text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    if filteredTasks.isEmpty {
                        Spacer()
                        Text("¡Empieza a añadir tus tareas!")
                            .font(.largeTitle)
                            .fontWeight(.heavy)
                            .foregroundColor(Color.primary)
                            .multilineTextAlignment(.center)
                        Image(systemName: "arrow.down")
                            .font(.system(size: 100))
                            .foregroundColor(Color.green)
                            .padding(8)
                    } else {
                        ScrollView {
                            LazyVStack(spacing: 20) {
                                ForEach(filteredTasks) { task in
                                    TaskRowView(
                                        task: task,
                                        toggleDone: { viewModel.toggleDoneTask(task) },
                                        onDelete: { viewModel.deleteTask(task) },
                                        onEdit: { editingTask = task }
                                    )
                                }
                            }
                            .padding(.vertical, 8)
                        }
                    }
                }
                .padding(20)
                
                CustomMenu(
                    isExpanded: $showMenu,
                    highlightSortOption: $viewModel.sortOption,
                    label: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    },
                    menuSections: [
                        MenuSection(
                            title: "Título",
                            options: [
                                MenuOption(title: "Ascendente", icon: "arrow.up", sortOption: .titleAsc),
                                MenuOption(title: "Descendente", icon: "arrow.down", sortOption: .titleDesc)
                            ]
                        ),
                        MenuSection(
                            title: "Fecha",
                            options: [
                                MenuOption(title: "Más recientes", icon: "calendar.badge.clock", sortOption: .dateDesc),
                                MenuOption(title: "Más antiguos", icon: "calendar", sortOption: .dateAsc)
                            ]
                        ),
                        MenuSection(
                            title: "Prioridad",
                            options: [
                                MenuOption(title: "Alta primero", icon: "flag.fill", sortOption: .priorityAsc),
                                MenuOption(title: "Baja primero", icon: "flag", sortOption: .priorityDesc)
                            ]
                        ),
                        MenuSection(
                            title: "Estado",
                            options: [
                                MenuOption(title: "Terminadas", icon: "checkmark.circle", sortOption: .isDone),
                                MenuOption(title: "Pendientes", icon: "circle", sortOption: .notDone)
                            ]
                        )
                    ],
                    optionLabel: { option in
                        Label(option.title, systemImage: option.icon)
                            .foregroundColor(.primary)
                    },
                    onSelect: { option in
                        viewModel.sortOption = option.sortOption
                    }
                )
                .padding(.trailing, 16)
                .padding(.top, 16)
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
            .sheet(item: $editingTask) { task in
                NewTaskSheet(taskToEdit: task) { title, details, priority in
                    viewModel.updateTask(task, title: title, details: details, priority: priority)
                    editingTask = nil
                } onCancel: {
                    editingTask = nil
                }
            }
        }
    }
}

extension ContentView {
    @ViewBuilder
    func filterButton(_ text: String, icon: String, action: @escaping () -> Void) -> some View {
        Button(action: action) {
            HStack {
                Image(systemName: icon)
                    .foregroundColor(.blue)
                Text(text)
                    .foregroundColor(.primary)
                Spacer()
            }
            .padding()
            .background(RoundedRectangle(cornerRadius: 10).fill(Color.gray.opacity(0.1)))
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

