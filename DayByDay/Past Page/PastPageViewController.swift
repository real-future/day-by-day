//
//  PastPageViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit
import CoreData

class PastPageViewController: UIViewController {
    
    
    @IBOutlet weak var PastTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    
    var dailyTodos = [String: [TodoData]]()
    var monthlyTodos = [String: [TodoData]]()
    let todoDataManager = CoreDataManager.shared // Core Data Manager 인스턴스
    
    override func viewDidLoad() {
            super.viewDidLoad()
            tableView.delegate = self
            tableView.dataSource = self
            tableView.backgroundColor = UIColor.clear // 배경 투명하게
            dailyTodos = CoreDataManager.shared.fetchDailyData()

            // Observer 등록
            NotificationCenter.default.addObserver(self, selector: #selector(refreshTodoList), name: NSNotification.Name("newTodoItemAdded"), object: nil)

            setUI()
        }
    
    // Observer가 수신하는 메소드
        @objc func refreshTodoList() {
            todoDataManager.fetchData()
            monthlyTodos = todoDataManager.fetchMonthlyData()
            dailyTodos = CoreDataManager.shared.fetchDailyData() // 새로운 항목을 반영하기 위해 dailyTodos도 업데이트
            tableView.reloadData()
        }

    // 메모리 누수를 방지하기 위해 observer를 제거
    deinit {
        NotificationCenter.default.removeObserver(self, name: NSNotification.Name("newTodoItemAdded"), object: nil)
    }
    
    
    func setUI() {
        PastTitleLabel.text = "PAST"
        PastTitleLabel.textColor = .white
        PastTitleLabel.font = .boldSystemFont(ofSize: 35)
        setupBackground(for: self)
        
    }
    
    
    override func viewWillAppear(_ animated: Bool) {
            super.viewWillAppear(animated)
            todoDataManager.fetchData()
            monthlyTodos = todoDataManager.fetchMonthlyData()
            dailyTodos = CoreDataManager.shared.fetchDailyData() // viewWillAppear에서도 업데이트
            tableView.reloadData()
        }
    }

extension PastPageViewController: UITableViewDataSource {
    
    
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return dailyTodos.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(dailyTodos.keys).sorted()[section]
    }
    
    //헤더 타이틀 컬러 변경
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView,
           let textLabel = headerView.textLabel {
            textLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! PastPageTableViewCell
        cell.backgroundColor = UIColor.clear
        let day = Array(dailyTodos.keys).sorted()[indexPath.section]
        
        if let todosForDay = dailyTodos[day] {
            cell.setCombinedText(with: todosForDay)
        }
        cell.configureUI()
        
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PastPageViewController: UITableViewDelegate {
    
}



