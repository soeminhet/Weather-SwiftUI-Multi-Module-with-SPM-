//
//  HomeViewModel.swift
//  Weather
//
//  Created by Soe Min Htet on 21/06/2024.
//

import Foundation
import Factory
import Combine
import Data

@Observable class HomeViewModel {
    @ObservationIgnored
    @Injected(\.repository) private var repository
    
    @ObservationIgnored
    private var cancellables: Set<AnyCancellable> = []
    
    @ObservationIgnored
    private var savedCities: [CityEntity] = []
    
    @ObservationIgnored
    private let searchTextChanged = PassthroughSubject<String, Never>()
    
    var loading: Bool = false
    var citiesWeatherData: [UUID: CurrentWeatherData] = [:]
    var searchCities: [CityData] = []
    
    init() {
        loading = true
        repository.savedCities
            .sink { [weak self] cities in
                guard let self = self else { return }
                savedCities = cities
                Task {
                    let data = try await self.repository.fetchCurrentWeaterData(cities: cities)
                    self.loading = false
                    self.citiesWeatherData = data
                }
            }
            .store(in: &cancellables)
        
        setupSearchDebounce()
    }
    
    func addCity(city: CityData) {
        loading = true
        repository.addCity(name: city.name, lat: city.lat, lon: city.lon, state: city.state)
    }
    
    func deleteCity(cityId: UUID) {
        print("Delete")
        if let city = savedCities.first(where: { $0.id == cityId }) {
            print("Found")
            loading = true
            repository.deleteCity(city: city)
        } else {
            print("Not Found")
        }
    }
    
    func searchCities(cityName: String) async throws -> [CityData] {
        try await repository.searchCities(cityName: cityName)
    }
        
    func updateSearchText(_ text: String) {
        if !text.isEmpty {
            loading = true
        }
        searchTextChanged.send(text)
    }
    
    private func setupSearchDebounce() {
        searchTextChanged
            .debounce(for: .milliseconds(500), scheduler: RunLoop.main)
            .sink { [weak self] value in
                guard let self = self else { return }
                if value.isEmpty {
                    self.searchCities = []
                } else {
                    Task {
                        self.searchCities = try await self.searchCities(cityName: value)
                        self.loading = false
                    }
                }
            }
            .store(in: &cancellables)
    }
}
