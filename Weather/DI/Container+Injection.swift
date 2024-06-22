//
//  Container+Injection.swift
//  Weather
//
//  Created by Soe Min Htet on 20/06/2024.
//

import Foundation
import Factory
import Network
import Data
import Domain

extension Container {
    var networkManager: Factory<NetworkingManager> { self { NetworkingManagerImpl() }.singleton }
    
    var remoteDataSource: Factory<RemoteDataSource> { self { RemoteDataSourceImpl(networkManager: self.networkManager.callAsFunction()) }.cached }
    
    var localDataSource: Factory<LocalDataSource> { self { LocalDataSourceImpl() }.cached }
    
    var repository: Factory<Repository> { self { RepositoryImpl(localDataSource: self.localDataSource.callAsFunction(), remoteDataSource: self.remoteDataSource.callAsFunction()) }.cached }
}
