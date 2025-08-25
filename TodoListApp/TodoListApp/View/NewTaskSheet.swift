//
//  NewTaskSheet.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 6/8/25.
//

import SwiftUI

struct NewTaskSheet: View {
    @State private var title: String = ""
    @State private var description: String = ""
    var onDone: (String, String) -> Void
    var onCancel: () -> Void

    var body: some View {
        NavigationView {
            Form {
                Section(header: Text("Título")) {
                    TextField("Introduce el título", text: $title)
                        .multilineTextAlignment(.leading)
                }

                Section(header: Text("Descripción")) {
                    TextEditor(text: $description)
                        .frame(height: 100)
                        
                }
            }
            .navigationTitle("Nueva Tarea")
            .toolbar {
                ToolbarItem(placement: .confirmationAction) {
                    Button("Done") {
                        onDone(title, description)
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        onCancel()
                    }
                }
            }
        }
    }
}

#Preview {
    NewTaskSheet { _, _ in } onCancel: {}
}


