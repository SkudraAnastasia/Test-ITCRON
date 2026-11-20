//
//  AddTaskViewController.swift
//  Task-manager
//
//  Created by Anastasia on 20.11.2026.
//
import UIKit

class AddTaskViewController: UIViewController {
    var onTaskAdded: ((String, String, Priority) -> Void)?
    
    private let titleTextField: UITextField = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.placeholder = "Название задачи"
        $0.borderStyle = .roundedRect
        $0.backgroundColor = .white

        return $0
    }(UITextField())
    
    private let descriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.text = "Описание"
        $0.font = .systemFont(ofSize: 14, weight: .medium)
        $0.textColor = .lightGray

        return $0
    }(UILabel())
    
    private let descriptionTextView: UITextView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 16)

        $0.backgroundColor = .white
        $0.layer.cornerRadius = 8


        return $0
    }(UITextView())
    
    
    private let priorityControl: UISegmentedControl = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.selectedSegmentIndex = 1

        return $0
    }(UISegmentedControl(items: ["Низкий", "Средний", "Высокий"]))
    
    private lazy var saveTaskButton: UIButton = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.setTitle("Сохранить", for: .normal)
        $0.backgroundColor = .blue
        $0.setTitleColor(.white, for: .normal)
        $0.layer.cornerRadius = 10
        
        return $0
    }(UIButton(primaryAction: UIAction { [weak self] _ in
        self?.saveTaskButtonTapped()
    }))
    
    override func viewDidLoad() {
        super.viewDidLoad()

        setupUI()
        setupConstraints()
    }
}

//MARK: UI Actions
private extension AddTaskViewController {
    func selectedPriority() -> Priority {
        switch priorityControl.selectedSegmentIndex {
        case 0:
            return .low
        case 2:
            return .high
        default:
            return .medium
        }
    }
    
    func saveTaskButtonTapped() {
        guard
            let title = titleTextField.text,
            !title.isEmpty
        else {
            return
        }

        let description = descriptionTextView.text ?? ""
        let priority = selectedPriority()

        onTaskAdded?(
            title,
            description,
            priority
        )

        dismiss(animated: true)
    }
}

// MARK: Setup UI, Constrants
private extension AddTaskViewController {
    func setupUI() {
        view.backgroundColor = .systemBackground
        title = "Новая задача"

        view.addSubview(titleTextField)
        view.addSubview(descriptionLabel)
        view.addSubview(descriptionTextView)
        view.addSubview(priorityControl)
        view.addSubview(saveTaskButton)
    }
    
    func setupConstraints() {
        NSLayoutConstraint.activate([

            titleTextField.topAnchor.constraint(equalTo: view.safeAreaLayoutGuide.topAnchor, constant: 24),
            titleTextField.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            titleTextField.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            titleTextField.heightAnchor.constraint(equalToConstant: 44),

            descriptionLabel.topAnchor.constraint(equalTo: titleTextField.bottomAnchor, constant: 16),
            descriptionLabel.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionLabel.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),

            descriptionTextView.topAnchor.constraint(equalTo: descriptionLabel.bottomAnchor, constant: 6),
            descriptionTextView.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            descriptionTextView.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            descriptionTextView.heightAnchor.constraint(equalToConstant: 100),

            priorityControl.topAnchor.constraint(equalTo: descriptionTextView.bottomAnchor, constant: 16),
            priorityControl.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            priorityControl.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            priorityControl.heightAnchor.constraint(equalToConstant: 36),

            saveTaskButton.topAnchor.constraint(equalTo: priorityControl.bottomAnchor, constant: 24),
            saveTaskButton.leadingAnchor.constraint(equalTo: view.leadingAnchor, constant: 16),
            saveTaskButton.trailingAnchor.constraint(equalTo: view.trailingAnchor, constant: -16),
            saveTaskButton.heightAnchor.constraint(equalToConstant: 50)

        ])
    }
}
