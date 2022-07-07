//
//  EntryListViewModel.swift
//  JournalSwiftUI
//
//  Created by Tiffany Sakaguchi on 7/6/22.
//

import Foundation

class EntryListViewModel: ObservableObject {
    
    @Published var entries: [Entry] = []
    @Published var streak: Int = 0
    @Published var hasJournaled: Bool = false
    
    // MARK: - CRUD
    func createEntry(_ entry: Entry) {
        entries.append(entry)
        saveToPersistenceStore()
    }

    func update(_ entry: Entry, _ title: String, _ body: String) {
        guard let index = entries.firstIndex(of: entry) else { return }
        entries[index].title = title
        entries[index].body = body
        saveToPersistenceStore()
    }
    
    // MARK: - Dashboard Functions
    func getStreak() {
        var localStreak: Int = 0
        var previousEntry: Entry?
        
        // Loop through entries
        for entry in entries {
            // Make sure we have a previous entry
            guard let previousEntryDate = previousEntry?.date else {
                localStreak += 1
                previousEntry = entry
                continue
            }
            // Next compare entry 1 and entry 2
            let components = Calendar.current.dateComponents([.hour], from: previousEntryDate, to: entry.date)
            let hours = components.hour
            if let hours = hours, hours <= 24 {
                
                if Calendar.current.isDate(previousEntryDate, inSameDayAs: entry.date) {
                    continue
                } else {
                    localStreak += 1
                }
            } else {
                return self.streak = localStreak
            }
            previousEntry = entry
        }
        self.streak = localStreak
    }
    
    func hasJournaledToday() {
        let today = Date()
        for entry in entries {
            if Calendar.current.isDate(today, inSameDayAs: entry.date) {
                self.hasJournaled = true
                return
            } else {
                continue
            }
        }
        self.hasJournaled = false
    }
    
    
    // MARK: - Persistence
    func createPersistenceStore() -> URL {
        let url = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)
        let fileURL = url[0].appendingPathComponent("Entries.json")
        return fileURL
    }
    
    func saveToPersistenceStore() {
        do {
            let data = try JSONEncoder().encode(entries)
            try data.write(to: createPersistenceStore())
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
    
    func loadFromPersistenceStore() {
        do {
            let data = try Data(contentsOf: createPersistenceStore())
            entries = try JSONDecoder().decode([Entry].self, from: data)
        } catch {
            print("Error in \(#function) : \(error.localizedDescription) \n---\n \(error)")
        }
    }
}
