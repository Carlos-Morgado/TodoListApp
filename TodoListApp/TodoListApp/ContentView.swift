//
//  ContentView.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 30/7/25.
//

import SwiftUI

struct ContentView: View {
    @StateObject var viewModel = TaskViewModel()
    @State private var showingNewTaskSheet = false

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
                
                HStack {
                    Image(systemName: "magnifyingglass")
                        .foregroundColor(.gray)
                    TextField("Buscar...", text: $viewModel.searchText)
                        .textFieldStyle(PlainTextFieldStyle())
                }
                .padding(10)
                .background(Color(.systemGray6))
                .cornerRadius(10)
                
                List {
                    ForEach(viewModel.filteredTasks) { task in
                        TaskRowView(task: task) {
                            viewModel.toggleTask(task)
                        }
                    }
                    .onDelete(perform: viewModel.deleteTask)
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
                                        onDone: { title, description in
                                            viewModel.addNewTask(title: title, description: description)
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

#Preview {
    ContentView()
}
