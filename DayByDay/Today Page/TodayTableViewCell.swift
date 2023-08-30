//
//  TableViewCell.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class TodayTableViewCell: UITableViewCell {

    
    var todo: TodoData?
    var isCompletedHandler: ((Bool) -> Void)?
    
    @IBOutlet weak var cellBoxView: UIView!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
        if #available(iOS 15.0, *) {
            checkButton.configuration?.baseBackgroundColor = .clear
        } else {
            // Fallback on earlier versions
        }
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

    override func prepareForReuse() {
        super.prepareForReuse()
        self.todoTitleLabel.text = ""
    }

    
    func configure(todo: TodoData) {
        let isCompleted = todo.isCompleted
        let todoContent = todo.todoContent
        self.todo = todo
        
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.cellBoxView.backgroundColor = .white.withAlphaComponent(0.2)
        self.cellBoxView.layer.cornerRadius = 5
        
        self.checkButton.isSelected = isCompleted
        
        
        if isCompleted {
//            self.todoTitleLabel.textColor = .white.withAlphaComponent(1.0)
            self.checkButton.tintColor = .white
            drawStrike()
        } else {
//            self.todoTitleLabel.textColor = .white
            self.checkButton.tintColor = .white.withAlphaComponent(0.2)
        }
        
        //셀 타이틀레이블에 투두 제목 데이터 연결
        self.todoTitleLabel.text = todoContent
    }
    
    func drawStrike() {
        let attributeString = NSMutableAttributedString(string: self.todoTitleLabel.text ?? "")
            attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
            self.todoTitleLabel.attributedText = attributeString
    }
    
    @IBAction func pressedCheckButton(_ sender: UIButton) {
        if #available(iOS 15.0, *) {
            sender.configuration?.baseBackgroundColor = .clear
        } else {
            // Fallback on earlier versions
        }
        
        
        // isSelected 상태 토글
        sender.isSelected.toggle()
        todo?.isCompleted = sender.isSelected
        
        
        if sender.isSelected {
            // 선택되었을 때 흰색(투명도 1.0)
            sender.tintColor = UIColor.white.withAlphaComponent(1.0)
//            todoTitleLabel.textColor = .white.withAlphaComponent(0.2)
            // 취소선 추가
            drawStrike()
            
            
        } else {
            // 선택되지 않았을 때 흰색(투명도 0.5)
            sender.tintColor = UIColor.white.withAlphaComponent(0.2)
//            todoTitleLabel.textColor = .white
            
            // 취소선 제거
            let attributeString = NSMutableAttributedString(string: todoTitleLabel.text!)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            todoTitleLabel.attributedText = attributeString
        }
        isCompletedHandler?(sender.isSelected)
    }
}
