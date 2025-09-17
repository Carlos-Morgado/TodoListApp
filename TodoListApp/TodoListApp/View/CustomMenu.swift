//
//  CustomMenu.swift
//  TodoListApp
//
//  Created by Carlos Morgado Alarcón on 9/9/25.
//

import SwiftUI

struct CustomMenu<LabelView: View, OptionView: View>: View {
    @Binding var fullMenuIsExpanded: Bool
    @Binding var highlightSortOption: SortOption
    @State private var expandedSection: UUID? = nil
    let mainMenuButtonlabel: () -> LabelView
    let menuSections: [MenuSection]
    let optionLabel: (MenuOption) -> OptionView
    let onSelectOption: (MenuOption) -> Void

    var body: some View {
        VStack(alignment: .trailing, spacing: 14) {
            Button {
                withAnimation(.spring) { fullMenuIsExpanded.toggle() }
            } label: { mainMenuButtonlabel() }
            
            if fullMenuIsExpanded {
                VStack(alignment: .leading, spacing: 0) {
                    Text("filterMenu_mainTitle")
                        .padding(.vertical, 6)
                        .padding(.horizontal, 12)
                    Rectangle()
                        .fill(Color.blue)
                        .frame(width: 250, height: 1)
                    ForEach(menuSections) { section in
                        let isHighlighted = section.options.contains { $0.sortOption == highlightSortOption }
                        VStack(spacing: 0) {
                            Button {
                                withAnimation(.bouncy) {
                                    expandedSection = expandedSection == section.id ? nil : section.id
                                }
                            } label: {
                                HStack {
                                    Text(section.title)
                                        .font(.headline)
                                    Spacer()
                                    Image(systemName: expandedSection == section.id ? "chevron.up" : "chevron.down")
                                }
                                .padding(.vertical, 12)
                                .padding(.horizontal, 12)
                                .frame(maxWidth: 250, alignment: .leading)
                                .background(isHighlighted ? Color.blue.opacity(0.2) : Color.clear)
                            }
                            .buttonStyle(PlainButtonStyle())

                            if expandedSection == section.id {
                                VStack(spacing: 0) {
                                    ForEach(section.options) { option in
                                        Button {
                                            withAnimation {
                                                onSelectOption(option)
                                                highlightSortOption = option.sortOption
                                                fullMenuIsExpanded = false
                                            }
                                        } label: {
                                            optionLabel(option)
                                                .padding(.vertical, 12)
                                                .padding(.horizontal, 24)
                                                .frame(maxWidth: 250, alignment: .leading)
                                                .background(
                                                    highlightSortOption == option.sortOption
                                                    ? Color.blue.opacity(0.2)
                                                    : Color.clear
                                                )
                                                .contentShape(Rectangle())
                                        }
                                        .buttonStyle(PlainButtonStyle())
                                    }
                                }
                            }
                        }
                    }
                }
                .background(
                    RoundedRectangle(cornerRadius: 8)
                        .fill(Color(UIColor.secondarySystemBackground))
                        .stroke(Color.blue, lineWidth: 2)
                )
                .clipShape(RoundedRectangle(cornerRadius: 8))
                .shadow(radius: 4)
            }
        }
    }
}

// MARK: - Modelos de menú
struct MenuSection: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let options: [MenuOption]
}

struct MenuOption: Identifiable {
    let id = UUID()
    let title: LocalizedStringKey
    let icon: String
    let sortOption: SortOption
}


struct StatefulPreviewWrapper<Value, Content: View>: View {
    @State private var value: Value
    private let content: (Binding<Value>) -> Content

    init(_ value: Value, @ViewBuilder content: @escaping (Binding<Value>) -> Content) {
        self._value = State(initialValue: value)
        self.content = content
    }

    var body: some View {
        content($value)
    }
}

#Preview {
    StatefulPreviewWrapper(false) { expanded in
        StatefulPreviewWrapper(SortOption.titleAsc) { selectedOption in
            CustomMenu(
                fullMenuIsExpanded: expanded,
                highlightSortOption: selectedOption,
                mainMenuButtonlabel: {
                    Image(systemName: "arrow.up.arrow.down")
                        .foregroundColor(.blue)
                        .imageScale(.large)
                        .padding(8)
                        .background(Color.gray.opacity(0.2))
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
                    )
                ],
                optionLabel: { option in
                    Label(option.title, systemImage: option.icon)
                        .foregroundColor(.primary)
                },
                onSelectOption: { option in
                    print("Seleccionado: \(option.title)")
                }
            )
            .padding()
        }
    }
}
