//
//  ContentView.swift
//  Anime
//
//  Created by Kenny Yim on 24/02/23.
//

import SwiftUI

struct ContentView: View {
    
    @ObservedObject var viewModel: AnimesScreenViewModel

    var body: some View {
        let state = viewModel.state

        switch state {
        case .idle:
            Color.clear.onAppear(perform: viewModel.loadData)
        case .loading:
            ProgressView()
        case .success(let loadedViewModel):
            VStack(alignment: .leading) {
                List {
                    ForEach(loadedViewModel.animes.indices, id: \.self) { index in

                        let anime = loadedViewModel.animes[index]

                        VStack(alignment: .leading, spacing: 12) {
                            Text(anime.title)
                                .font(.title)
                                .fontWeight(.bold)
                            Text("\(anime.rank)")
                                .font(.body)
                                .fontWeight(.medium)
                        }.onTapGesture {
                            viewModel.postSelected(at: index)
                        }
                    }
                }
            }
            .sheet(item: $viewModel.selectedAnime) { selectedAnime in
                Text(selectedAnime.title)
            }
        case .failed(let errorViewModel):
            Color.clear.alert(isPresented: $viewModel.showErrorAlert) {
                Alert(
                    title: Text("Error"),
                    message: Text(errorViewModel.message),
                    dismissButton: .default(Text("OK"))
                )
            }
        }
    }
}
