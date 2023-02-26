//
//  AnimeApp.swift
//  Anime
//
//  Created by Kenny Yim on 24/02/23.
//

import SwiftUI

@main
struct AnimeApp: App {
    var body: some Scene {
        WindowGroup {
            let networkService = NetworkService(baseURLString: "https://api.jikan.moe/v4/")
            let viewModel = AnimesScreenViewModel(networkService: networkService)
            ContentView(viewModel: viewModel)
        }
    }
}
