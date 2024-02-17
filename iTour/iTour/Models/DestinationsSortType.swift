//
//  DestinationsSortType.swift
//  iTour
//
//  Created by Azoz Salah on 16/02/2024.
//

import Foundation


enum DestinationSortType {
    case name
    case date
    case priority
    
    var sortDescriptor: SortDescriptor<Destination> {
        switch self {
        case .name:
            SortDescriptor(\Destination.name)
        case .date:
            SortDescriptor(\Destination.date)
        case .priority:
            SortDescriptor(\Destination.priority, order: .reverse)
        }
    }
}
