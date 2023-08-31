//
//  PastPageTableViewCell.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/31.
//

import UIKit

class PastPageTableViewCell: UITableViewCell {

    
    @IBOutlet weak var pastTodoLabel: UILabel!
    @IBOutlet weak var cellView: UIView!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    func configureUI() {
        cellView.layer.cornerRadius = 5
        cellView.backgroundColor = .white.withAlphaComponent(0.1)
    }
    
    //취소선
    func drawStrike() {
        let attributeString = NSMutableAttributedString(string: self.pastTodoLabel.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.pastTodoLabel.attributedText = attributeString
    }
    
    func setCombinedText(with todos: [TodoData]) {
        let fullAttributedString = NSMutableAttributedString()
        
        for (index, todoData) in todos.enumerated() {
            let content = todoData.todoContent ?? ""
            let attributedString: NSAttributedString
            let isLastItem = index == todos.count - 1 // 마지막 항목인지 확인
            
            if todoData.isCompleted {
                attributedString = NSAttributedString(
                    string: content + (isLastItem ? "" : "\n"), // 마지막 항목이면 \n 를 추가하지 않습니다.
                    attributes: [
                        NSAttributedString.Key.strikethroughStyle: NSUnderlineStyle.single.rawValue,
                        NSAttributedString.Key.foregroundColor: UIColor.white // Text color set to white
                    ]
                )
            } else {
                attributedString = NSAttributedString(
                    string: content + (isLastItem ? "" : "\n"), // 마지막 항목이면 \n 를 추가하지 않습니다.
                    attributes: [
                        NSAttributedString.Key.foregroundColor: UIColor.white // Text color set to white
                    ]
                )
            }
            fullAttributedString.append(attributedString)
        }
    
        self.pastTodoLabel.attributedText = fullAttributedString
    }
}
