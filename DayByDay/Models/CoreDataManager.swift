//
//  CoreDataManager.swift
//  DayByDay
//
//  Created by FUTURE on 2023/08/29.
//

import UIKit
import CoreData

final class CoreDataManager {
    
    
    var todoList = [TodoData]()
    
    //싱글톤
    static let shared = CoreDataManager()
    private init() {}
    
    //앱 델리게이트
    let appDelegate = UIApplication.shared.delegate as! AppDelegate
    
    //임시저장소 역할. Core Data의 Context를 가져옴
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //엔터티 이름(내가 설정한 이름)
    let modelName: String = "TodoData"
    
    
    //모든 TodoData 호출
    func fetchData() {
        //객체 생성하여 TodoData 타입 데이터 가져올 거라고 명시
        let fetchRequest: NSFetchRequest<TodoData> = TodoData.fetchRequest()
        //CoreData의 context 가져오는 곳. DB와 앱 사이에서 데이터 임시 저장하고 관리
        let context = appDelegate.persistentContainer.viewContext
        //do가 성공, catch가 실패할 때 실행
        do {
            self.todoList = try context.fetch(fetchRequest)
            print("Fetched Data: \(self.todoList)")
            
        } catch {
            print(error)
        }
    }
    
    //월별로 TodoData 분리
    func fetchMonthlyData() -> [String: [TodoData]] {
        var sections: [String: [TodoData]] = [:]
        //날짜 포맷터 설정
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        
        
        for todo in todoList {
            if let date = todo.date {
                //예를 들어, date가 "2023-08-29"라면 sectionTitle은 "2023.08"
                let sectionTitle = dateFormatter.string(from: date)
                if sections[sectionTitle] == nil {
                    sections[sectionTitle] = []
                }
                //해당 월을 키로 가지는 todo를 추가
                sections[sectionTitle]?.append(todo)
            }
        }
        return sections
    }
    
    
    //일별로 TodoData 분리
    func fetchDailyData() -> [String: [TodoData]] {
        //딕셔너리로 생성.
        var sections: [String: [TodoData]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM.dd"
        
        for todo in todoList {
            if let date = todo.date {
                let sectionTitle = dateFormatter.string(from: date)
                if sections[sectionTitle] == nil {
                    sections[sectionTitle] = []
                }
                sections[sectionTitle]?.append(todo)
            }
        }
        return sections
    }
    
    
    //특정 TodoData 완료 상태 변경하고 저장
    func saveTodoData(isCompleted: Bool, index: Int, completion: @escaping () -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        self.todoList[index].isCompleted =  isCompleted
        
        if context.hasChanges {
            do {
                try context.save()
            } catch {
                print(error)
            }
        }
    }
    
    
    //특정 ID를 가진 TodoData 삭제
    func deleteTodoData(with id: UUID, completion: @escaping () -> Void) {
        let context = appDelegate.persistentContainer.viewContext
        
        if let index = todoList.firstIndex(where: { $0.id == id }) {
            // 해당 TodoData를 Core Data의 Context에서 삭제
            let todoDataToDelete = todoList[index]
            context.delete(todoDataToDelete)
            
            do {
                // Context에 변경이 있을 경우 저장
                try context.save()
                // todoList 배열에서도 해당 TodoData를 삭제
                todoList.remove(at: index)
                completion()  // 완료 후 실행할 작업
            } catch {
                print(error)
            }
        }
    }
}

