//
//  MainTabView.swift
//  ExpenseTrackerApp
//
//  Created by Julian Giraldo on 24/10/25.
//

import SwiftUI

struct MainTabView: View {
    @Environment(\.managedObjectContext) private var viewContext
    @StateObject private var transactionViewModel: TransactionViewModel
    
    init() {
        self._transactionViewModel = StateObject(wrappedValue: TransactionViewModel(context: PersistenceController.shared.container.viewContext))
    }
    
    var body: some View {
        TabView {
            HomeView()
                .tabItem {
                    Image(systemName: "house.fill")
                    Text("Home")
                }
            
            ChartsView()
                .tabItem {
                    Image(systemName: "chart.bar.fill")
                    Text("Charts")
                }
            
            AddTransactionView()
                .tabItem {
                    Image(systemName: "plus.circle.fill")
                    Text("Add")
                }
        }
        .environmentObject(transactionViewModel)
        .accentColor(.blue)
    }
}

#Preview {
    MainTabView()
        .environment(\.managedObjectContext, PersistenceController.preview.container.viewContext)
}
