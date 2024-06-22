import Foundation
import Data
import Combine

public protocol Repository {
    var savedCities: Published<[CityEntity]>.Publisher { get }
    func fetchCurrentWeaterData(cities: [CityEntity]) async throws -> [UUID: CurrentWeatherData]
    func addCity(
        name: String,
        lat: Double,
        lon: Double,
        state: String
    )
    func deleteCity(city: CityEntity)
    func searchCities(cityName: String) async throws -> [CityData]
}

public class RepositoryImpl: Repository {

    let localDataSource: LocalDataSource
    let remoteDataSource: RemoteDataSource
    
    private var cancellables: Set<AnyCancellable> = []
    @Published var savedCitiesPublisher: [CityEntity] = []
    public var savedCities: Published<[CityEntity]>.Publisher { $savedCitiesPublisher }
    
    public init(
        localDataSource: LocalDataSource,
        remoteDataSource: RemoteDataSource
    ){
        self.localDataSource = localDataSource
        self.remoteDataSource = remoteDataSource
        
        localDataSource.savedCitied
            .sink { [weak self] cities in
                self?.savedCitiesPublisher = cities
            }
            .store(in: &cancellables)
    }
    
    public func fetchCurrentWeaterData(cities: [CityEntity]) async throws -> [UUID: CurrentWeatherData] {
        var citiesWeatherData: [UUID: CurrentWeatherData] = [:]
        
        for city in cities {
            let weatherData = try await remoteDataSource.getCurrentWeatherData(lat: city.lat, lon: city.lon)
            citiesWeatherData[city.id!] = weatherData
        }
            
        return citiesWeatherData
    }
    
    public func addCity(
        name: String,
        lat: Double,
        lon: Double,
        state: String
    ) {
        localDataSource.addCity(name: name, lat: lat, lon: lon, state: state)
    }
    
    public func deleteCity(city: CityEntity) {
        localDataSource.delete(entity: city)
    }
    
    public func searchCities(cityName: String) async throws -> [CityData] {
        try await remoteDataSource.getCityNames(cityName: cityName)
    }
}
