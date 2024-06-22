//
//  File.swift
//  
//
//  Created by Soe Min Htet on 20/06/2024.
//

import Foundation

public struct CityData: Codable, Hashable {
    public let name: String
    public let lat: Double
    public let lon: Double
    public let state: String
}

extension CityData {
    static public func fakeData() -> CityData {
        return CityData(name: "New York", lat: 40.7128, lon: -74.0060, state: "NY")
    }
}
