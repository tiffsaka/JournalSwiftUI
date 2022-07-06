//
//  EntryListView.swift
//  JournalSwiftUI
//
//  Created by Tiffany Sakaguchi on 7/6/22.
//

import SwiftUI

struct EntryListView: View {
    
    @State var viewModel = EntryListViewModel()
    
    var body: some View {
        NavigationView {
            
            List {
                Section("My Entries") {
                    ForEach(viewModel.entries) { entry in
                        NavigationLink {
                            DetailView(entry: entry)
                        } label: {
                            VStack(alignment: .leading) {
                                Text(entry.title)
                                    .fontWeight(.bold)
                                    .padding(.bottom, 5)
                                Text(entry.body)
                                    .font(.system(size: 14))
                            }
                            .padding(.vertical)
                        }
                    }
                }
            }
            .navigationTitle("Dream Journal")
            .listStyle(.plain)
            .toolbar {
                ToolbarItem(placement: .navigationBarTrailing) {
                    NavigationLink {
                        DetailView()
                    } label: {
                        Image(systemName: "plus")
                    }
                }
            }
        }
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
