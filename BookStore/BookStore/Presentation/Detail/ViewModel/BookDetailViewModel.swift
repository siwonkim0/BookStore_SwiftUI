//
//  BookDetailViewModel.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/10/01.
//

import Foundation
import Combine

final class BookDetailViewModel: ObservableObject {
    @Published var bookDetail: BookDetail = BookDetail(title: "", subtitle: "", authors: "", publisher: "", language: "", isbn13: "", bookPages: "", year: "", rating: "", description: "", price: "", imageUrl: "", url: "", pdf: PDF(chapter2: "", chapter5: ""))
    private var cancellables = Set<AnyCancellable>()
    private let repository: BookDetailRepository
    
    init(repository: BookDetailRepository) {
        self.repository = repository
    }
    
    func getData(with isbn: String) {
        repository.getBookDetails(with: isbn)
            .catch { error in
                return Just(
                    BookDetail(
                        title: "N/A",
                        subtitle: "N/A",
                        authors: "N/A",
                        publisher: "N/A",
                        language: "N/A",
                        isbn13: "N/A",
                        bookPages: "N/A",
                        year: "N/A",
                        rating: "N/A",
                        description: "N/A",
                        price: "N/A",
                        imageUrl: "N/A",
                        url: "N/A",
                        pdf: PDF(
                            chapter2: "N/A",
                            chapter5: "N/A"
                        )))
            }
            .receive(on: DispatchQueue.main)
            .sink { bookDetail in
                self.bookDetail = bookDetail
            }
            .store(in: &cancellables)
    }
}