//
//  StoriesRepository.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 08.12.2022.
//

import Foundation
import RxSwift

protocol StoriesRepository {
    func getStories() -> Single<Stories>
}

class StoriesRepositoryImplementation: StoriesRepository {
    
    let networkService: NetworkServiceProtocol
    
    init(networkService: NetworkServiceProtocol = NetworkService()) {
        self.networkService = networkService
    }
    
    func getStories() -> Single<Stories> {
        networkService.getStories()
            .map { Stories(items: $0.items.map { Story(id: $0.id,
                                                       title: $0.title,
                                                       description: $0.description,
                                                       imageUrl: $0.imageUrl)}) }
    }
}
