//
//  Entry.swift
//  JournalSwiftUI
//
//  Created by Tiffany Sakaguchi on 7/6/22.
//

import Foundation

struct Entry: Identifiable, Codable, Equatable {
    var title: String
    var body: String
    var date = Date()
    var id = UUID()
}
