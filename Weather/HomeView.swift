//
//  ContentView.swift
//  Weather
//
//  Created by Soe Min Htet on 19/06/2024.
//
import SwiftUI
import SwipeActions

struct HomeView: View {
    @State private var searchText = ""
    @State var homeViewModel: HomeViewModel = HomeViewModel()
    
    var body: some View {
        NavigationStack {
            ZStack {
                ScrollView {
                    LazyVStack {
                        ForEach(homeViewModel.citiesWeatherData.sorted(by: { $0.key < $1.key}), id: \.key) { key, data in
                            WeatherCell(data: data)
                                .addSwipeAction(edge: .trailing) {
                                    Button {
                                        homeViewModel.deleteCity(cityId: key)
                                    } label: {
                                        Image(systemName: "trash")
                                            .foregroundColor(.white)
                                    }
                                    .frame(width: 80, alignment: .center)
                                    .frame(maxHeight: .infinity)
                                    .contentShape(Rectangle())
                                    .background(Color.red)
                                }
                                .cornerRadius(10)
                                .padding(.horizontal)
                                .frame(maxWidth: .infinity)
                                
                        }
                    }
                }
                .scrollBounceBehavior(.basedOnSize)
                .navigationTitle("Weather")
                
                if homeViewModel.loading {
                    LoadingView()
                }
            }
            .searchable(text: $searchText, prompt: "Search for a city") {
                SearchListView(searchCities: homeViewModel.searchCities) { city in
                    homeViewModel.addCity(city: city)
                    searchText = ""
                }
            }
            .onChange(of: searchText) { _ , value in
                homeViewModel.updateSearchText(value)
            }
        }
    }
}

#Preview {
    HomeView()
}
