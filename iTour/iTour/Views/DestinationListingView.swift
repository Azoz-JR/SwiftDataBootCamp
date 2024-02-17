//
//  DestinationListingView.swift
//  iTour
//
//  Created by Azoz Salah on 16/02/2024.
//

import SwiftData
import SwiftUI


struct DestinationListingView: View {
    @Environment(\.modelContext) var modelContext
    @Query(sort: (\Destination.name), order: .reverse) var destinations: [Destination]
    
    
    init(sortOrder: [SortDescriptor<Destination>], searchString: String = "", selectedTime: TimeOption = .all) {
        let currentDate = Date()
        let allTime = selectedTime == .all
        
        _destinations = Query(
            filter: #Predicate {
                if searchString.isEmpty && allTime {
                    return true
                } else if searchString.isEmpty && !allTime {
                    return $0.date > currentDate
                } else if !searchString.isEmpty && allTime {
                    return ($0.name.localizedStandardContains(searchString))
                } else {
                    return ($0.name.localizedStandardContains(searchString)) &&
                    $0.date > currentDate
                }
        },
        sort: sortOrder)
    }
    
    var body: some View {
        List {
            ForEach(destinations) { destination in
                NavigationLink(value: destination) {
                    VStack(alignment: .leading) {
                        Text(destination.name)
                            .font(.headline)
                        
                        Text(destination.date.formatted(date: .abbreviated, time: .shortened))
                    }
                }
            }
            .onDelete(perform: deleteDestination)
        }
    }
    
    func deleteDestination(at indexSet: IndexSet) {
        for index in indexSet {
            let destination = destinations[index]
            modelContext.delete(destination)
        }
    }
}

#Preview {
    DestinationListingView(sortOrder: [SortDescriptor(\Destination.name)])
}


