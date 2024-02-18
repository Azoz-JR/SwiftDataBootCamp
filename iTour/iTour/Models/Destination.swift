//
//  Destination.swift
//  iTour
//
//  Created by Azoz Salah on 15/02/2024.
//

import Foundation
import SwiftData

@Model
class Destination {
    var name: String
    var details: String
    var date: Date
    var priority: Int
    @Relationship(deleteRule: .cascade) var sights = [Sight]()
    @Attribute(.externalStorage) var photo: Data?
    
    init(name: String = "", details: String = "", date: Date = .now, priority: Int = 2, photo: Data? = nil) {
        self.name = name
        self.details = details
        self.date = date
        self.priority = priority
        self.photo = photo
    }
}
