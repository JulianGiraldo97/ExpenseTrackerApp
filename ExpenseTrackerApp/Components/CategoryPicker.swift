//
//  CategoryPicker.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI

struct CategoryPicker: View {
    @Binding var selectedCategory: TransactionCategory
    
    var body: some View {
        VStack(alignment: .leading, spacing: 8) {
            Text("Category")
                .font(.headline)
                .foregroundColor(.primary)
            
            LazyVGrid(columns: Array(repeating: GridItem(.flexible()), count: 2), spacing: 12) {
                ForEach(TransactionCategory.allCases) { category in
                    CategoryButton(
                        category: category,
                        isSelected: selectedCategory == category
                    ) {
                        selectedCategory = category
                    }
                }
            }
        }
    }
}

struct CategoryButton: View {
    let category: TransactionCategory
    let isSelected: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 8) {
                Image(systemName: category.icon)
                    .foregroundColor(isSelected ? .white : Color(category.color))
                    .font(.system(size: 16, weight: .medium))
                
                Text(category.rawValue)
                    .font(.system(size: 14, weight: .medium))
                    .foregroundColor(isSelected ? .white : .primary)
                
                Spacer()
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 10)
            .background(
                RoundedRectangle(cornerRadius: 8)
                    .fill(isSelected ? Color(category.color) : Color(.systemGray6))
            )
            .overlay(
                RoundedRectangle(cornerRadius: 8)
                    .stroke(isSelected ? Color(category.color) : Color.clear, lineWidth: 2)
            )
        }
        .buttonStyle(PlainButtonStyle())
    }
}

#Preview {
    CategoryPicker(selectedCategory: .constant(.food))
        .padding()
}
