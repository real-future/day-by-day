//
//  TableViewCell.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class TodayTableViewCell: UITableViewCell {
    
    
    var todo: TodoData?  // 할 일 데이터
    var isCompletedHandler: ((Bool) -> Void)? // 할 일 완료 상태 변경 핸들러
    
    @IBOutlet weak var cellBoxView: UIView!
    @IBOutlet weak var todoTitleLabel: UILabel!
    @IBOutlet weak var checkButton: UIButton!
    
    
    //셀이 생성될 때 호출
    override func awakeFromNib() {
        super.awakeFromNib()
        
        // iOS 15.0 이상에서만 배경색을 투명하게 설정
        if #available(iOS 15.0, *) {
            checkButton.configuration?.baseBackgroundColor = .clear
        } else {
            // 이전 버전에서는 특별한 처리 없음
        }
    }
    
    
    //셀이 선택될 때 호출
    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
    
    
    //재사용-셀 초기화
    override func prepareForReuse() {
        super.prepareForReuse()
        //취소선 없애기
        let attributeString = NSMutableAttributedString(string: todoTitleLabel.text!)
        attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
        todoTitleLabel.attributedText = attributeString
    }
    
    
    //셀 설정
    func configure(todo: TodoData) {
        //완료 상태와 할 일 내용 가져오기
        let isCompleted = todo.isCompleted
        let todoContent = todo.todoContent
        self.todo = todo
        
        //셀 디자인 설정
        self.selectionStyle = .none
        self.backgroundColor = UIColor.clear
        self.cellBoxView.backgroundColor = .white.withAlphaComponent(0.1)
        self.cellBoxView.layer.cornerRadius = 5
        
        //완료 상태에 따른 체크 버튼 설정
        self.checkButton.isSelected = isCompleted
        
        //셀 타이틀레이블에 투두 제목 데이터 연결🔴🔴🔴🔴🔴🔴순서
        self.todoTitleLabel.text = todoContent
        
        //완료 상태에 따른 텍스트 스타일 설정
        if isCompleted {
            self.checkButton.tintColor = .white
            drawStrike()
        } else {
            self.checkButton.tintColor = .white.withAlphaComponent(0.2)
        }
    }
    
    
    //취소선 그리기
    func drawStrike() {
        let attributeString = NSMutableAttributedString(string: self.todoTitleLabel.text ?? "")
        attributeString.addAttribute(NSAttributedString.Key.strikethroughStyle, value: 2, range: NSMakeRange(0, attributeString.length))
        self.todoTitleLabel.attributedText = attributeString
    }
    
    
    //체크 버튼 클릭 시 호출되
    @IBAction func pressedCheckButton(_ sender: UIButton) {
        if #available(iOS 15.0, *) {
            sender.configuration?.baseBackgroundColor = .clear
        } else {
            //이전 버전에서는 특별한 처리 없음
        }
        
        //isSelected 상태 토글
        sender.isSelected.toggle()
        todo?.isCompleted = sender.isSelected
        
        //완료 상태에 따른 동작
        if sender.isSelected {
            //선택되었을 때 흰색(투명도 1.0)
            sender.tintColor = UIColor.white.withAlphaComponent(1.0)
            //취소선 추가
            drawStrike()
        } else {
            //선택되지 않았을 때 흰색(투명도 0.5)
            sender.tintColor = UIColor.white.withAlphaComponent(0.2)
            //취소선 제거
            let attributeString = NSMutableAttributedString(string: todoTitleLabel.text!)
            attributeString.removeAttribute(NSAttributedString.Key.strikethroughStyle, range: NSMakeRange(0, attributeString.length))
            todoTitleLabel.attributedText = attributeString
        }
        isCompletedHandler?(sender.isSelected)
    }
}
