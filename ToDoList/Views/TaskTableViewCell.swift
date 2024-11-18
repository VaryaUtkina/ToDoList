//
//  TaskTableViewCell.swift
//  ToDoList
//
//  Created by Варвара Уткина on 18.11.2024.
//

import UIKit

final class TaskTableViewCell: UITableViewCell {
    
    @IBOutlet var statusMarkImage: UIImageView!
    @IBOutlet var titleButton: UIButton!
    @IBOutlet var descriptionLabel: UILabel!
    @IBOutlet var dateLabel: UILabel!
    
    private var isCompleted: Bool = false {
        didSet {
            updateUI()
        }
    }

    
    @IBAction func titleButtonTapped() {
        isCompleted.toggle()
    }
    
    func configure(withTask task: Task) {
        isCompleted = task.isCompleted
        titleButton.setTitle(task.title, for: .normal)
        descriptionLabel.text = task.description ?? " "
        dateLabel.text = task.date?.formatted() ?? " "
        statusMarkImage.preferredSymbolConfiguration = .init(weight: .light)
        updateUI()
    }
    
    private func updateUI() {
        let statusImageName = isCompleted ? "checkmark.circle" : "circle"
        let statusTintColor: UIColor = isCompleted ? .customYellow : .customWhite
        let statusOpacity: Float = isCompleted ? 1 : 0.5
        let otherOpacity: Float = isCompleted ? 0.5 : 1
        
        statusMarkImage.image = UIImage(systemName: statusImageName)
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
}
