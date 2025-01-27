//
//  PlayerTableViewCell.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 14.11.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    private let titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 16)
        button.titleLabel?.numberOfLines = 0
        button.tintColor = .customWhite
        button.contentHorizontalAlignment = .left
        button.translatesAutoresizingMaskIntoConstraints = false
        
        button.addTarget(
            self,
            action: #selector(titleButtonTapped),
            for: .touchUpInside
        )
        return button
    }()
    
    private let descriptionLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customWhite
        label.numberOfLines = 2
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let dateLabel: UILabel = {
        let label = UILabel()
        label.textColor = .customWhite
        label.font = UIFont(name: "SFProText-Regular", size: 12)
        label.numberOfLines = 1
        label.translatesAutoresizingMaskIntoConstraints = false
        return label
    }()
    
    private let textStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .vertical
        stack.spacing = 6
        stack.alignment = .fill
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let cellStackView: UIStackView = {
        let stack = UIStackView()
        stack.axis = .horizontal
        stack.spacing = 8
        stack.alignment = .top
        stack.distribution = .fill
        stack.translatesAutoresizingMaskIntoConstraints = false
        return stack
    }()
    
    private let statusMarkImage: UIButton = {
        let button = UIButton(type: .custom)
        button.setImage(UIImage(systemName: "circle"), for: .normal)
        button.tintColor = .customYellow
        button.translatesAutoresizingMaskIntoConstraints = false
        return button
    }()
    
    private var currentTask: ToDoTask? = nil
    private var isCompleted: Bool = false {
        didSet {
            updateUI()
        }
    }
    
    override init(style: UITableViewCell.CellStyle, reuseIdentifier: String?) {
        super.init(style: style, reuseIdentifier: reuseIdentifier)
        
        contentView.addSubview(cellStackView)
        cellStackView.addArrangedSubview(statusMarkImage)
        cellStackView.addArrangedSubview(textStackView)
        
        textStackView.addArrangedSubview(titleButton)
        textStackView.addArrangedSubview(descriptionLabel)
        textStackView.addArrangedSubview(dateLabel)
        
        setupConstraints()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        super.init(coder: coder)
    }
    
    func configure(withTask task: ToDoTask) {
        currentTask = task
        isCompleted = task.isCompleted
        titleButton.setTitle(task.title, for: .normal)
        descriptionLabel.text = task.taskDescription ?? " "
        dateLabel.text = formattedDate(task.date ?? Date())
        updateUI()
    }
    
    func setSelected(_ isSelected: Bool) {
        contentView.backgroundColor = isSelected ? .customGrey : .screen
        statusMarkImage.isHidden = isSelected
    }
    
    @objc private func titleButtonTapped() {
        isCompleted.toggle()
        guard let task = currentTask else { return }
        StorageManager.shared.update(task, withNewStatus: isCompleted)
    }
    
    private func setupConstraints() {
        let constraints = [
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),
            
            titleButton.heightAnchor.constraint(equalToConstant: 24),
            
            statusMarkImage.widthAnchor.constraint(equalToConstant: 24),
            statusMarkImage.heightAnchor.constraint(equalToConstant: 24)
        ]
        NSLayoutConstraint.activate(constraints)
    }
    
    private func updateUI() {
        let statusImageName = isCompleted ? "checkmark.circle" : "circle"
        let statusTintColor: UIColor = isCompleted ? .customYellow : .customWhite
        let statusOpacity: Float = isCompleted ? 1 : 0.5
        let otherOpacity: Float = isCompleted ? 0.5 : 1
        
        statusMarkImage.setImage(UIImage(systemName: statusImageName), for: .normal)
        statusMarkImage.tintColor = statusTintColor
        statusMarkImage.layer.opacity = statusOpacity
        
        let titleAttributes: [NSAttributedString.Key: Any] = isCompleted
        ? [.strikethroughStyle: NSUnderlineStyle.single.rawValue] : [:]
        let attributedTitle = NSAttributedString(
            string: titleButton.currentTitle ?? "",
            attributes: titleAttributes
        )
        
        titleButton.setAttributedTitle(attributedTitle, for: .normal)
        
        titleButton.layer.opacity = otherOpacity
        descriptionLabel.layer.opacity = otherOpacity
        dateLabel.layer.opacity = otherOpacity
    }
    
    private func formattedDate(_ date: Date) -> String {
        let dateFormatter = DateFormatter()
        dateFormatter.dateStyle = .medium
        dateFormatter.timeStyle = .none
        return dateFormatter.string(from: date)
    }
}
