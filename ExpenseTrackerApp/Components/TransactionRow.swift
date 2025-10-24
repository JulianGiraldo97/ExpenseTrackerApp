//
//  TransactionRow.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI

struct TransactionRow: View {
    let transaction: Transaction
    let onDelete: () -> Void
    
    @State private var showingDeleteAlert = false
    
    var body: some View {
        HStack(spacing: 12) {
            // Category Icon
            ZStack {
                Circle()
                    .fill(Color(transaction.categoryEnum.color).opacity(0.2))
                    .frame(width: 40, height: 40)
                
                Image(systemName: transaction.categoryEnum.icon)
                    .font(.system(size: 18, weight: .medium))
                    .foregroundColor(Color(transaction.categoryEnum.color))
            }
            
            // Transaction Details
            VStack(alignment: .leading, spacing: 4) {
                Text(transaction.title ?? "")
                    .font(.system(size: 16, weight: .medium))
                    .foregroundColor(.primary)
                    .lineLimit(1)
                
                HStack {
                    Text(transaction.categoryEnum.rawValue)
                        .font(.system(size: 14))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(transaction.formattedDate)
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                }
            }
            
            // Amount
            VStack(alignment: .trailing, spacing: 4) {
                Text(transaction.formattedAmount)
                    .font(.system(size: 16, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Expense")
                    .font(.system(size: 12))
                    .foregroundColor(.red)
            }
        }
        .padding(.vertical, 8)
        .contentShape(Rectangle())
        .contextMenu {
            Button(role: .destructive) {
                showingDeleteAlert = true
            } label: {
                Label("Delete", systemImage: "trash")
            }
        }
        .alert("Delete Transaction", isPresented: $showingDeleteAlert) {
            Button("Cancel", role: .cancel) { }
            Button("Delete", role: .destructive) {
                onDelete()
            }
        } message: {
            Text("Are you sure you want to delete this transaction? This action cannot be undone.")
        }
    }
}

#Preview {
    let context = PersistenceController.preview.container.viewContext
    let transaction = Transaction(context: context)
    transaction.id = UUID()
    transaction.title = "Coffee"
    transaction.amount = 4.50
    transaction.category = "Food"
    transaction.date = Date()
    
    return TransactionRow(transaction: transaction, onDelete: {})
        .padding()
}
