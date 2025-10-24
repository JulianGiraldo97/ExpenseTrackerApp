//
//  TransactionModel.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import Foundation
internal import CoreData

// MARK: - Transaction Categories
enum TransactionCategory: String, CaseIterable, Identifiable {
    case food = "Food"
    case transport = "Transport"
    case bills = "Bills"
    case entertainment = "Entertainment"
    case shopping = "Shopping"
    case healthcare = "Healthcare"
    case other = "Other"
    
    var id: String { rawValue }
    
    var icon: String {
        switch self {
        case .food: return "fork.knife"
        case .transport: return "car"
        case .bills: return "doc.text"
        case .entertainment: return "tv"
        case .shopping: return "bag"
        case .healthcare: return "cross.case"
        case .other: return "questionmark.circle"
        }
    }
    
    var color: String {
        switch self {
        case .food: return "orange"
        case .transport: return "blue"
        case .bills: return "red"
        case .entertainment: return "purple"
        case .shopping: return "green"
        case .healthcare: return "pink"
        case .other: return "gray"
        }
    }
}

// MARK: - Transaction Extensions
extension Transaction {
    var categoryEnum: TransactionCategory {
        get { TransactionCategory(rawValue: category ?? "Other") ?? .other }
        set { category = newValue.rawValue }
    }
    
    var formattedAmount: String {
        let formatter = NumberFormatter()
        formatter.numberStyle = .currency
        formatter.currencyCode = "USD"
        return formatter.string(from: NSNumber(value: amount)) ?? "$0.00"
    }
    
    var formattedDate: String {
        let formatter = DateFormatter()
        formatter.dateStyle = .medium
        formatter.timeStyle = .short
        return formatter.string(from: date ?? Date())
    }
}
