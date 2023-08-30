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
    
    //데이터매니저
    let todoDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
        
        //데이터 갖고 오면 reload하는 것이 일반적인 흐름
        todoDataManager.fetchData()
        tableView.reloadData()
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(true)
        todoDataManager.fetchData()
        
    }
    
    
    
    
    func setupUI() {
        titleLabel.text = "TODAY"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textColor = .white
        
        todayDateLabel.text = dateFormatter()
        todayDateLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        todayDateLabel.textColor = .white
        
        createTodoButton.setTitle("Add a Task", for: .normal)
        createTodoButton.setTitleColor(UIColor.white, for: .normal)
        createTodoButton.setTitleColor(UIColor.white, for: .highlighted)
        createTodoButton.layer.borderWidth = 1.0
        createTodoButton.layer.borderColor = UIColor.white.cgColor.copy(alpha: 0.6)
        createTodoButton.backgroundColor = .white.withAlphaComponent(0.1)
        createTodoButton.layer.cornerRadius = 5
        
        
        
        createTodoButton.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            createTodoButton.widthAnchor.constraint(equalToConstant: 200),
            createTodoButton.heightAnchor.constraint(equalToConstant: 30),
            createTodoButton.centerXAnchor.constraint(equalTo: view.centerXAnchor)
        ])
        
        setupBackground()
    }
    
    @IBAction func pressedCreateButton(_ sender: UIButton) {
        let addAlert = UIAlertController(title: "Add a Task", message: "", preferredStyle: .alert)
        addAlert.addTextField {(textField:UITextField) in textField.placeholder = "20 characters or less"}
        
        //취소, 저장 버튼
        let cancel = UIAlertAction(title: "cancel", style: .default)
        let save = UIAlertAction(title: "save", style: .default) { _ in
            
            
            let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
            
            //TodoData에서 가져올거다
            guard let entityDescription = NSEntityDescription.entity(forEntityName: "TodoData", in: context) else { return }
            
            guard let object = NSManagedObject(entity: entityDescription, insertInto: context) as? TodoData else { return }
            
            //텍스트필드에 입력된 값을 저장
            object.todoContent = addAlert.textFields?.first?.text
            object.date = Date()
            object.id = UUID()
            object.isCompleted = false
            let appDelegate = (UIApplication.shared.delegate as! AppDelegate)
            appDelegate.saveContext()
            
            self.setupTableView()
            
            //저장 누르고 알럿뷰 내려간 뒤에 화면이 업데이트 되어야 하니까 아래의 코드 추가
            self.todoDataManager.fetchData()
            //화면 갱신
            self.tableView.reloadData()
        }
        
        addAlert.addAction(cancel)
        addAlert.addAction(save)
        
        
        self.present(addAlert, animated: true)
        
    }
    
    
    
    
    func loadImage(urlString: String, completion: @escaping (UIImage) -> Void) {
        if let url = URL(string: urlString) {
            URLSession.shared.dataTask(with: url) { data, _, _ in
                if let data = data, let image = UIImage(data: data) {
                    completion(image)
                }
            }.resume()
        }
    }
    
    func setupBackground() {
        if let selectedBackgroundImageURL = UserDefaults.standard.string(forKey: "selectedBackgroundImage") {
            print("Selected background URL: \(selectedBackgroundImageURL)") // 로그 추가
            let url = URL(string: selectedBackgroundImageURL)
            URLSession.shared.dataTask(with: url!) { (data, response, error) in
                if let error = error {
                    print("Data task error: \(error)") // 에러 로그
                    return
                }
                if let data = data {
                    DispatchQueue.main.async {
                        self.view.backgroundColor = UIColor(patternImage: UIImage(data: data) ?? UIImage())
                    }
                }
            }.resume()
        } else {
            print("No selected background image in UserDefaults.") // 로그 추가
        }
    }
    
    func dateFormatter() -> String {
        let currentDate = Date()
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy.MM.dd"
        let formattedDate = formatter.string(from: currentDate)
        return formattedDate
    }
    
    
    func setupTableView() {
        tableView.dataSource = self
        tableView.delegate = self
        tableView.separatorStyle = .none
        
    }
    
    
}


extension TodayPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return todoDataManager.todoList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodayTableViewCell
        let todoData = todoDataManager.todoList[indexPath.row]
        
        
        cell.isCompletedHandler = { [weak self] isSelected in
            self?.todoDataManager.saveTodoData(isCompleted: isSelected, index: indexPath.row, completion: {
                print(isSelected)
            })
        }
        
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
                self.todoDataManager.deleteTodoData(at: indexPath.row) {
                    // 테이블 뷰에서 삭제
                    tableView.deleteRows(at: [indexPath], with: .automatic)
                }
            }))
            
            // 알림 창 표시
            self.present(deleteAlert, animated: true, completion: nil)
        }
    }
}
