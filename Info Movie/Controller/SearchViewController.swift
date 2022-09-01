//
//  TableViewController.swift
//  Info Movie
//
//  Created by Fábio Silva  on 23/08/2022.
//

import UIKit

class SearchViewController: UITableViewController {
    

    private var movieManager = MovieManager()
    private var movieModel = [MovieModel]()
    private var idTag: Int?
    private var isLandscape = false
    private var filterMethod = "search/movie"
    private var query = ""
    
    override func viewDidLoad() {
        
        super.viewDidLoad()
        
        

        tableView.register(MainTableViewCell.nib(), forCellReuseIdentifier: MainTableViewCell.identifier)
        
        movieManager.delegate = self
    }
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        isLandscape = UIDevice.current.orientation.isLandscape
        tableView.reloadData()
    }
    
    
    
    // MARK: - Table view data source
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        //        if you need to upload all the images in the future
        //        let numberOfLines = Double(movieModel.count)/3
        //        return Int(ceil(numberOfLines))
        
        var numberRows: Int
        
        if isLandscape {
            numberRows = movieModel.count/6
        } else {
            numberRows = movieModel.count/3
        }
        return numberRows
    }
    
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
       var rowHight: CGFloat
        
        if isLandscape {
            rowHight = 0.25 * self.view.safeAreaFrame.width
        } else {
            rowHight = 0.5 * self.view.safeAreaFrame.width
        }
        return rowHight
     }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: MainTableViewCell.identifier, for: indexPath) as! MainTableViewCell
        
        let tapGestureRecognizer1 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image1.addGestureRecognizer(tapGestureRecognizer1)
        let tapGestureRecognizer2 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image2.addGestureRecognizer(tapGestureRecognizer2)
        let tapGestureRecognizer3 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image3.addGestureRecognizer(tapGestureRecognizer3)
        let tapGestureRecognizer4 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image4.addGestureRecognizer(tapGestureRecognizer4)
        let tapGestureRecognizer5 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image5.addGestureRecognizer(tapGestureRecognizer5)
        let tapGestureRecognizer6 = UITapGestureRecognizer(target: self, action: #selector(viewImage(_:)))
        cell.image6.addGestureRecognizer(tapGestureRecognizer6)
        
        cell.configure(with: movieModel, at: indexPath.row, isLandscape: self.isLandscape)
        
        return cell
    }
    
    @objc func viewImage(_ sender: AnyObject) {
        let tag = sender.view.tag
        idTag = tag
        performSegue(withIdentifier: "SearchToInfo", sender: self)
    }
    
    // Passar info para outro view controller
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "SearchToInfo" {
            let destinationVC = segue.destination as! InfoViewController
            // need update !
            destinationVC.id = movieModel[idTag!].id
        }
    }
    
    //MARK: - TableView Delegate
    
    override func tableView(_ tableView: UITableView, willDisplay cell: UITableViewCell, forRowAt indexPath: IndexPath) {
        
        var numberRows: Int
        
        if isLandscape {
            numberRows = movieModel.count/6-1
        } else {
            numberRows = movieModel.count/3-1
        }
        if indexPath.row == numberRows  {
            loadMore()
            
        }
    }
       
    //MARK: - LoadMore
    
    private var nextPage = 1
    private var currentPage = 1
    
    func loadMore() {
        
        if let modelPage = movieModel.last?.currentPage, let totalPages = movieModel.last?.totalPages {
            currentPage = modelPage
            if modelPage < totalPages {
                nextPage = currentPage + 1
                movieManager.fetchMovies(page: nextPage, sort: filterMethod, query: query)
            }
        } else {
            movieManager.fetchMovies(page: nextPage, sort: filterMethod, query: query)
        }
       }
    }

//MARK: - MovieManagerDelegate

extension SearchViewController: MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel]) {
        DispatchQueue.main.async {
            
            for n in movie {
                self.movieModel.append(n)
            }
            
            self.tableView.reloadData()
        }
    }
    func didFailWithError(error: Error) {
        
        DispatchQueue.main.async {
            
            let alert = UIAlertController(title: "Error", message: nil, preferredStyle: .alert)
            let action = UIAlertAction(title: "Dismiss", style: .default) { action in
            }
            alert.addAction(action)
            self.present(alert, animated: true, completion: nil)
        }
        print("aqui\(error)")
    }   
}

//MARK: - UISearchBarDelegate

extension SearchViewController: UISearchBarDelegate {
    
    func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
        if let searchText = searchBar.text {
            self.movieModel = []
            self.tableView.reloadData()
            self.query = "&query=\(searchText.replacingOccurrences(of: " ", with: "%20"))"
            searchBar.resignFirstResponder()
            loadMore()
        }
    }
}
