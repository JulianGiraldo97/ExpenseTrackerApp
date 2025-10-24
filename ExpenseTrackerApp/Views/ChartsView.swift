//
//  ChartsView.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI
import Charts

struct ChartsView: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    @State private var selectedChartType: ChartType = .categorySpending
    
    enum ChartType: String, CaseIterable, Identifiable {
        case categorySpending = "Category Spending"
        case spendingTrend = "Spending Trend"
        
        var id: String { rawValue }
    }
    
    var body: some View {
        NavigationView {
            ScrollView {
                VStack(spacing: 24) {
                    // Chart Type Picker
                    Picker("Chart Type", selection: $selectedChartType) {
                        ForEach(ChartType.allCases) { type in
                            Text(type.rawValue).tag(type)
                        }
                    }
                    .pickerStyle(SegmentedPickerStyle())
                    .padding(.horizontal, 16)
                    
                    // Chart Content
                    if transactionViewModel.transactions.isEmpty {
                        EmptyChartsView()
                    } else {
                        switch selectedChartType {
                        case .categorySpending:
                            CategorySpendingChart()
                        case .spendingTrend:
                            SpendingTrendChart()
                        }
                    }
                    
                    // Summary Cards
                    if !transactionViewModel.transactions.isEmpty {
                        SummaryCardsView()
                    }
                }
                .padding(.vertical, 16)
            }
            .navigationTitle("Analytics")
            .navigationBarTitleDisplayMode(.large)
        }
        .onAppear {
            transactionViewModel.fetchTransactions()
        }
    }
}

struct CategorySpendingChart: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    
    private var chartData: [CategorySpendingData] {
        transactionViewModel.spendingByCategory.map { category, amount in
            CategorySpendingData(
                category: category,
                amount: amount,
                color: TransactionCategory(rawValue: category)?.color ?? "gray"
            )
        }.sorted { $0.amount > $1.amount }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending by Category")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
            
            if chartData.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: 200)
            } else {
                Chart(chartData, id: \.category) { data in
                    BarMark(
                        x: .value("Amount", data.amount),
                        y: .value("Category", data.category)
                    )
                    .foregroundStyle(Color(data.color))
                }
                .frame(height: max(200, CGFloat(chartData.count * 40)))
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
    }
}

struct SpendingTrendChart: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    
    private var chartData: [SpendingTrendData] {
        transactionViewModel.spendingTrend.map { date, amount in
            SpendingTrendData(date: date, amount: amount)
        }.sorted { $0.date < $1.date }
    }
    
    var body: some View {
        VStack(alignment: .leading, spacing: 16) {
            Text("Spending Over Time")
                .font(.system(size: 20, weight: .semibold))
                .foregroundColor(.primary)
                .padding(.horizontal, 16)
            
            if chartData.isEmpty {
                Text("No data available")
                    .foregroundColor(.secondary)
                    .frame(maxWidth: .infinity, maxHeight: 200)
            } else {
                Chart(chartData, id: \.date) { data in
                    LineMark(
                        x: .value("Date", data.date),
                        y: .value("Amount", data.amount)
                    )
                    .foregroundStyle(.blue)
                    .interpolationMethod(.catmullRom)
                    
                    AreaMark(
                        x: .value("Date", data.date),
                        y: .value("Amount", data.amount)
                    )
                    .foregroundStyle(.blue.opacity(0.2))
                    .interpolationMethod(.catmullRom)
                }
                .frame(height: 200)
                .padding(.horizontal, 16)
            }
        }
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 4, x: 0, y: 2)
        )
        .padding(.horizontal, 16)
    }
}

struct SummaryCardsView: View {
    @EnvironmentObject private var transactionViewModel: TransactionViewModel
    
    var body: some View {
        VStack(spacing: 12) {
            HStack(spacing: 12) {
                SummaryCard(
                    title: "Total Spending",
                    value: transactionViewModel.totalSpending,
                    icon: "dollarsign.circle.fill",
                    color: .red
                )
                
                SummaryCard(
                    title: "Transactions",
                    value: Double(transactionViewModel.transactions.count),
                    icon: "list.bullet.circle.fill",
                    color: .blue
                )
            }
            
            if !transactionViewModel.transactions.isEmpty {
                HStack(spacing: 12) {
                    SummaryCard(
                        title: "Average",
                        value: transactionViewModel.totalSpending / Double(transactionViewModel.transactions.count),
                        icon: "chart.line.uptrend.xyaxis.circle.fill",
                        color: .green
                    )
                    
                    SummaryCard(
                        title: "Categories",
                        value: Double(transactionViewModel.spendingByCategory.count),
                        icon: "tag.circle.fill",
                        color: .purple
                    )
                }
            }
        }
        .padding(.horizontal, 16)
    }
}

struct SummaryCard: View {
    let title: String
    let value: Double
    let icon: String
    let color: Color
    
    var body: some View {
        VStack(spacing: 8) {
            Image(systemName: icon)
                .font(.system(size: 24))
                .foregroundColor(color)
            
            Text(title)
                .font(.system(size: 12, weight: .medium))
                .foregroundColor(.secondary)
                .multilineTextAlignment(.center)
            
            Text(value, format: .currency(code: "USD"))
                .font(.system(size: 16, weight: .semibold))
                .foregroundColor(.primary)
                .lineLimit(1)
                .minimumScaleFactor(0.8)
        }
        .frame(maxWidth: .infinity)
        .padding(.vertical, 16)
        .background(
            RoundedRectangle(cornerRadius: 12)
                .fill(Color(.systemBackground))
                .shadow(color: .black.opacity(0.1), radius: 2, x: 0, y: 1)
        )
    }
}

struct EmptyChartsView: View {
    var body: some View {
        VStack(spacing: 20) {
            Image(systemName: "chart.bar.xaxis")
                .font(.system(size: 60))
                .foregroundColor(.secondary)
            
            VStack(spacing: 8) {
                Text("No Data to Display")
                    .font(.system(size: 20, weight: .semibold))
                    .foregroundColor(.primary)
                
                Text("Add some transactions to see your spending analytics")
                    .font(.system(size: 16))
                    .foregroundColor(.secondary)
                    .multilineTextAlignment(.center)
                    .padding(.horizontal, 32)
            }
        }
        .frame(maxWidth: .infinity, maxHeight: 300)
        .background(Color(.systemGroupedBackground))
        .cornerRadius(12)
        .padding(.horizontal, 16)
    }
}

// MARK: - Chart Data Models
struct CategorySpendingData {
    let category: String
    let amount: Double
    let color: String
}

struct SpendingTrendData {
    let date: Date
    let amount: Double
}

#Preview {
    ChartsView()
        .environmentObject(TransactionViewModel(context: PersistenceController.preview.container.viewContext))
}
