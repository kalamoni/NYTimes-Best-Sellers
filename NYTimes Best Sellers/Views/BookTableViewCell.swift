//
//  BookTableViewCell.swift
//  NYTimes Best Sellers
//
//  Created by Mohamed Salama on 3/12/20.
//  Copyright © 2020 Mohamed Salama. All rights reserved.
//

import UIKit

class BookTableViewCell: UITableViewCell {
    
    @IBOutlet private weak var bookImageView: UIImageView!
    @IBOutlet private weak var titleLabel: UILabel!
    @IBOutlet private weak var authorLabel: UILabel!
    @IBOutlet private weak var activityIndicator: UIActivityIndicatorView!
    
    func resetCell() {
        tag = 0
        bookImageView.image = nil
        bookImageView.layer.cornerRadius = 6
        titleLabel.text = "NA"
        authorLabel.text = "NA"
    }
    
    func configureCell(withTitle title: String, author: String) {
        titleLabel.text = title
        authorLabel.text = author
    }
    
    func startAnimatingActivityIndicator() {
        activityIndicator.startAnimating()
    }
    
    func stopAnimatingActivityIndicator() {
        activityIndicator.stopAnimating()
    }
    
    func setImage(with image: UIImage?) {
        bookImageView.image = image
    }
}
