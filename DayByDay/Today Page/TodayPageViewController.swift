//
//  TodayPageViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class TodayPageViewController: UIViewController {

    @IBOutlet weak var tableView: UITableView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var todayDateLabel: UILabel!
    
    //데이터매니저
    let todoDataManager = CoreDataManager.shared
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupUI()
        setupTableView()
//
    }
    
    func setupUI() {
        titleLabel.text = "TODAY"
        titleLabel.font = UIFont.systemFont(ofSize: 35, weight: .bold)
        titleLabel.textColor = .white

        todayDateLabel.text = dateFormatter()
        todayDateLabel.font = UIFont.systemFont(ofSize: 25, weight: .light)
        todayDateLabel.textColor = .white
        
        
        setupBackground()


       
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
        tableView.separatorStyle = .none
    }


}


extension TodayPageViewController: UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "TodoCell", for: indexPath) as! TodayTableViewCell
        cell.selectionStyle = .none
        cell.backgroundColor = UIColor.clear
        cell.cellBoxView.backgroundColor = .white.withAlphaComponent(0.2)
        cell.cellBoxView.layer.cornerRadius = 5
        return cell
    }
    
}

