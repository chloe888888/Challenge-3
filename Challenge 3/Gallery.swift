//
//  InventoryView.swift
//  Challenge 3
//
//  Created by Sam Tan on 15/11/25.
//

import SwiftUI

struct GalleryView: View {
    private var listOfCountry = countryList
    @State var searchText = ""
    var body: some View {
        NavigationView {
            List {
                ForEach(countries, id: \.self) { country in
                    HStack {
                        Text(country.description.capitalized)
                        Spacer()
                        Image(systemName: "star")
                    }
                    .padding()
                }
            }
            .searchable(text: $searchText)
            .navigationTitle("Gallary of Jar")
        }
    }
    var countries: [String] {
        let lcCountries = listOfCountry.map { $0.lowercased() }
        return searchText == "" ? lcCountries : lcCountries.filter {
            $0.contains(searchText.lowercased())
        }
    }
}
struct GalleryVIew_Preview: PreviewProvider {
    static var previews: some View {
        GalleryView()
    }
}

