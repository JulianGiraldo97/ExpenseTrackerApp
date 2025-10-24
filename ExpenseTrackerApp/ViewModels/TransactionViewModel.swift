//
//  TransactionViewModel.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import Foundation
internal import CoreData
import SwiftUI
import Combine

// MARK: - Transaction ViewModel
@MainActor
class TransactionViewModel: ObservableObject {
    @Published var transactions: [Transaction] = []
    @Published var selectedCategory: TransactionCategory? = nil
    @Published var dateRange: DateRange = .all
    @Published var searchText: String = ""
    
    let viewContext: NSManagedObjectContext
    
    init(context: NSManagedObjectContext) {
        self.viewContext = context
        fetchTransactions()
    }
    
    // MARK: - Fetch Transactions
    func fetchTransactions() {
        let request: NSFetchRequest<Transaction> = Transaction.fetchRequest()
        
        // Apply filters
        var predicates: [NSPredicate] = []
        
        if let selectedCategory = selectedCategory {
            predicates.append(NSPredicate(format: "category == %@", selectedCategory.rawValue))
        }
        
        if !searchText.isEmpty {
            predicates.append(NSPredicate(format: "title CONTAINS[cd] %@", searchText))
        }
        
        // Apply date range filter
        switch dateRange {
        case .all:
            break
        case .last7Days:
            let sevenDaysAgo = Calendar.current.date(byAdding: .day, value: -7, to: Date()) ?? Date()
            predicates.append(NSPredicate(format: "date >= %@", sevenDaysAgo as NSDate))
        case .thisMonth:
            let startOfMonth = Calendar.current.dateInterval(of: .month, for: Date())?.start ?? Date()
            predicates.append(NSPredicate(format: "date >= %@", startOfMonth as NSDate))
        case .custom(let startDate, let endDate):
            predicates.append(NSPredicate(format: "date >= %@ AND date <= %@", startDate as NSDate, endDate as NSDate))
        }
        
        if !predicates.isEmpty {
            request.predicate = NSCompoundPredicate(andPredicateWithSubpredicates: predicates)
        }
        
        // Sort by date (newest first)
        request.sortDescriptors = [NSSortDescriptor(keyPath: \Transaction.date, ascending: false)]
        
        do {
            transactions = try viewContext.fetch(request)
        } catch {
            print("Error fetching transactions: \(error)")
            transactions = []
        }
    }
    
    // MARK: - Add Transaction
    func addTransaction(title: String, amount: Double, category: TransactionCategory, date: Date) {
        let newTransaction = Transaction(context: viewContext)
        newTransaction.id = UUID()
        newTransaction.title = title
        newTransaction.amount = amount
        newTransaction.category = category.rawValue
        newTransaction.date = date
        
        saveContext()
        fetchTransactions()
    }
    
    // MARK: - Delete Transaction
    func deleteTransaction(_ transaction: Transaction) {
        viewContext.delete(transaction)
        saveContext()
        fetchTransactions()
    }
    
    // MARK: - Update Transaction
    func updateTransaction(_ transaction: Transaction, title: String, amount: Double, category: TransactionCategory, date: Date) {
        transaction.title = title
        transaction.amount = amount
        transaction.category = category.rawValue
        transaction.date = date
        
        saveContext()
        fetchTransactions()
    }
    
    // MARK: - Filter Methods
    func setCategoryFilter(_ category: TransactionCategory?) {
        selectedCategory = category
        fetchTransactions()
    }
    
    func setDateRange(_ range: DateRange) {
        dateRange = range
        fetchTransactions()
    }
    
    func setSearchText(_ text: String) {
        searchText = text
        fetchTransactions()
    }
    
    func clearFilters() {
        selectedCategory = nil
        dateRange = .all
        searchText = ""
        fetchTransactions()
    }
    
    // MARK: - Analytics
    var totalSpending: Double {
        transactions.reduce(0) { $0 + $1.amount }
    }
    
    var spendingByCategory: [String: Double] {
        Dictionary(grouping: transactions, by: { $0.category ?? "Other" })
            .mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    var spendingTrend: [Date: Double] {
        let calendar = Calendar.current
        let grouped = Dictionary(grouping: transactions) { transaction in
            calendar.startOfDay(for: transaction.date ?? Date())
        }
        return grouped.mapValues { $0.reduce(0) { $0 + $1.amount } }
    }
    
    // MARK: - Helper Methods
    private func saveContext() {
        do {
            try viewContext.save()
        } catch {
            print("Error saving context: \(error)")
        }
    }
}

// MARK: - Date Range Enum
enum DateRange: CaseIterable, Identifiable {
    case all
    case last7Days
    case thisMonth
    case custom(Date, Date)
    
    static var allCases: [DateRange] {
        return [.all, .last7Days, .thisMonth]
    }
    
    var id: String {
        switch self {
        case .all: return "all"
        case .last7Days: return "last7Days"
        case .thisMonth: return "thisMonth"
        case .custom: return "custom"
        }
    }
    
    var displayName: String {
        switch self {
        case .all: return "All Time"
        case .last7Days: return "Last 7 Days"
        case .thisMonth: return "This Month"
        case .custom: return "Custom Range"
        }
    }
}
