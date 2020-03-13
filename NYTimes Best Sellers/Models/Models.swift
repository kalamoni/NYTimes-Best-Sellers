//
//  Models.swift
//  NYTimes Best Sellers
//
//  Created by Mohamed Salama on 3/12/20.
//  Copyright © 2020 Mohamed Salama. All rights reserved.
//

import Foundation

struct Cat: Codable, Equatable {
    let id: String
    let imageURL: String
    let width: Int
    let height: Int
    
    private enum CodingKeys: String, CodingKey {
        case id
        case imageURL = "url"
        case width
        case height
    }
}

struct ErrorResponse: Codable {
    let fault: Fault
}

struct Fault: Codable {
    let message: String
    let detail: Detail
    
    private enum CodingKeys: String, CodingKey {
        case message = "faultstring"
        case detail
    }
}

struct Detail: Codable {
    let errorCode: String
    
    private enum CodingKeys: String, CodingKey {
        case errorCode = "errorcode"
    }
}

struct BooksResponse: Codable {
    let status: String
    let copyright: String
    let numberOfResults: Int
    let lastModified: String
    let results: ResultResponse
    
    enum CodingKeys: String, CodingKey {
        case status
        case copyright
        case numberOfResults = "num_results"
        case lastModified = "last_modified"
        case results
    }
}

struct ResultResponse: Codable {
    let listName: String
    let listNameEncoded: String
    let bestsellersDate: String
    let publishedDate: String
    let publishedDateDescription: String
    let nextPublishedDate: String
    let previousPublishedDate: String
    let displayName: String
    let normalListEndsAt: Int
    let updated: String
    let books: [Book]
    
    enum CodingKeys: String, CodingKey {
        case listName = "list_name"
        case listNameEncoded = "list_name_encoded"
        case bestsellersDate = "bestsellers_date"
        case publishedDate = "published_date"
        case publishedDateDescription = "published_date_description"
        case nextPublishedDate = "next_published_date"
        case previousPublishedDate = "previous_published_date"
        case displayName = "display_name"
        case normalListEndsAt = "normal_list_ends_at"
        case updated
        case books
    }
}

struct Book: Codable {
    let rank: Int
    let rankLastWeek: Int
    let weeksOnList: Int
    let asterisk: Int
    let dagger: Int
    let primaryISBN10: String
    let primaryISBN13: String
    let publisher: String
    let bookDescription: String
    let price: Int
    let title: String
    let author: String
    let contributor: String
    let contributorNote: String
    let bookImage: String
    let bookImageWidth: Int
    let bookImageHeight: Int
    let amazonProductURL: String
    let ageGroup: String
    let bookReviewLink: String
    let firstChapterLink: String
    let sundayReviewLink: String
    let articleChapterLink: String
    let isbns: [ISBN]
    let buyLinks: [BuyLink]
    let bookURI: String
    
    enum CodingKeys: String, CodingKey {
        case rank
        case rankLastWeek = "rank_last_week"
        case weeksOnList = "weeks_on_list"
        case asterisk, dagger
        case primaryISBN10 = "primary_isbn10"
        case primaryISBN13 = "primary_isbn13"
        case publisher
        case bookDescription = "description"
        case price, title, author, contributor
        case contributorNote = "contributor_note"
        case bookImage = "book_image"
        case bookImageWidth = "book_image_width"
        case bookImageHeight = "book_image_height"
        case amazonProductURL = "amazon_product_url"
        case ageGroup = "age_group"
        case bookReviewLink = "book_review_link"
        case firstChapterLink = "first_chapter_link"
        case sundayReviewLink = "sunday_review_link"
        case articleChapterLink = "article_chapter_link"
        case isbns
        case buyLinks = "buy_links"
        case bookURI = "book_uri"
    }
}

struct BuyLink: Codable {
    let name, url: String
}

struct ISBN: Codable {
    let isbn10, isbn13: String
}
