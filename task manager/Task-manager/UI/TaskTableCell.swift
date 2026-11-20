//
//  TaskTableCell.swift
//  Task-manager
//
//  Created by Anastasia on 20.11.2026.
//
import UIKit

final class TaskTableCell: UITableViewCell {

    static let cellID = "taskCell"

    private let statusImageView: UIImageView = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.contentMode = .scaleAspectFit
        $0.tintColor = .systemBlue

        return $0
    }(UIImageView())

    private let titleLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 17, weight: .semibold)
        $0.textColor = .label

        return $0
    }(UILabel())

    private let taskDescriptionLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 15)
        $0.textColor = .secondaryLabel
        $0.numberOfLines = 2

        return $0
    }(UILabel())

    private let priorityLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 13, weight: .medium)

        return $0
    }(UILabel())

    private let dateLabel: UILabel = {
        $0.translatesAutoresizingMaskIntoConstraints = false
        $0.font = .systemFont(ofSize: 13)
        $0.textColor = .secondaryLabel
        $0.textAlignment = .right

        return $0
    }(UILabel())

    override init(
        style: UITableViewCell.CellStyle,
        reuseIdentifier: String?
    ) {
        super.init(
            style: style,
            reuseIdentifier: reuseIdentifier
        )

        setupUI()
        setupConstraints()
    }

    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }

    func configure(with task: TaskModel) {
        titleLabel.text = task.title
        taskDescriptionLabel.text = task.description
        dateLabel.text = Self.dateFormatter.string(from: task.createdAt)

        let statusImageName = task.isDone ? "checkmark.square.fill" : "square"
        statusImageView.image = UIImage(systemName: statusImageName)

        switch task.priority {
        case .high:
            priorityLabel.text = "Высокий"
            priorityLabel.textColor = .systemRed

        case .medium:
            priorityLabel.text = "Средний"
            priorityLabel.textColor = .systemOrange

        case .low:
            priorityLabel.text = "Низкий"
            priorityLabel.textColor = .systemGreen
        }
    }
}

// MARK: Setup UI, Constraints
private extension TaskTableCell {

    static let dateFormatter: DateFormatter = {
        $0.dateFormat = "dd.MM.yyyy HH:mm"

        return $0
    }(DateFormatter())

    func setupUI() {
        backgroundColor = .systemBackground

        contentView.addSubview(statusImageView)
        contentView.addSubview(titleLabel)
        contentView.addSubview(taskDescriptionLabel)
        contentView.addSubview(priorityLabel)
        contentView.addSubview(dateLabel)
    }

    func setupConstraints() {
        NSLayoutConstraint.activate([

            statusImageView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 16),
            statusImageView.centerYAnchor.constraint(equalTo: contentView.centerYAnchor),
            statusImageView.widthAnchor.constraint(equalToConstant: 28),
            statusImageView.heightAnchor.constraint(equalToConstant: 28),

            titleLabel.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            titleLabel.leadingAnchor.constraint(equalTo: statusImageView.trailingAnchor, constant: 16),
            titleLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            taskDescriptionLabel.topAnchor.constraint(equalTo: titleLabel.bottomAnchor, constant: 6),
            taskDescriptionLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            taskDescriptionLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),

            priorityLabel.topAnchor.constraint(equalTo: taskDescriptionLabel.bottomAnchor, constant: 10),
            priorityLabel.leadingAnchor.constraint(equalTo: titleLabel.leadingAnchor),
            priorityLabel.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),

            dateLabel.leadingAnchor.constraint(greaterThanOrEqualTo: priorityLabel.trailingAnchor, constant: 8),
            dateLabel.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -16),
            dateLabel.centerYAnchor.constraint(equalTo: priorityLabel.centerYAnchor)

        ])
    }
}
