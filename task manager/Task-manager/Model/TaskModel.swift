//  Model.swift
//  Task-manager
//
//  Created by Anastasia on 20.11.2026.
//

import Foundation

enum Priority {
    case high
    case medium
    case low
}

struct TaskModel: Identifiable {
    
    let id: UUID
    let title: String
    let description: String
    let createdAt: Date
    let priority: Priority
    var isDone: Bool
    
    init(
        id: UUID = UUID(),
        title: String,
        description: String,
        createdAt: Date = Date(),
        priority: Priority,
        isDone: Bool = false
    ) {
        self.id = id
        self.title = title
        self.description = description
        self.createdAt = createdAt
        self.priority = priority
        self.isDone = isDone
    }
}
