//
//  FilterBar.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI

struct FilterBar: View {
    @Binding var searchText: String
    @Binding var selectedCategory: TransactionCategory?
    @Binding var dateRange: DateRange
    let onClearFilters: () -> Void
    
    @State private var showingCategoryFilter = false
    @State private var showingDateFilter = false
    
    var body: some View {
        VStack(spacing: 12) {
            // Search Bar
            HStack {
                Image(systemName: "magnifyingglass")
                    .foregroundColor(.secondary)
                
                TextField("Search transactions...", text: $searchText)
                    .textFieldStyle(PlainTextFieldStyle())
                
                if !searchText.isEmpty {
                    Button(action: { searchText = "" }) {
                        Image(systemName: "xmark.circle.fill")
                            .foregroundColor(.secondary)
                    }
                }
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(Color(.systemGray6))
            .cornerRadius(10)
            
            // Filter Buttons
            ScrollView(.horizontal, showsIndicators: false) {
                HStack(spacing: 12) {
                    // Category Filter
                    FilterButton(
                        title: selectedCategory?.rawValue ?? "All Categories",
                        icon: selectedCategory?.icon ?? "list.bullet",
                        isActive: selectedCategory != nil
                    ) {
                        showingCategoryFilter = true
                    }
                    
                    // Date Range Filter
                    FilterButton(
                        title: dateRange.displayName,
                        icon: "calendar",
                        isActive: dateRange != .all
                    ) {
                        showingDateFilter = true
                    }
                    
                    // Clear Filters
                    if selectedCategory != nil || dateRange != .all || !searchText.isEmpty {
                        FilterButton(
                            title: "Clear",
                            icon: "xmark.circle",
                            isActive: false
                        ) {
                            onClearFilters()
                        }
                    }
                }
                .padding(.horizontal, 16)
            }
        }
        .sheet(isPresented: $showingCategoryFilter) {
            CategoryFilterView(selectedCategory: $selectedCategory)
        }
        .sheet(isPresented: $showingDateFilter) {
            DateRangeFilterView(dateRange: $dateRange)
        }
    }
}

struct FilterButton: View {
    let title: String
    let icon: String
    let isActive: Bool
    let action: () -> Void
    
    var body: some View {
        Button(action: action) {
            HStack(spacing: 6) {
                Image(systemName: icon)
                    .font(.system(size: 12, weight: .medium))
                
                Text(title)
                    .font(.system(size: 14, weight: .medium))
            }
            .padding(.horizontal, 12)
            .padding(.vertical, 8)
            .background(
                RoundedRectangle(cornerRadius: 20)
                    .fill(isActive ? Color.blue : Color(.systemGray6))
            )
            .foregroundColor(isActive ? .white : .primary)
        }
        .buttonStyle(PlainButtonStyle())
    }
}

struct CategoryFilterView: View {
    @Binding var selectedCategory: TransactionCategory?
    @Environment(\.dismiss) private var dismiss
    
    var body: some View {
        NavigationView {
            List {
                Button("All Categories") {
                    selectedCategory = nil
                    dismiss()
                }
                .foregroundColor(selectedCategory == nil ? .blue : .primary)
                
                ForEach(TransactionCategory.allCases) { category in
                    Button(category.rawValue) {
                        selectedCategory = category
                        dismiss()
                    }
                    .foregroundColor(selectedCategory == category ? .blue : .primary)
                }
            }
            .navigationTitle("Filter by Category")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

struct DateRangeFilterView: View {
    @Binding var dateRange: DateRange
    @Environment(\.dismiss) private var dismiss
    
    private var nonCustomDateRanges: [DateRange] {
        [.all, .last7Days, .thisMonth]
    }
    
    var body: some View {
        NavigationView {
            List {
                ForEach(nonCustomDateRanges, id: \.id) { range in
                    Button(range.displayName) {
                        dateRange = range
                        dismiss()
                    }
                    .foregroundColor(dateRange.id == range.id ? .blue : .primary)
                }
            }
            .navigationTitle("Filter by Date")
            .navigationBarTitleDisplayMode(.inline)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    Button("Done") {
                        dismiss()
                    }
                }
            }
        }
    }
}

#Preview {
    FilterBar(
        searchText: .constant(""),
        selectedCategory: .constant(nil),
        dateRange: .constant(.all),
        onClearFilters: {}
    )
    .padding()
}
