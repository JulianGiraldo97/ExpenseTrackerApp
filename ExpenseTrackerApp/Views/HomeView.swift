//
//  HomeView.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI

struct HomeView: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    @State private var showingAddTransaction = false
    
    var body: some View {
        NavigationView {
            VStack(spacing: 0) {
                // Summary Card
                SummaryCard()
                    .padding(.horizontal, 16)
                    .padding(.top, 8)
                
                // Filter Bar
                FilterBar(
                    searchText: $transactionViewModel.searchText,
                    selectedCategory: $transactionViewModel.selectedCategory,
                    dateRange: $transactionViewModel.dateRange,
                    onClearFilters: {
                        transactionViewModel.clearFilters()
                    }
                )
                .padding(.horizontal, 16)
                .padding(.vertical, 12)
                
                // Transactions List
                if transactionViewModel.transactions.isEmpty {
                    EmptyStateView()
                } else {
                    TransactionsList()
                }
            }
            .navigationTitle("Expenses")
            .navigationBarTitleDisplayMode(.large)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Demo Data") {
                        DemoDataGenerator.generateDemoData(context: transactionViewModel.viewContext)
                        transactionViewModel.fetchTransactions()
                    }
                    .font(.system(size: 14, weight: .medium))
                }
                
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button(action: { showingAddTransaction = true }) {
                        Image(systemName: "plus")
                            .font(.system(size: 18, weight: .medium))
                    }
                }
            }
        }
        .sheet(isPresented: $showingAddTransaction) {
            AddTransactionView()
        }
        .onAppear {
            transactionViewModel.fetchTransactions()
        }
    }
}

struct SummaryCard: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack {
                VStack(alignment: .leading, spacing: 4) {
                    Text("Total Spending")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text(transactionViewModel.totalSpending, format: .currency(code: "USD"))
                        .font(.system(size: 28, weight: .bold))
                        .foregroundColor(.primary)
                }
                
                Spacer()
                
                VStack(alignment: .trailing, spacing: 4) {
                    Text("Transactions")
                        .font(.system(size: 14, weight: .medium))
                        .foregroundColor(.secondary)
                    
                    Text("\(transactionViewModel.transactions.count)")
                        .font(.system(size: 20, weight: .semibold))
                        .foregroundColor(.primary)
                }
            }
            
            if !transactionViewModel.transactions.isEmpty {
                Divider()
                
                HStack {
                    Text("Average per transaction")
                        .font(.system(size: 12))
                        .foregroundColor(.secondary)
                    
                    Spacer()
                    
                    Text(transactionViewModel.totalSpending / Double(transactionViewModel.transactions.count), format: .currency(code: "USD"))
                        .font(.system(size: 12, weight: .medium))
                        .foregroundColor(.secondary)
                }
            }
        }
        .padding(16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
    }
}

struct TransactionsList: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    
    var body: some View {
        List {
            ForEach(transactionViewModel.transactions, id: \.id) { transaction in
                TransactionRow(transaction: transaction) {
                    transactionViewModel.deleteTransaction(transaction)
                }
                .listRowInsets(EdgeInsets(top: 4, leading: 16, bottom: 4, trailing: 16))
            }
        }
        .listStyle(PlainListStyle())
    }
}

struct EmptyStateView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "creditcard")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Transactions Yet")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Start tracking your expenses by adding your first transaction")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: .infinity)
        .background(Color(.systemGroupedBackground))
    }
}

#Preview {
    HomeView()
        .environmentObject(TransactionViewModel(context: PersistenceController.preview.container.viewContext))
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
