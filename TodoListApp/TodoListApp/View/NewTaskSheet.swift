//
//  NewTaskSheet.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 6/8/25.
//

import SwiftUI

struct NewTaskSheet: View {
    @Binding var title: String
    @Binding var description: String
    var onDone: () -> Void

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
                        onDone()
                    }
                    .disabled(title.trimmingCharacters(in: .whitespaces).isEmpty)
                }

                ToolbarItem(placement: .cancellationAction) {
                    Button("Cancelar") {
                        title = ""
                        description = ""
                        onDone()
                    }
                }
            }
        }
    }
}


struct NewTaskSheet_Previews: PreviewProvider {
    struct PreviewWrapper: View {
        @State private var title = "Título de prueba"
        @State private var description = "Descripción de prueba"

        var body: some View {
            NewTaskSheet(
                title: $title,
                description: $description,
                onDone: {}
            )
        }
    }

    static var previews: some View {
        PreviewWrapper()
    }
}

