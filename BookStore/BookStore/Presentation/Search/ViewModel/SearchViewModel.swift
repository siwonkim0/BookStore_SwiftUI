//
//  SearchViewModel.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/19.
//

import Foundation
import Combine

final class SearchViewModel: ObservableObject, Identifiable {
    @Published var keyword: String = ""
    @Published var books: [Book] = []
    var page: Int = 1
    var isLastPage = false
    
    private var cancellables = Set<AnyCancellable>()
    private let searchUseCase: SearchUseCaseType
    
    init(searchUseCase: SearchUseCaseType) {
        self.searchUseCase = searchUseCase
        subscribeKeyword()
    }
    
    private func subscribeKeyword() {
        $keyword
            .debounce(for: .seconds(0.5), scheduler: DispatchQueue.main)
            .print()
            .sink { [weak self] keyword in
                guard let self = self else {
                    return
                }
                self.page = 1
                self.isLastPage = false
                self.books = []
                if keyword.count > 1 {
                    self.getNewBookList(with: keyword)
                }
            }
            .store(in: &cancellables)
    }
    
    func getNewBookList(with keyword: String) {
        searchUseCase.getBookList(with: keyword, page: page)
            .receive(on: DispatchQueue.main)
            .catch({ error in
                Just(
                    BookList(
                        currentPage: "",
                        totalPage: "",
                        books: []
                    ))
            })
            .sink { [weak self] bookList in
                guard let self = self else {
                    return
                }
                if bookList.totalPage == "1" {
                    self.isLastPage = true
                }
                self.books = bookList.books
            }
            .store(in: &cancellables)
    }
    
    func loadMoreBookList() {
        self.page += 1
        searchUseCase.getBookList(with: keyword, page: page)
            .receive(on: DispatchQueue.main)
            .catch { error in
                Just(
                    BookList(
                        currentPage: "",
                        totalPage: "",
                        books: []
                    ))
            }
            .map { bookList -> BookList in
                if bookList.books == [] {
                    self.isLastPage = true
                }
                return bookList
            }
            .sink { [weak self] bookList in
                guard let self = self else {
                    return
                }
                self.books.append(contentsOf: bookList.books)
            }
            .store(in: &cancellables)
    }
    
}