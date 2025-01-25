//
//  PlayerTableViewCell.swift
//  NbaPlayers
//
//  Created by Варвара Уткина on 14.11.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    // вычисление размеров ячейки
    override var intrinsicContentSize: CGSize {
        let size = cellStackView.sizeThatFits(CGSize(width: contentView.bounds.width, height: CGFloat.greatestFiniteMagnitude))
        return size
    }
    
    private let titleButton: UIButton = {
        let button = UIButton(type: .custom)
        button.titleLabel?.font = UIFont(name: "SFProText-Medium", size: 16)
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
        stack.alignment = .leading
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
        setupIn(stack: textStackView, views: titleButton, descriptionLabel, dateLabel)
        setupIn(stack: cellStackView, views: statusMarkImage, textStackView)
        
        setupViews(cellStackView)
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
        dateLabel.text = formattedDate(task.date)
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
}

// MARK: - Setup UI
extension TaskTableViewCell {
    private func setupViews(_ views: UIView...) {
        views.forEach { view in
            contentView.addSubview(view)
        }
    }
    
    private func setupIn(stack: UIStackView, views: UIView...) {
        views.forEach { view in
            stack.addArrangedSubview(view)
        }
    }
    
    private func setupConstraints() {
        let heightAnchor = dateLabel.heightAnchor.constraint(equalToConstant: 14.5)
        
        // анимированное изменение значения констрейнта
//        UIView.animate {
//            heightAnchor.constant = 18
//        }
        
        NSLayoutConstraint.activate([
            cellStackView.topAnchor.constraint(equalTo: contentView.topAnchor, constant: 12),
            cellStackView.bottomAnchor.constraint(equalTo: contentView.bottomAnchor, constant: -12),
            cellStackView.leadingAnchor.constraint(equalTo: contentView.leadingAnchor, constant: 8),
            
            statusMarkImage.widthAnchor.constraint(equalToConstant: 24),
            statusMarkImage.widthAnchor.constraint(equalTo: statusMarkImage.heightAnchor),
            
            cellStackView.trailingAnchor.constraint(equalTo: contentView.trailingAnchor, constant: -20),

            titleButton.heightAnchor.constraint(equalToConstant: 24),
            heightAnchor
        ])
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
    
    private func formattedDate(_ date: Date?) -> String {
        guard let date else { return "" }
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "dd/MM/yy"
        return dateFormatter.string(from: date)
    }
}

