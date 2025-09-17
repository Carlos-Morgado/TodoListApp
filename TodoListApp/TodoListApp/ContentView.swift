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
                        TextField("mainView_textField_searchTask", text: $viewModel.searchText)
                            .textFieldStyle(PlainTextFieldStyle())
                    }
                    .padding(10)
                    .background(Color(.systemGray6))
                    .cornerRadius(10)

                    if filteredTasks.isEmpty {
                        Spacer()
                        Text("mainView_emptyTasksList_getStart")
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
                    fullMenuIsExpanded: $showMenu,
                    highlightSortOption: $viewModel.sortOption,
                    mainMenuButtonlabel: {
                        Image(systemName: "arrow.up.arrow.down")
                            .foregroundColor(.white)
                            .imageScale(.large)
                            .padding(8)
                            .background(Color.blue)
                            .clipShape(Circle())
                    },
                    menuSections: [
                        MenuSection(
                            title: "filterMenu_titleSection",
                            options: [
                                MenuOption(title: "filterMenu_ascendantOption", icon: "arrow.up", sortOption: .titleAsc),
                                MenuOption(title: "filterMenu_descendantOption", icon: "arrow.down", sortOption: .titleDesc)
                            ]
                        ),
                        MenuSection(
                            title: "filterMenu_dateSection",
                            options: [
                                MenuOption(title: "filterMenu_mostRecentOption", icon: "calendar.badge.clock", sortOption: .dateDesc),
                                MenuOption(title: "filterMenu_olderOption", icon: "calendar", sortOption: .dateAsc)
                            ]
                        ),
                        MenuSection(
                            title: "filterMenu_prioritySection",
                            options: [
                                MenuOption(title: "filterMenu_highPriorityOption", icon: "flag.fill", sortOption: .priorityAsc),
                                MenuOption(title: "filterMenu_lowPriorityOption", icon: "flag", sortOption: .priorityDesc)
                            ]
                        ),
                        MenuSection(
                            title: "filterMenu_stateSection",
                            options: [
                                MenuOption(title: "filterMenu_doneStateOption", icon: "checkmark.circle", sortOption: .isDone),
                                MenuOption(title: "filterMenu_pendingStateOption", icon: "circle", sortOption: .notDone)
                            ]
                        )
                    ],
                    optionLabel: { option in
                        Label(option.title, systemImage: option.icon)
                            .foregroundColor(.primary)
                    },
                    onSelectOption: { option in
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

