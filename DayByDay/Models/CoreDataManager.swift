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
    
    //임시저장소
    lazy var context = appDelegate.persistentContainer.viewContext
    
    //엔터티 이름
    let modelName: String = "TodoData"
    
    
    
    func fetchData() {
        let fetchRequest: NSFetchRequest<TodoData> = TodoData.fetchRequest()
        let context = appDelegate.persistentContainer.viewContext
        do {
            self.todoList = try context.fetch(fetchRequest)
        } catch {
            print(error)
        }
    }
    
    // 월별로 데이터를 분리
    func fetchMonthlyData() -> [String: [TodoData]] {
        var sections: [String: [TodoData]] = [:]
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyy.MM"
        
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
    
    //일별로 데이터 분리
    func fetchDailyData() -> [String: [TodoData]] {
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
    
    func deleteTodoData(at index: Int, completion: @escaping () -> Void) {
            let context = appDelegate.persistentContainer.viewContext

            // 인덱스에 위치한 TodoData를 가져옴
            let todoDataToDelete = todoList[index]
            
            // 해당 TodoData를 Core Data의 Context에서 삭제
            context.delete(todoDataToDelete)
            
            // todoList 배열에서도 해당 TodoData를 삭제
            todoList.remove(at: index)
            
            // Context에 변경이 있을 경우 저장
            if context.hasChanges {
                do {
                    try context.save()
                    completion() // 완료 후 실행할 작업 
                } catch {
                    print(error)
                }
            }
        }
    

    
    //    func getTodoListFromCoreData() -> [TodoData] {
    //        var todoList: [TodoData] = []
    //
    //        //임시저장소에 있는지 확인
    //        if let context = context {
    //            //요청서
    //            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
    //            //정렬순서를 정해서 요청서에 넘겨주기
    //            let dateOrder = NSSortDescriptor(key: "date", ascending: true)
    //            request.sortDescriptors = [dateOrder]
    //
    //            do {
    //                //임시저장소에서 데이터 가져오기 (요청서 통해)
    //                if let fetchedTodoList = try context.fetch(request) as? [TodoData] {
    //                    todoList = fetchedTodoList
    //                }
    //            } catch {
    //                print("데이터 가져오기 실패")
    //            }
    //        }
    //        return todoList
    //    }
    //
    //
    //    func saveTodoData(todoContent: String?, completion: @escaping () -> Void) {
    //        if let context = context {
    //            if let entity = NSEntityDescription.entity(forEntityName: self.modelName, in: context) {
    //
    //                if let todoData = NSManagedObject(entity: entity, insertInto: context) as? TodoData {
    //
    //                    todoData.todoContent = todoContent
    //                    todoData.date = Date()
    //
    //                    if context.hasChanges {
    //                        do {
    //                            try context.save()
    //                            completion()
    //                        } catch {
    //                            print(error)
    //                            completion()
    //                        }
    //                    }
    //                }
    //            }
    //        }
    //        completion()
    //    }
    //
    //
    //    func deleteTodo(data: TodoData, completion: @escaping () -> Void) {
    //        //날짜 옵셔널 바인딩
    //        guard let date = data.date else {
    //            completion()
    //            return
    //        }
    //
    //        if let context = context {
    //
    //            let request = NSFetchRequest<NSManagedObject>(entityName: self.modelName)
    //            request.predicate = NSPredicate(format: "date = %@", date as CVarArg)
    //
    //
    //            do {
    //                if let fetchedToDoList = try context.fetch(request) as? [TodoData] {
    //                    if let targetTodo = fetchedToDoList.first {
    //                        context.delete(targetTodo)
    //
    //                        if context.hasChanges {
    //                            do {
    //                                try context.save()
    //                                completion()
    //                            } catch {
    //                                print(error)
    //                                completion()
    //                            }
    //                        }
    //                    }
    //                }
    //                completion()
    //            } catch {
    //                print("지우는 것 실패")
    //                completion()
    //            }
    //        }
    //    }
    
    
    
}

