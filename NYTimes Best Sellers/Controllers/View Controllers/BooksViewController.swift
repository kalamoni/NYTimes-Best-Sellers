//
//  ViewController.swift
//  NYTimes Best Sellers
//
//  Created by Mohamed Salama on 3/12/20.
//  Copyright © 2020 Mohamed Salama. All rights reserved.
//

import UIKit

class BooksViewController: UIViewController {
    
    @IBOutlet weak var tableView: UITableView!
    private let progressHUD = ProgressHUD(text: "Loading")
    
    private struct Constants {
        static let cellIdentifier = String(describing: BookTableViewCell.self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        setupScene()
        fetchData()
    }
    
    /*
     // MARK: - Class Methods
     */
    
    private func setupScene() {
        tableView.delegate = self
        tableView.dataSource = self
        let nib = UINib(nibName: Constants.cellIdentifier, bundle: Bundle(for: BookTableViewCell.self))
        tableView.register(nib, forCellReuseIdentifier: Constants.cellIdentifier)
    }
    
    /**
     Fetches books data over the network using the `Books Controller`.
     
     - author: Mohamed Salama
     */
    private func fetchData() {
        view.addSubview(progressHUD)
        BooksController.shared.fetchBooks { (booksResponse) in
            DispatchQueue.main.async {
                self.progressHUD.removeFromSuperview()
                self.reloadData()
            }
        }
    }
    
    /**
     Reloads the table view data on the main thread.
     
     - author: Mohamed Salama
     */
    private func reloadData() {
        DispatchQueue.main.async {
            self.tableView.reloadSections([0], with: .automatic)
        }
    }
    
    /*
    // MARK: - IBAction Methods
    */
    
    @IBAction func didTapSegmentedControl(_ sender: UISegmentedControl) {
        BooksController.shared.setSortingType(withIndex: sender.selectedSegmentIndex)
        reloadData()
    }
    
    @IBAction func didTapReload(_ sender: UIButton) {
        fetchData()
    }
    
}

extension BooksViewController: UITableViewDelegate {
    
}

extension BooksViewController: UITableViewDataSource {
    
    // MARK: - UITableViewDataSource
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return BooksController.shared.books.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: Constants.cellIdentifier, for: indexPath)
        
        guard let bookCell = cell as? BookTableViewCell, indexPath.row < BooksController.shared.books.count else { return cell }
        
        bookCell.resetCell()
        let book = BooksController.shared.books[indexPath.row]
        bookCell.tag = Int(book.primaryISBN13) ?? 0
        bookCell.configureCell(withTitle: book.title, author: book.author)
        bookCell.startAnimatingActivityIndicator()
        
        BooksController.shared.fetchImage(withURL: book.bookImage) { (image) in
            DispatchQueue.main.async {
                bookCell.stopAnimatingActivityIndicator()
                if bookCell.tag == Int(book.primaryISBN13) {
                    bookCell.setImage(with: image)
                }
            }
        }
        return bookCell
    }
    
}
