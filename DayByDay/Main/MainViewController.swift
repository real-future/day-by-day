//
//  MainViewController.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit

class MainViewController: UITabBarController {
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.selectedIndex = 1
        setupTabbarColor()
        
        // Do any additional setup after loading the view.
    }
    
    func setupTabbarColor() {
        // 평소의 타이틀 색상
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white.withAlphaComponent(0.5)], for: .normal)
        
        // 선택됐을 때의 타이틀 색상
        UITabBarItem.appearance().setTitleTextAttributes([NSAttributedString.Key.foregroundColor: UIColor.white], for: .selected)
        
        // 평소의 아이콘 색상
        self.tabBar.unselectedItemTintColor = UIColor.white.withAlphaComponent(0.5)
        
        // 선택됐을 때의 아이콘 색상
        self.tabBar.tintColor = UIColor.white
        

        }
    }








