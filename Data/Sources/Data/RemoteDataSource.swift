//
//  File.swift
//  
//
//  Created by Soe Min Htet on 19/06/2024.
//

import Foundation
import Network

public protocol RemoteDataSource {
    func getCurrentWeatherData(lat: Double, lon: Double) async throws-> CurrentWeatherData
    func getCurrentWeatherData(cityName: String) async throws -> CurrentWeatherData
    func getCityNames(cityName: String) async throws -> [CityData]
}

public class RemoteDataSourceImpl: RemoteDataSource {
    
    private let networkManager: NetworkingManager
    
    public init(networkManager: NetworkingManager){
        self.networkManager = networkManager
    }
    
    public func getCurrentWeatherData(lat: Double, lon: Double) async throws-> CurrentWeatherData {
        let url = "https://api.openweathermap.org/data/2.5/weather?lat=\(lat)&lon=\(lon)&appid=39176ae34e6cdf4ea05cb82b333deb63"
        return try await networkManager.getData(urlString: url, dateDecodingStrategy: .secondsSince1970)
    }
    
    public func getCurrentWeatherData(cityName: String) async throws -> CurrentWeatherData {
        let url = "https://api.openweathermap.org/data/2.5/weather?q=\(cityName)&appid=39176ae34e6cdf4ea05cb82b333deb63"
        return try await networkManager.getData(urlString: url, dateDecodingStrategy: .secondsSince1970)
    }
    
    public func getCityNames(cityName: String) async throws -> [CityData] {
        let url = "https://api.openweathermap.org/geo/1.0/direct?q=\(cityName)&limit=3&appid=39176ae34e6cdf4ea05cb82b333deb63"
        return try await networkManager.getData(urlString: url)
    }
}
