//
//  BookStoreApp.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import SwiftUI

@main
struct BookStoreApp: App {
    let searchViewModel = SearchViewModel(
        searchRepository: SearchRepository(
                urlSessionManager: URLSessionManager(
                    urlSession: URLSession.shared
                ), coreDataManager: CoreDataManager()
            ))
    
    var body: some Scene {
        WindowGroup {
            SearchView(viewModel: searchViewModel)
        }
    }
}
