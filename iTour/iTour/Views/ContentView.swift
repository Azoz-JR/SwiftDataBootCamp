//
//  ContentView.swift
//  iTour
//
//  Created by Azoz Salah on 15/02/2024.
//

import SwiftUI
import SwiftData


struct ContentView: View {
    @Environment(\.modelContext) var modelContext
    
    @State private var path = [Destination]()
    @State private var sortOrder: DestinationSortType = .name
    @State private var searchText = ""
    @State private var selectedTime: TimeOption = .all
    
    var body: some View {
        NavigationStack(path: $path) {
            DestinationListingView(sortOrder: createSortOrders(userOrder: sortOrder), searchString: searchText, selectedTime: selectedTime)
                .navigationTitle("iTour")
                .navigationDestination(for: Destination.self) { destination in
                    EditDestinationView(destination: destination)
                }
                .searchable(text: $searchText, prompt: "Search your destinations")
                .toolbar {
                    ToolbarItem(placement: .topBarLeading) {
                        Menu(selectedTime.rawValue) {
                            Picker("Destinations Time", selection: $selectedTime) {
                                Text("All")
                                    .tag(TimeOption.all)
                                
                                Text("Upcoming")
                                    .tag(TimeOption.upcoming)
                            }
                            .pickerStyle(.inline)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarLeading) {
                        Menu("Sort", systemImage: "arrow.up.arrow.down") {
                            Picker("Sort order", selection: $sortOrder) {
                                Text("Name")
                                    .tag(DestinationSortType.name)
                                
                                Text("Date")
                                    .tag(DestinationSortType.date)
                                
                                Text("Priority")
                                    .tag(DestinationSortType.priority)
                            }
                            .pickerStyle(.inline)
                        }
                    }
                    
                    ToolbarItem(placement: .topBarTrailing) {
                        Button("Add Destination", systemImage: "plus", action: createDestination)
                    }
                    
                }
        }
    }
    
    func createDestination() {
        let destination = Destination()
        modelContext.insert(destination)
        
        path = [destination]
    }
    
    func createSortOrders(userOrder: DestinationSortType) -> [SortDescriptor<Destination>] {
        var sortOrders = [userOrder]
        
        switch userOrder {
        case .name:
            sortOrders.append(.priority)
            sortOrders.append(.date)
        case .date:
            sortOrders.append(.priority)
            sortOrders.append(.name)
        case .priority:
            sortOrders.append(.name)
            sortOrders.append(.date)
        }
        
        return sortOrders.map { $0.sortDescriptor }
    }
    
    
}

#Preview {
    ContentView()
}

enum TimeOption: String, Hashable {
    case all = "All"
    case upcoming = "Upcoming"
}
