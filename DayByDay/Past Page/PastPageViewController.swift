//
//  PastPageViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class PastPageViewController: UIViewController {
    
    
    @IBOutlet weak var PastTitleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var monthlyTodos: [String: [TodoData]] = [:] // 월별로 분리된 Todo 데이터
    let todoDataManager = CoreDataManager.shared // Core Data Manager 인스턴스
    
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        tableView.delegate = self
        tableView.dataSource = self
        setUI()
        
        

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
        tableView.reloadData()
    }
}

extension PastPageViewController: UITableViewDataSource {
    
  
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return monthlyTodos.keys.count
    }
    
    func tableView(_ tableView: UITableView, titleForHeaderInSection section: Int) -> String? {
        return Array(monthlyTodos.keys).sorted()[section]
    }
    
    //헤더 타이틀 컬러 변경
    func tableView(_ tableView: UITableView, willDisplayHeaderView view: UIView, forSection section: Int) {
        if let headerView = view as? UITableViewHeaderFooterView,
           let textLabel = headerView.textLabel {
            textLabel.textColor = UIColor.white.withAlphaComponent(0.6)
        }
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        let month = Array(monthlyTodos.keys).sorted()[section]
        return monthlyTodos[month]?.count ?? 0
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! PastPageTableViewCell
        cell.backgroundColor = UIColor.clear
        let month = Array(monthlyTodos.keys).sorted()[indexPath.section]
        let todoData = monthlyTodos[month]?[indexPath.row]
        
//        cell.todoTitleLabel.text = todoData?.title
       
        return cell
    }
}

// MARK: - UITableViewDelegate
extension PastPageViewController: UITableViewDelegate {
    // 필요하면 여기에 delegate 메서드를 추가
}



