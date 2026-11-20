//
//  ViewModel.swift
//  Task-manager
//
//  Created by Anastasia on 20.11.2026.
//
import Foundation

final class TaskViewModel {
    
    private(set) var tasks: [TaskModel] = []
    
    var isEmpty: Bool {
        tasks.isEmpty
    }
    private var sortAscending = false
    
    func addTask(
        title: String,
        description: String,
        priority: Priority
    ) {
        let task = TaskModel(
            title: title,
            description: description,
            priority: priority
        )
        
        tasks.append(task)
    }
    
    func deleteTask(by id: UUID) {
        tasks.removeAll { $0.id == id }
    }
    
    func changeTaskStatus(by id: UUID) {
        guard let index = tasks.firstIndex(where: { $0.id == id }) else {
            return
        }
        tasks[index].isDone.toggle()
    }
    
    func getAllTasks() -> [TaskModel] {
        tasks
    }
    
    func getCompletedTasks() -> [TaskModel] {
        tasks.filter { $0.isDone }
    }
    
    func getTasks(by priority: Priority) -> [TaskModel] {
        tasks.filter { $0.priority == priority }
    }
    
    func sortTasksByDate() {
        tasks.sort {
            sortAscending ? $0.createdAt < $1.createdAt : $0.createdAt > $1.createdAt
        }
        sortAscending.toggle()
    }
}
