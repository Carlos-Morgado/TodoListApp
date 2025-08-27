//
//  TaskPriority.swift
//  TodoListApp
//
//  Created by Carlos Morgado on 27/8/25.
//

import Foundation
import SwiftUI

enum TaskPriority: String, Codable, CaseIterable, Identifiable {
    case alta, media, baja
    
    var id: Self { self }
    
    var color: Color {
        switch self {
        case .alta: return .red
        case .media: return .orange
        case .baja: return .green
        }
    }
    
    var title: String {
        switch self {
        case .alta: return "Alta"
        case .media: return "Media"
        case .baja: return "Baja"
        }
    }
}
