//
//  DetailView.swift
//  JournalSwiftUI
//
//  Created by Tiffany Sakaguchi on 7/6/22.
//

import SwiftUI

struct DetailView: View {
    
    var entry: Entry?
    @State var entryTitleText: String = ""
    @State var entryBodyText: String = "Write the details here..."
    
    @Environment(\.dismiss) private var dismiss
    
    @ObservedObject var viewModel: EntryListViewModel
    
    var body: some View {
        VStack {
            VStack(alignment: .leading) {
                Text("Title")
                    .font(.system(size: 22, weight: .heavy, design: .monospaced))
                    .foregroundColor(.secondary)
                TextField("Placeholder", text: $entryTitleText)
            }.padding()

            HStack {
                Rectangle().fill(.secondary).frame(width: 2)
                VStack(alignment: .leading) {
                    HStack {
                        Text("Body")
                            .font(.system(size: 22, weight: .heavy, design: .monospaced))
                            .foregroundColor(.secondary)
                        Spacer()
                        Button {
                            entryBodyText = ""
                        } label: {
                            Image(systemName: "xmark.circle.fill")
                        }
                    }
                    TextEditor(text: $entryBodyText)
                        
                }
            }.padding()
            
            Spacer()
            
            VStack {
                HStack(spacing: 0) {
                    Text("Created on ")
                    if let entry = entry {
                        Text(entry.date.formatDate())
                    } else {
                        Text(Date().formatDate())
                    }
                }.font(.caption)
                    .foregroundColor(.secondary)
                
                Button {
                    if entry == nil {
                        prepareForCreateEntry(title: entryTitleText, body: entryBodyText)
                    } else {
                        prepareForUpdateEntry()
                    }
                    dismiss()
                } label: {
                    ZStack {
                        Rectangle().fill(.ultraThinMaterial)
                            .cornerRadius(12)
                        Text(entry != nil ? "Update" : "Save")
                    }
                }
                .frame(width: UIScreen.main.bounds.width - 40, height: 55)
            }
        }
        .navigationTitle("Detail View")
        .onAppear {
            if let entry = entry {
                entryTitleText = entry.title
                entryBodyText = entry.body
            }
        }
    }
    
    func prepareForCreateEntry(title: String?, body: String?) {
        guard let title = title, !title.isEmpty,
              let body = body, !body.isEmpty else { return }
        let entry = Entry(title: title, body: body)
        viewModel.createEntry(entry)
    }
    
    func prepareForUpdateEntry() {
        let title = entryTitleText
        let body = entryBodyText
        
        guard !title.isEmpty, !body.isEmpty else { return }
        if let entry = entry {
            viewModel.update(entry, title, body)
        }
    }
    
}

struct DetailView_Previews: PreviewProvider {
    static var previews: some View {
        NavigationView {
            DetailView(viewModel: EntryListViewModel())
        }
    }
}
