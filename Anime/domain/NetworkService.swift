//
//  NetworkService.swift
//  Anime
//
//  Created by Kenny Yim on 25/02/23.
//

import Foundation
import Combine


protocol NetworkServiceable {
    func getAnimes() -> AnyPublisher<[Anime], Never>
}

class NetworkService: NetworkServiceable {

    let urlSession: URLSession
    let baseURLString: String

    init(urlSession: URLSession = .shared, baseURLString: String) {
        self.urlSession = urlSession
        self.baseURLString = baseURLString
    }

    func getAnimes() -> AnyPublisher<[Anime], Never> {

        let urlString = baseURLString + "anime"

        guard let url = URL(string: urlString) else {
            return Just<[Anime]>([]).eraseToAnyPublisher()
        }

        return urlSession.dataTaskPublisher(for: url)
            .map { $0.data }
            .decode(type: [Anime].self, decoder: JSONDecoder())
            .replaceError(with: [])
            .eraseToAnyPublisher()
    }
}
