//
//  TodayPageViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit
import CoreData



class TodayPageViewController: UIViewController {
    
    
    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    @IBOutlet weak var createTodoButton: UIButton!
    
    
    //CoreDataManager 인스턴스
    let todoDataManager = CoreDataManager.shared
    //오늘의 할 일 목록 저장할 수 있도록
    var todayTodoList = [TodoData]()
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI() //UI설정
        setupTableView() //테이블뷰 설정
        todoDataManager.fetchData() //데이터 가져오기
        print("todoDataManager.todoList: \(todoDataManager.todoList)")  //디버깅
        tableView.reloadData() //테이블뷰 갱신
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        print("viewWillAppear called")  //디버깅
        todoDataManager.fetchData() //데이터 가져오기
        
        // 오늘 날짜 구하기
        let today = Calendar.current.startOfDay(for: Date())
        print("todayTodoList before filtering: \(todayTodoList)")  //디버깅
        
        // 오늘의 todo만 필터링
        todayTodoList = todoDataManager.todoList.filter { todo in
            guard let todoDate = todo.date else { return false }
            let todoStartOfDay = Calendar.current.startOfDay(for: todoDate)
            return todoStartOfDay == today
        }
        print("@@@@todayTodoList after filtering: \(todayTodoList)")  //디버깅
        
        // 화면 갱신
        tableView.reloadData()
    }
    
    
    //UI 설정
    func setupUI() {
        titleLabel.text = "TODAY"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textColor = .white
        
        todayDateLabel.text = dateFormatter() //날짜 형식 설정
        todayDateLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        todayDateLabel.textColor = .white.withAlphaComponent(0.6)
        
        setupBackground(for: self) //배경 설정. Utils에 정의해두었음.
        seupTodoButton()
    }
    
    
    //할 일 추가 버튼
    func seupTodoButton() {
        createTodoButton.setTitle("Add a Task", for: .normal)
        createTodoButton.setTitleColor(UIColor.white, for: .normal)
        createTodoButton.setTitleColor(UIColor.white, for: .highlighted)
        createTodoButton.layer.borderWidth = 1.0 //버튼 테두리 두께
        createTodoButton.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6) //버튼 테두리 색상
        createTodoButton.backgroundColor = .white.withAlphaComponent(0.1)
        createTodoButton.layer.cornerRadius = 5
        
        //오토레이아웃
        createTodoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createTodoButton.widthAnchor.constraint(equalToConstant: 200),
            createTodoButton.heightAnchor.constraint(equalToConstant: 30),
            createTodoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
    }
    
    
    @IBAction func pressedCreateButton(_ sender: UIButton) {
        print("pressedCreateButton called") // 디버깅을 위한 출력
            let addAlert = UIAlertController(title: "Add a Task", message: "Please enter within 28 characters", preferredStyle: .alert)
            
            // 텍스트 필드를 추가하고, 해당 텍스트 필드의 델리게이트를 self로 설정합니다.
            addAlert.addTextField {(textField: UITextField) in
                textField.placeholder = "28 characters or less"
                textField.delegate = self // 클래스가 UITextFieldDelegate 프로토콜을 준수한다고 가정
            }
        
        //취소, 저장 버튼 액션 설정
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default) { _ in
            
            //CoreData context
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            //TodoData Entity
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoData", in: context) else { return }
            guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoData else { return }
            
            //텍스트필드에 입력된 값을 저장
            object.todoContent = addAlert.textFields?.first?.text
            object.date = Date()
            object.id = UUID()
            object.isCompleted = false
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.saveContext()
            
            //저장 누르고 알럿뷰 내려간 뒤에 화면이 업데이트 되어야 하니까 아래의 코드 추가
            self.todoDataManager.fetchData()
            print("Data fetched after adding new todo: \(self.todoDataManager.todoList)")  //디버깅
            
            
            // 오늘 날짜 구하기
            let today = Calendar.current.startOfDay(for: Date())
            
            // 오늘의 todo만 필터링
            self.todayTodoList = self.todoDataManager.todoList.filter { todo in
                guard let todoDate = todo.date else { return false }
                let todoStartOfDay = Calendar.current.startOfDay(for: todoDate)
                return todoStartOfDay == today
            }
            
            
            //화면 갱신
            self.tableView.reloadData()
            print("Table reloaded after adding new todo")  //디버깅
            
            //새로운 Todo 항목이 추가되었음을 알리는 Notification 발송
            NotificationCenter.default.post(name: NSNotification.Name("newTodoItemAdded"), object: nil)
            self.setupTableView()
        }
        
        //액션 추가, 팝업 표시
        addAlert.addAction(cancel)
        addAlert.addAction(save)
        self.present(addAlert, animated: true)
        
    }
    
    
    //이미지 로드
    func loadImage(urlString: String, completion: @escaping (UIImage) -> Void) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }.resume()
        }
    }
    
    
    //날짜 포맷터
    func dateFormatter() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = formatter.string(from: currentDate)
        return formattedDate
    }
    
    
    //테이블뷰 설정 함수
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
    }
}


extension TodayPageViewController: UITableViewDataSource {
    //행 수 설정
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todayTodoList.count
    }
    
    //각 행에 대한 셀 설정
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodayTableViewCell
        let todoData = todayTodoList[indexPath.row]  // 필터링된 배열에서 todo 가져오기
        
        
        //셀의 완료 상태 관리하는 Closure
        cell.isCompletedHandler = { [weak self] isSelected in
            self?.todoDataManager.saveTodoData(isCompleted: isSelected, index: indexPath.row, completion: {
                print(isSelected)
            })
        }
        
        //셀에 Todo 데이터 설정
        cell.configure(todo: todoData)
        
        return cell
    }
}


extension TodayPageViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            
            // 알림 창 설정
            let deleteAlert = UIAlertController(title: "Conform Delete", message: "Are you sure you want to delete me??", preferredStyle: .alert)
            
            // 취소 버튼
            deleteAlert.addAction(UIAlertAction(title: "cancel", style: .cancel, handler: nil))
            
            // 확인 버튼
            deleteAlert.addAction(UIAlertAction(title: "delete", style: .default, handler: { (_) in
                // Core Data에서 삭제
                let todoToBeDeleted = self.todayTodoList[indexPath.row]
                self.todoDataManager.deleteTodoData(with: todoToBeDeleted.id) {
                    // 테이블 뷰에서 삭제
                    self.todayTodoList.remove(at: indexPath.row) // 이렇게 해서 todayTodoList도 업데이트
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }))
            
            // 알림 창 표시
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
}


extension TodayPageViewController: UITextFieldDelegate {
    // 텍스트 필드의 텍스트가 변경될 때 호출
    func textField(_ textField: UITextField, shouldChangeCharactersIn range: NSRange, replacementString string: String) -> Bool {
        let currentText = textField.text ?? ""
        guard let stringRange = Range(range, in: currentText) else { return false }
        
        let updatedText = currentText.replacingCharacters(in: stringRange, with: string)
        
        //업데이트 된 텍스트의 길이를 확인
        if updatedText.count > 28 {
            //흔드는 애니메이션을 적용, 테두리 색상을 red
            shakeTextField(textField)
            return false
        }
        return true
    }
    
    
    //텍스트 필드 애니메이션-흔들기
    func shakeTextField(_ textField: UITextField) {
        let animation = CAKeyframeAnimation(keyPath: "transform.translation.x")
        animation.timingFunction = CAMediaTimingFunction(name: CAMediaTimingFunctionName.linear)
        animation.duration = 0.6
        animation.values = [-20.0, 20.0, -20.0, 20.0, -10.0, 10.0, -5.0, 5.0, 0.0]
        textField.layer.add(animation, forKey: "shake")
        
        // 테두리 색상 red
        textField.layer.borderColor = UIColor.red.cgColor
        textField.layer.borderWidth = 1.0
    }
}
