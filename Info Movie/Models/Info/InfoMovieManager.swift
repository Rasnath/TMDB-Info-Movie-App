//
//  MovieManager.swift
//  Info Movie
//
//  Created by Fábio Silva  on 23/08/2022.
//

import Foundation

import UIKit

protocol InfoMovieManagerDelegate {
    func didUpdateMovie(_ movieManager: InfoMovieManager, movie: InfoMovieModel)
    func didFailWithError(error: Error)
}

struct InfoMovieManager{
    
    var delegate: InfoMovieManagerDelegate?
    
    let baseUrl = "https://api.themoviedb.org/3/"
    let apiKey = K.apiKey
    
    func searchMovie(id: Int) {
        let urlString = "\(baseUrl)movie/\(id)?api_key=\(apiKey)&append_to_response=credits,videos"
        performRequest(whith: urlString)
        print(urlString)
    }
    
    func performRequest(whith urlString: String) {
        //create URL
        if let url = URL(string: urlString) {
            //Create URL session
            let urlSession = URLSession(configuration: .default)
            // give a task to the session
            let task = urlSession.dataTask(with: url) { data, response, error in
                if error != nil{
                    delegate?.didFailWithError(error: error!)
                    return
                }
                if let safeData = data{
                    if let movie = parseJSON(safeData){
                        
                        delegate?.didUpdateMovie(self, movie: movie)
                    }
                }
            }
            // start task
            task.resume()
        }
    }
    func parseJSON(_ movieData: Data) -> InfoMovieModel?{
        let decoder = JSONDecoder()
        do {
            
            var backDropImage: UIImage?
            let decodedData = try decoder.decode(InfoMovieData.self, from: movieData)
            if let backDropPath = decodedData.backdrop_path {
                backDropImage = self.urlToImage(urlPath: "https://image.tmdb.org/t/p/w780\(backDropPath)")
            }
            let overView = decodedData.overview
            let title = decodedData.title
            let releaseDate = decodedData.release_date
            let voteAverage = decodedData.vote_average
            let tagLine = decodedData.tagline
            
            let castString = decodedData.credits.cast
            var castArray: [CastModel] = []
            
            for cast in castString {
                if let image = cast.profile_path {
                    let imageURL = "https://image.tmdb.org/t/p/w185\(image)"
                    if let image = self.urlToImage(urlPath: imageURL) {
                        castArray.append(CastModel(castImage: image, castName: cast.name))
                     }
                }
            }
            
            
            let videos = decodedData.videos.results
            
            
       
            

            let infoMovie = InfoMovieModel(backdropImage: backDropImage,
                                           overView: overView,
                                           title: title,
                                           releaseDate: releaseDate,
                                           voteAverage: voteAverage,
                                           tagLine: tagLine,
                                           castInfo: castArray,
                                           videos: videos)
            
            return infoMovie
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func urlToImage(urlPath: String) -> UIImage? {
        if let url = URL(string: urlPath){
            let data = try? Data(contentsOf: url)
            
            if let imageData = data {
                let image = UIImage(data: imageData)
                return image
            }
        }
        return nil
    }
}


