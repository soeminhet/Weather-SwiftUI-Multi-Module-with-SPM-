//
//  SearchListView.swift
//  Weather
//
//  Created by Soe Min Htet on 21/06/2024.
//

import SwiftUI
import Data

struct SearchListView: View {
    
    @Environment(\.dismissSearch) private var dismissSearch
    let searchCities: [CityData]
    let onTouch: (CityData) -> Void
    
    var body: some View {
        ForEach(searchCities, id: \.self) { city in
            Text("\(city.name), \(city.state)")
                .onTapGesture {
                    onTouch(city)
                    dismissSearch()
                }
        }
    }
}

#Preview {
    SearchListView(searchCities: [CityData.fakeData()]) { data in
        
    }
}
