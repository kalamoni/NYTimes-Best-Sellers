//
//  NetworkController.swift
//  NYTimes Best Sellers
//
//  Created by Mohamed Salama on 3/12/20.
//  Copyright © 2020 Mohamed Salama. All rights reserved.
//

import UIKit

class NetworkController {
    
    private init() {
        configureCache()
    }
    
    /// The shared instance of the Netwrok controller singleton.
    static let shared = NetworkController()
    
    /// The shared local cache of the Netwrok controller singleton.
    private let imageCache = NSCache<NSString, UIImage>()
    
    private struct API {
        static let apiKey = "3GiIylwhoiL0USYYl7IIMDwjqe5FNtqR"
        static let baseURL = "api.nytimes.com"
        static let bestSellerPath = "/svc/books/v3/lists/2019-09-01/combined-print-and-e-book-fiction.json"
    }
    
    /*
     // MARK: - Class Methods
     */
    
    /**
     Configures and sets the global in-memory and disk cache sizes for the URLRequest used in every URLSession request.
     
     - author: Mohamed Salama
     */
    private func configureCache() {
        let temporaryDirectory = NSTemporaryDirectory()
        let urlCache = URLCache(memoryCapacity: 25_000_000,
                                diskCapacity: 50_000_000, diskPath: temporaryDirectory)
        URLCache.shared = urlCache
        
        imageCache.countLimit = 50_000_000
        imageCache.totalCostLimit = 50_000_000
    }
    
    /**
     Purges and emptys the images cache.
     
     - author: Mohamed Salama
     */
    func purgeCache() {
        imageCache.removeAllObjects()
    }
    
    /*
     // MARK: - Books
     */
    /**
     Retrieves an array of books  objects over the netwrok, and calls a handler upon completion.
     
     - parameter completionHandler: The completion handler to call when the load request is complete. This handler is executed on the delegate queue.
     
     - author: Mohamed Salama
     */
    func fetchBooks(completionHandler: @escaping (Result<BooksResponse, NetworkRequestStatus>) -> Void) {
        
        var urlComponents = URLComponents()
        urlComponents.scheme = "https"
        urlComponents.host = API.baseURL
        urlComponents.path = API.bestSellerPath
        urlComponents.queryItems = [
            URLQueryItem(name: "api-key", value: API.apiKey)
        ]
        
        guard let url = urlComponents.url?.absoluteURL else {
            completionHandler(.failure(.encodingError))
            return
        }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if let error = error {
                if error.localizedDescription.contains("timed out") {
                    completionHandler(.failure(.timeout))
                } else {
                    completionHandler(.failure(.error))
                }
            } else if let responseData = data {
                
                do {
                    let decoder = JSONDecoder()
                    if let booksResponse = try? decoder.decode(BooksResponse.self, from: responseData) {
                        completionHandler(.success(booksResponse))
                    } else if let _ = try? decoder.decode(ErrorResponse.self, from: responseData) {
                        completionHandler(.failure(.decodingError))
                    }
                }
                
            } else {
                completionHandler(.failure(.parsingError))
            }
        }.resume()
        
    }
    
    /*
     // MARK: - Fetching Images
     */
    /**
     Retrieves an image URL over the netwrok, and calls a handler upon completion.
     
     - parameter imgURL: A string represents the full image URL.
     - parameter completionHandler: The completion handler to call when the load request is complete. This handler is executed on the delegate queue.
     
     - remark: Checks if the image is available in the cache before fetching it over the network. If not present, the image is fetched and cached for future usage.
     - author: Mohamed Salama
     */
    func fetchImage(withURL imgURL: String, completionHandler: @escaping (Result<UIImage?, NetworkRequestStatus>) -> Void) {
        
//        guard let imagURLPercentEncoded = imgURL.addingPercentEncoding(withAllowedCharacters: CharacterSet.urlQueryAllowed) else {
//            completionHandler(.failure(.invalidPercentEncoding))
//            return
//        }
        
//        if let cachedImage = self.imageCache.object(forKey: imagURLPercentEncoded as NSString) {
//            completionHandler(.success(cachedImage))
//
//        } else {
            let urlAPI = URL(string: imgURL)
            guard let url = urlAPI else {
                completionHandler(.failure(.error))
                return
            }
            var request = URLRequest(url: url)
            request.httpMethod = "GET"
            request.timeoutInterval = 60
            
            URLSession.shared.dataTask(with: request) { data, response, error in
                if let error = error {
                    if error.localizedDescription.contains("timed out") {
                        completionHandler(.failure(.timeout))
                    } else {
                        completionHandler(.failure(.error))
                    }
                } else if let imageData = data, let image = UIImage(data: imageData) {
                    
                    self.imageCache.setObject(image, forKey: imgURL as NSString, cost: imageData.count)
                    completionHandler(.success(image))
                } else {
                    completionHandler(.failure(.error))
                }
            }.resume()
//        }
    }
}
