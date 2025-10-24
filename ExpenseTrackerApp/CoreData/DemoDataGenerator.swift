//
//  DemoDataGenerator.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import Foundation
internal import CoreData

struct DemoDataGenerator {
    static func generateDemoData(context: NSManagedObjectContext) {
        let categories: [TransactionCategory] = [.food, .transport, .bills, .entertainment, .shopping, .healthcare, .other]
        
        let demoTransactions = [
            ("Coffee", 4.50, TransactionCategory.food, Date().addingTimeInterval(-86400 * 1)),
            ("Lunch", 12.99, TransactionCategory.food, Date().addingTimeInterval(-86400 * 2)),
            ("Gas", 45.00, TransactionCategory.transport, Date().addingTimeInterval(-86400 * 3)),
            ("Netflix", 15.99, TransactionCategory.entertainment, Date().addingTimeInterval(-86400 * 4)),
            ("Groceries", 78.50, TransactionCategory.food, Date().addingTimeInterval(-86400 * 5)),
            ("Uber", 8.75, TransactionCategory.transport, Date().addingTimeInterval(-86400 * 6)),
            ("Electric Bill", 120.00, TransactionCategory.bills, Date().addingTimeInterval(-86400 * 7)),
            ("Movie", 12.00, TransactionCategory.entertainment, Date().addingTimeInterval(-86400 * 8)),
            ("Pharmacy", 25.99, TransactionCategory.healthcare, Date().addingTimeInterval(-86400 * 9)),
            ("Clothes", 89.99, TransactionCategory.shopping, Date().addingTimeInterval(-86400 * 10)),
            ("Dinner", 35.50, TransactionCategory.food, Date().addingTimeInterval(-86400 * 11)),
            ("Bus Pass", 30.00, TransactionCategory.transport, Date().addingTimeInterval(-86400 * 12)),
            ("Phone Bill", 65.00, TransactionCategory.bills, Date().addingTimeInterval(-86400 * 13)),
            ("Books", 45.00, TransactionCategory.shopping, Date().addingTimeInterval(-86400 * 14)),
            ("Doctor Visit", 150.00, TransactionCategory.healthcare, Date().addingTimeInterval(-86400 * 15))
        ]
        
        for (title, amount, category, date) in demoTransactions {
            let transaction = Transaction(context: context)
            transaction.id = UUID()
            transaction.title = title
            transaction.amount = amount
            transaction.category = category.rawValue
            transaction.date = date
        }
        
        do {
            try context.save()
        } catch {
            print("Error saving demo data: \(error)")
        }
    }
}
