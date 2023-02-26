//
//  LoadingState.swift
//  Anime
//
//  Created by Kenny Yim on 26/02/23.
//

import Foundation

struct ErrorViewModel: Equatable {
    let message: String
}

enum LoadingState<LoadedViewModel: Equatable>: Equatable {
    case idle
    case loading
    case failed(ErrorViewModel)
    case success(LoadedViewModel)
}

