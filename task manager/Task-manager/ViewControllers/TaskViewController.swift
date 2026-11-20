//
//  ViewController.swift
//  Task-manager
//
//  Created by Anastasia on 20.11.2026.
//

import UIKit

class TaskViewController: UIViewController {
    
    private let viewModel = TaskViewModel()
    private var showCompletedOnly = false
    private var selectedPriority: Priority?

    private var displayedTasks: [TaskModel] {
        if showCompletedOnly {
            let completedTasks = viewModel.getCompletedTasks()
            guard let selectedPriority else {
                return completedTasks
            }
            return completedTasks.filter {
                $0.priority == selectedPriority
            }
        }

        if let selectedPriority {
            return viewModel.getTasks(by: selectedPriority)
        }
        
        return viewModel.getAllTasks()
    }
    
    private lazy var tasksTable: UITableView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.dataSource = self
        $0.delegate = self
        $0.register(TaskTableCell.self, forCellReuseIdentifier: TaskTableCell.cellID)
        $0.backgroundColor = .clear
        $0.rowHeight = UITableView.automaticDimension
        
        return $0
    }(UITableView())
    
    private lazy var addTaskButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Добавить задачу", for: .normal)
        $0.backgroundColor = .blue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        
        return $0
    }(UIButton(primaryAction: UIAction { [weak self] _ in
        self?.addTaskButtonTapped()}))
    
    
    private lazy var sortButton = UIBarButtonItem(
        title: nil,
        image: UIImage(
            systemName: "arrow.up.arrow.down.circle"
        ),
        primaryAction: UIAction { [weak self] _ in
            self?.sortButtonAction()
        }
    )
    
    private lazy var statusFilterButton: UIBarButtonItem = {
        $0.menu = makeStatusFilterMenu()

        return $0
    }(UIBarButtonItem(
        image: UIImage(systemName: "checkmark.circle"),
        style: .plain,
        target: nil,
        action: nil
    ))

    private lazy var priorityFilterButton: UIBarButtonItem = {
        $0.menu = makePriorityFilterMenu()

        return $0
    }(UIBarButtonItem(
        image: UIImage(systemName: "exclamationmark.circle"),
        style: .plain,
        target: nil,
        action: nil
    ))

    override func viewDidLoad() {
        super.viewDidLoad()
       
        setupUI()
        setupConstraints()
       
    }
}

//MARK: UI Actions
 extension TaskViewController {
    func addTaskButtonTapped() {
        let addTaskViewController = AddTaskViewController()

        addTaskViewController.onTaskAdded = {
            [weak self] title, description, priority in
            self?.viewModel.addTask(
                title: title,
                description: description,
                priority: priority
            )
            self?.tasksTable.reloadData()
        }

        let navigationController = UINavigationController(
            rootViewController: addTaskViewController
        )
        if let sheet = navigationController.sheetPresentationController {
            sheet.detents = [.medium()]
            sheet.prefersGrabberVisible = true
        }
        present(navigationController, animated: true)
    }
    
    func sortButtonAction() {
        viewModel.sortTasksByDate()
        tasksTable.reloadData()
    }
     
     func statusFilterAction(completedOnly: Bool) {
         showCompletedOnly = completedOnly
         tasksTable.reloadData()
     }

     func priorityFilterAction(priority: Priority?) {
         selectedPriority = priority
         tasksTable.reloadData()
     }
}

//MARK: Setup UI, Constrants
private extension TaskViewController {
    func setupUI() {
        title = "Задачи"
        view.backgroundColor = .systemBackground
        
        navigationItem.rightBarButtonItems = [
            sortButton,
            priorityFilterButton,
            statusFilterButton
        ]
        
        view.addSubview(tasksTable)
        view.addSubview(addTaskButton)
        
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([
    
            addTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            addTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            addTaskButton.bottomAnchor.constraint(equalTo: view.safeAreaLayoutGuide.bottomAnchor, constant: -16),
            addTaskButton.heightAnchor.constraint(equalToConstant: 44),
            
            tasksTable.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 16),
            tasksTable.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            tasksTable.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            tasksTable.bottomAnchor.constraint(equalTo: addTaskButton.topAnchor, constant: -16),
            
        ])
    }
}

//MARK: TableViewDataSource, TableViewDelegate
extension TaskViewController: UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        displayedTasks.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        guard let cell = tableView.dequeueReusableCell(  //получение переиспользуемлй ячейки
            withIdentifier: TaskTableCell.cellID,
            for: indexPath
        ) as? TaskTableCell else {
            return UITableViewCell()
        }
        
        let task = displayedTasks[indexPath.row]
        cell.configure(with: task)

        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        let task = displayedTasks[indexPath.row]
        viewModel.changeTaskStatus(by: task.id)

        tableView.reloadData()
        tableView.deselectRow(at: indexPath,animated: true)
    }
    
    func tableView(_ tableView: UITableView, trailingSwipeActionsConfigurationForRowAt indexPath: IndexPath) -> UISwipeActionsConfiguration? {
        let deleteAction = UIContextualAction(style: .destructive,title: "Удалить") { [weak self] _, _, completion in
            guard let self else {
                completion(false)
                return
            }
            let task = self.displayedTasks[indexPath.row]
            self.viewModel.deleteTask(by: task.id)
            tableView.deleteRows(at: [indexPath], with: .automatic)
            completion(true)
        }
        
        deleteAction.image = UIImage(systemName: "trash")
        let configuration = UISwipeActionsConfiguration(actions: [deleteAction])
        configuration.performsFirstActionWithFullSwipe = true

        return configuration
    }
}

//MARK: Filter Menu
private extension TaskViewController {
    func makeStatusFilterMenu() -> UIMenu {
        UIMenu(children: [
            makeStatusAction(
                title: "Все задачи",
                imageName: "list.bullet",
                completedOnly: false
            ),
            makeStatusAction(
                title: "Выполненные",
                imageName: "checkmark.circle.fill",
                completedOnly: true
            )
        ])
    }

    func makeStatusAction(title: String, imageName: String, completedOnly: Bool) -> UIAction {
        UIAction(title: title, image: UIImage(systemName: imageName)) { [weak self] _ in
            self?.statusFilterAction(
                completedOnly: completedOnly
            )}
    }

    func makePriorityFilterMenu() -> UIMenu {
        UIMenu(children: [
            makePriorityAction(
                title: "Все приоритеты",
                priority: nil
            ),
            makePriorityAction(
                title: "Низкий",
                priority: .low
            ),
            makePriorityAction(
                title: "Средний",
                priority: .medium
            ),
            makePriorityAction(
                title: "Высокий",
                priority: .high
            )
        ])
    }

    func makePriorityAction(title: String, priority: Priority?) -> UIAction {
        UIAction(title: title) { [weak self] _ in
            self?.priorityFilterAction(priority: priority)
        }
    }
}
