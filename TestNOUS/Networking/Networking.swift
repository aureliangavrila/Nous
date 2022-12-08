//
//  Networking.swift
//  TestNOUS
//
//  Created by Aurelian Gavrila on 07.12.2022.
//

import Foundation
import RxCocoa
import RxSwift

protocol NetworkServiceProtocol {
    func getStories() -> Single<StoriesDto>
}

enum NetworkError: Error {
    case badURL
    case badResponse
    case invalidData
    case unknown
}

class NetworkService: NetworkServiceProtocol {
    enum NetworkConstants {
        static let urlPath = "https://cloud.nousdigital.net/s/rNPWPNWKwK7kZcS/download"
    }
    
    private let session: URLSession
    
    public init(session: URLSession = URLSession.shared) {
        self.session = session
    }
    
    func getStories() -> Single<StoriesDto> {
        getItems(url: NetworkConstants.urlPath)
    }
}

extension NetworkService {
    private func getItems<T: Decodable>(url: String) -> Single<T> {
        return  Single.create { single in
            guard let url = URL(string: url) else {
                single(.failure(NetworkError.badURL))
                return Disposables.create {}
            }

            var request = URLRequest(url: url)
            request.httpMethod = "GET"

            let task = self.session.dataTask(with: request) { data, response, error in
                guard let responseStatus = response as? HTTPURLResponse, responseStatus.statusCode == 200 else {
                    single(.failure(NetworkError.badResponse))
                    return
                }

                guard let data = data, error == nil else {
                    single(.failure(NetworkError.unknown))
                    return
                }

                guard let decodedData = try? JSONDecoder().decode(T.self, from: data) else {
                    single(.failure(NetworkError.invalidData))
                    return
                }

                single(.success(decodedData))
            }
            task.resume()

            return Disposables.create {
                task.cancel()
            }
        }
        
        
//        guard let url = URL(string: url) else {
//            return .error(NetworkError.badURL)
//        }
//
//        var request = URLRequest(url: url)
//        request.httpMethod = "GET"
//
//        return self.session.rx.response(request: request)
//            .retry(1)
//            .observe(on: MainScheduler.instance)
//            .map(\.data)
//            .decode(type: T.self, decoder: JSONDecoder())
//            .debug()
//            .asSingle()
    }
}
