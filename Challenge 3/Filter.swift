//
//  Filter.swift
//  Challenge 3
//
//  Created by Chloe Lin on 16/11/25.
//

import SwiftUI


struct Filter: View {
    @State private var searchText = ""

    let actions = ["Play", "Pause", "Stop", "Record"]

    var filteredActions: [String] {
        searchText.isEmpty
            ? actions
            : actions.filter { $0.localizedCaseInsensitiveContains(searchText) }
    }

    var body: some View {
        VStack {
            TextField("Filter buttons…", text: $searchText)
                .textFieldStyle(.roundedBorder)
                .padding()

            ForEach(filteredActions, id: \.self) { action in
                Button(action) {
                    print("\(action) pressed")
                }
                .padding()
                .buttonStyle(.bordered)
            }
        }
    }
}
#Preview{
    Filter()
}
