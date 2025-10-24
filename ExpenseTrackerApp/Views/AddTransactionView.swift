//
//  AddTransactionView.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI
internal import CoreData

struct AddTransactionView: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    @Environment(\.dismiss) private var dismiss
    
    @State private var title = ""
    @State private var amount = ""
    @State private var selectedCategory = TransactionCategory.food
    @State private var selectedDate = Date()
    @State private var showingAlert = false
    @State private var alertMessage = ""
    
    private var isValidForm: Bool {
        !title.trimmingCharacters(in: .whitespacesAndNewlines).isEmpty &&
        !amount.isEmpty &&
        Double(amount) != nil &&
        Double(amount) ?? 0 > 0
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Header
                    VStack(spacing: 8) {
                        Text("Add New Transaction")
                            .font(.system(size: 28, weight: .bold))
                            .foregroundColor(.primary)
                        
                        Text("Track your expenses easily")
                            .font(.system(size: 16))
                            .foregroundColor(.secondary)
                    }
                    .padding(.top, 20)
                    
                    // Form
                    VStack(spacing: 20) {
                        // Title Input
                        InputField(
                            title: "Transaction Title",
                            placeholder: "e.g., Coffee, Groceries, Gas",
                            text: $title
                        )
                        
                        // Amount Input
                        InputField(
                            title: "Amount",
                            placeholder: "0.00",
                            text: $amount,
                            keyboardType: .decimalPad
                        )
                        
                        // Category Picker
                        CategoryPicker(selectedCategory: $selectedCategory)
                        
                        // Date Picker
                        VStack(alignment: .leading, spacing: 8) {
                            Text("Date")
                                .font(.headline)
                                .foregroundColor(.primary)
                            
                            DatePicker(
                                "Transaction Date",
                                selection: $selectedDate,
                                displayedComponents: [.date]
                            )
                            .datePickerStyle(CompactDatePickerStyle())
                            .padding(.horizontal, 12)
                            .padding(.vertical, 8)
                            .background(Color(.systemGray6))
                            .cornerRadius(8)
                        }
                    }
                    .padding(.horizontal, 20)
                    
                    // Add Button
                    Button(action: addTransaction) {
                        HStack {
                            Image(systemName: "plus.circle.fill")
                                .font(.system(size: 18, weight: .medium))
                            
                            Text("Add Transaction")
                                .font(.system(size: 18, weight: .semibold))
                        }
                        .foregroundColor(.white)
                        .frame(maxWidth: .infinity)
                        .padding(.vertical, 16)
                        .background(
                            RoundedRectangle(cornerRadius: 12)
                                .fill(isValidForm ? Color.blue : Color.gray)
                        )
                    }
                    .disabled(!isValidForm)
                    .padding(.horizontal, 20)
                    .padding(.bottom, 20)
                }
            }
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarLeading) {
                    Button("Cancel") {
                        dismiss()
                    }
                }
            }
        }
        .alert("Invalid Input", isPresented: $showingAlert) {
            Button("OK") { }
        } message: {
            Text(alertMessage)
        }
    }
    
    private func addTransaction() {
        guard isValidForm else {
            showAlert("Please fill in all fields correctly")
            return
        }
        
        guard let amountValue = Double(amount), amountValue > 0 else {
            showAlert("Please enter a valid amount greater than 0")
            return
        }
        
        transactionViewModel.addTransaction(
            title: title.trimmingCharacters(in: .whitespacesAndNewlines),
            amount: amountValue,
            category: selectedCategory,
            date: selectedDate
        )
        
        dismiss()
    }
    
    private func showAlert(_ message: String) {
        alertMessage = message
        showingAlert = true
    }
}

#Preview {
    AddTransactionView()
        .environmentObject(TransactionViewModel(context: PersistenceController.preview.container.viewContext))
}
