//
//  BooksController.swift
//  NYTimes Best Sellers
//
//  Created by Mohamed Salama on 3/12/20.
//  Copyright © 2020 Mohamed Salama. All rights reserved.
//

import UIKit

class BooksController {
    
    private struct Constant {
        static let ranking = 0
        static let weeksOnList = 1
    }
    
    private init() { }
    
    /// The shared instance of the books  controller singleton.
    static var shared = BooksController()
    
    private var booksResponse: BooksResponse?
    private var booksSortedByRanking: [Book] = []
    private var booksSortedByWeeksOnList: [Book] = []
    var books: [Book] = []
    private var selectedSortIndex = 0
    
    /**
     Retrieves an array of books  objects using the netwrok controller, and calls a handler upon completion.
     
     - parameter completionHandler: The completion handler to call when the load request is complete. This handler is executed on the delegate queue.
     
     - author: Mohamed Salama
     */
    func fetchBooks(completionHandler: @escaping (_ books: BooksResponse?) -> Void) {
        
        NetworkController.shared.fetchBooks { result in
            switch result {
            case .success(let response):
                self.booksResponse = response
                self.books = response.results.books
                self.sortBooks()
                self.setSortingType(withIndex: self.selectedSortIndex)
                completionHandler(self.booksResponse)
            case .failure( _):
                completionHandler(nil)
            }
        }
    }
    
    /**
    Making the inital sorting and save the result to a local private properties.
    
    - author: Mohamed Salama
    */
    private func sortBooks() {
        booksSortedByRanking = books.sorted { $0.rank < $1.rank }
        booksSortedByWeeksOnList = books.sorted { $0.weeksOnList > $1.weeksOnList }
    }
    
    /**
    Sets the selected sorting index and selects the sorted array of books accordingly.
    
    - author: Mohamed Salama
    */
    func setSortingType(withIndex index: Int) {
        selectedSortIndex = index
        switch index {
        case Constant.ranking:
            books = booksSortedByRanking
        case Constant.weeksOnList:
            books = booksSortedByWeeksOnList
        default:
            books = booksSortedByRanking
        }
    }
    
    /**
     Retrieves an image URL over the netwrok controller, and calls a handler upon completion.
     
     - parameter imgURL: A string represents the full image URL.
     - parameter completionHandler: The completion handler to call when the load request is complete. This handler is executed on the delegate queue.
     
     - remark: Checks if the image is available in the cache before fetching it over the network. If not present, the image is fetched and cached for future usage.
     - author: Mohamed Salama
     */
    func fetchImage(withURL imgURL: String, completionHandler: @escaping (_ image: UIImage?) -> Void) {
        NetworkController.shared.fetchImage(withURL: imgURL) { (result) in
            switch result {
            case .success(let image):
                completionHandler(image)
            case .failure( _):
                completionHandler(nil)
            }
        }
    }
    
}
