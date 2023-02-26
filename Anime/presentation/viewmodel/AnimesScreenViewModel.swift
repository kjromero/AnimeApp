//
//  AnimesScreenCiewModel.swift
//  Anime
//
//  Created by Kenny Yim on 25/02/23.
//

import Foundation
import Combine
import SwiftUI

class AnimesScreenViewModel: ObservableObject {
    
    
    struct AnimeData: Identifiable {
        let id: Int
        let title: String
        let url: String
        let rank: Int
    }

    struct LoadedViewModel: Equatable {

        static func == (lhs: AnimesScreenViewModel.LoadedViewModel, rhs: AnimesScreenViewModel.LoadedViewModel) -> Bool {
            lhs.id == rhs.id
        }

        let id: Int
        let animes: [AnimeData]
    }

    @Published private(set) var state: LoadingState<LoadedViewModel> = .idle

    @Published var selectedAnime: AnimeData?

    private var animesPublisher: AnyCancellable?

    @State var showErrorAlert = false

    private let networkService: NetworkServiceable

    private var animesData: [AnimeData] = []

    init(networkService: NetworkServiceable) {
        self.networkService = networkService
    }

    func loadData() {

        guard state != .loading else {
            return
        }

        state = .loading

        animesPublisher = networkService.getAnimes().receive(on: DispatchQueue.main).sink { [weak self] completion in
            if case .failure(let error) = completion {
                self?.showErrorAlert = true
                self?.state = .failed(ErrorViewModel(message: error.localizedDescription))
            }
        } receiveValue: { [weak self] animes in

            let animesData = animes.map { AnimeData(id: $0.malId, title: $0.title, url: $0.url, rank: $0.rank) }

            self?.animesData = animesData

            self?.state = .success(.init(id: 0, animes: animesData))
        }
    }

    func postSelected(at index: Int) {
        self.selectedAnime = self.animesData[index]
    }

}
