//
//  EntryListView.swift
//  JournalSwiftUI
//
//  Created by Tiffany Sakaguchi on 7/6/22.
//

import SwiftUI

struct EntryListView: View {
    
    @ObservedObject var viewModel = EntryListViewModel()
    
    var body: some View {
        NavigationView {
            
            // DashBoard
            ScrollView {
                VStack {
                    HStack {
                        // DAY STREAK TILE
                        ZStack {
                            Rectangle().fill(.ultraThinMaterial)
                            VStack {
                                Text(String(viewModel.streak))
                                    .font(.title)
                                    .bold()
                                Text("DAY STREAK")
                                    .font(.headline)
                            }
                        }.cornerRadius(12)
                        
                        VStack {
                            // TOTAL ENTRIES TILE
                            ZStack {
                                Rectangle().fill(.ultraThinMaterial)
                                VStack {
                                    Text(String(viewModel.entries.count))
                                        .font(.title3)
                                        .bold()
                                    Text("ENTRIES")
                                        .font(.caption)
                                }
                            }.cornerRadius(12)
                            
                            // JOURNALED TODAY TILE
                            ZStack() {
                                Rectangle().fill(.ultraThinMaterial)
                                VStack {
                                    Image(systemName: viewModel.hasJournaled ? "checkmark.circle.fill" : "xmark.circle.fill")
                                    Text("JOURNALED TODAY")
                                        .font(.caption2)
                                        .padding(.top, 1)
                                }
                            }.cornerRadius(12)
                        }
                    }
                }.padding(.horizontal)
                    .frame(height: 140)
                
                // List of Entries
                List {
                    Section("My Entries ") {
                        ForEach(viewModel.entries) { entry in
                            
                            NavigationLink {
                                // Destination
                                DetailView(entry: entry, viewModel: viewModel)
                            } label: {
                                // What our navigation link looks like
                                VStack(alignment: .leading, spacing: 8) {
                                    Text(entry.title)
                                        .bold()
                                        .font(.headline)
                                    Text(entry.body)
                                        .font(.system(size: 14))
                                        .lineLimit(2)
                                }.padding()
                                    .frame(maxHeight: 115)
                            }
                        }
                    }
                }
                .frame(height: CGFloat(viewModel.entries.count) * 115 + 25)
                .listStyle(.plain)
            }
            
            .navigationTitle("Dream Journal")
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        // Destination
                        DetailView(viewModel: viewModel)
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
            .onAppear {
                setupViews()
            }
        }
    }
    
    func setupViews() {
        viewModel.loadFromPersistenceStore()
        viewModel.getStreak()
        viewModel.hasJournaledToday()
    }
}

struct EntryListView_Previews: PreviewProvider {
    static var previews: some View {
        Group {
            EntryListView()
                .previewDevice("iPhone 12")
            EntryListView()
                .previewDevice("iPhone 12 mini")
            EntryListView()
                .previewDevice("iPhone 12 Pro Max")
        }
    }
}
