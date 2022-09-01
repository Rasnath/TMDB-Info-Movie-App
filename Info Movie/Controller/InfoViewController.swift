//
//  InfoViewController.swift
//  Info Movie
//
//  Created by Fábio Silva  on 24/08/2022.
//

import UIKit

class InfoViewController: UIViewController {
    
    @IBOutlet weak var traillerOutlet: UIButton!
    
    @IBOutlet weak var overViewLabel: UILabel!
    @IBOutlet weak var backDropImageView: UIImageView!
    @IBOutlet weak var movieTitle: UILabel!
    @IBOutlet weak var movieTagLine: UILabel!
    
    @IBOutlet weak var ratingLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    @IBOutlet weak var CastColletionView: UICollectionView!
    
    @IBOutlet weak var stackView: UIStackView!
    
    private var infoMovieManager = InfoMovieManager()
  
    var id: Int?
     
    private var castImages = [CastModel]()
    private var trailerID = ""
    
    
    override func viewDidLoad() {
        
        
        super.viewDidLoad()
        
        stackView.isHidden = true

        infoMovieManager.delegate = self
        
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
        
        if let id = self.id{
            infoMovieManager.searchMovie(id: id)
        }
     
        CastColletionView.register(CollectionViewCell.nib(), forCellWithReuseIdentifier: CollectionViewCell.identifier)
        CastColletionView.delegate = self
        CastColletionView.dataSource = self
}
    
    
    override func willTransition(to newCollection: UITraitCollection, with coordinator: UIViewControllerTransitionCoordinator) {
        if UIDevice.current.orientation.isLandscape {
            stackView.axis = .horizontal
        } else {
            stackView.axis = .vertical
        }
        
    }
    
    @IBAction func videoButton(_ sender: Any) {
        performSegue(withIdentifier: "InfoToVideo", sender: self)
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "InfoToVideo" {
            let destinationVC = segue.destination as! VideoViewController
            destinationVC.videoID = trailerID
        }
    }
    
}

//MARK: - InfoMovieManagerDelegate

extension InfoViewController: InfoMovieManagerDelegate{
    func didUpdateMovie(_ movieManager: InfoMovieManager, movie: InfoMovieModel) {
        DispatchQueue.main.async {
            
            self.movieTagLine.text = movie.tagLine
            self.movieTitle.text = movie.title
            if let backDropImage = movie.backdropImage {
                self.backDropImageView.image = backDropImage
            }
            self.overViewLabel.text = movie.overView
            self.castImages = movie.castInfo
            // first index with video contain trailler is official and site youtube
            let index = movie.videos.firstIndex(where: { $0.type.lowercased().contains("trailer") && $0.official == true && $0.site.lowercased().contains("youtube") })
            if index == nil {
                self.traillerOutlet.isHidden = true
            } else {
                self.trailerID = "\(movie.videos[index!].key)"
            }
            self.yearLabel.text = String(movie.releaseDate.prefix(4))
            self.ratingLabel.text = String(format: "%.2f", movie.voteAverage)
            self.CastColletionView.reloadData()
            self.stackView.isHidden = false
        }
    }
    
    func didFailWithError(error: Error) {
        print(error)
    }

}

//MARK: - UICollectionViewDataSource, UICollectionViewDelegate

extension InfoViewController: UICollectionViewDataSource, UICollectionViewDelegate {
 
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return castImages.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: CollectionViewCell.identifier, for: indexPath) as! CollectionViewCell
        cell.configure(with: castImages[indexPath.row])
        return cell
    }
   
}
