//
//  CoreDataManager.swift
//  BookStore
//
//  Created by Siwon Kim on 2022/09/28.
//

import SwiftUI
import CoreData
import Combine

protocol CoreDataManagerType {
    func fetch(request: NSFetchRequest<BookEntity>) -> AnyPublisher<[BookEntity], Error>
    func add(bookList: BookList, keyword: String) throws
    func delete(entity: BookEntity) throws
    func update(entity: BookEntity) throws
}

class CoreDataManager: CoreDataManagerType {
    static let persistentContainer = CoreDataManager()
    private let container = NSPersistentContainer(name: "BookContainer")
    
    private init() {
        loadPersistentContainer()
    }
    
    private func loadPersistentContainer() {
        container.loadPersistentStores { description, error in
            if let error = error {
                print("Error Loading Core Data. \(error.localizedDescription)")
            }
        }
    }

    func fetch(request: NSFetchRequest<BookEntity>) -> AnyPublisher<[BookEntity], Error> {
        return Future<[BookEntity], Error> { promise in
            guard let entities = try? self.container.viewContext.fetch(request),
                  entities.count != 0 else {
                promise(.failure(CoreDataError.invalidData))
                return
            }
            return promise(.success(entities))
        }
        .receive(on: DispatchQueue.main)
        .eraseToAnyPublisher()
    }
    
    func add(bookList: BookList, keyword: String) throws {
        var sortNumber = 1
        bookList.books.forEach { book in
            let bookEntity = BookEntity(context: container.viewContext)
            bookEntity.id = book.id
            bookEntity.title = book.title
            bookEntity.subtitle = book.subtitle
            bookEntity.isbn13 = book.isbn13
            bookEntity.price = book.price
            bookEntity.imageUrl = book.image
            bookEntity.url = book.url
            bookEntity.searchKeyword = keyword
            bookEntity.page = bookList.currentPage
            bookEntity.sortNumber = Int64(sortNumber)
            sortNumber += 1
        }
        do {
            try save()
        } catch {
            throw CoreDataError.failedToAdd
        }
    }
    
    func delete(entity: BookEntity) throws {
        container.viewContext.delete(entity)
        do {
            try save()
        } catch {
            throw CoreDataError.failedToAdd
        }
    }
    
    func update(entity: BookEntity) throws {
        do {
            try save()
        } catch {
            throw CoreDataError.failedToUpdate
        }
    }
    
    private func save() throws {
        do {
            try container.viewContext.save()
        } catch {
            throw CoreDataError.failedToSave
        }
    }
}
