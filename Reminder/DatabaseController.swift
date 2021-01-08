//
//  DatabaseController.swift
//  Reminder
//
//  Created by Wittawin Muangnoi on 23/10/2563 BE.
//

import Foundation
import CoreData
import UIKit

class DB {
    private let context = (UIApplication.shared.delegate as! AppDelegate).persistentContainer.viewContext
    private let fetchedResult : [List]?
    init() {
        fetchedResult = try? context.fetch(List.fetchRequest())
    }
    
    func fetchDB() -> Any?{
        let newFetchedResult = try? context.fetch(List.fetchRequest())
        return newFetchedResult
    }
    
    func saveDB(){
        try? context.save()
    }
    
    func append(title:String){
        let newItem = List(context: context)
        newItem.title = title
        self.saveDB()
    }
    
    
}
