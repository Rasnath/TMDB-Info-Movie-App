//
//  MovieManager.swift
//  Info Movie
//
//  Created by Fábio Silva  on 23/08/2022.
//

import Foundation

import UIKit

protocol MovieManagerDelegate {
    func didUpdateMovie(_ movieManager: MovieManager, movie: [MovieModel])
    func didFailWithError(error: Error)
}

struct MovieManager{
    
    var delegate: MovieManagerDelegate?
    var lastUrl = ""
    
    let baseUrl = "https://api.themoviedb.org/3/"
    let apiKey = K.apiKey
    
    
    mutating func fetchMovies(page: Int, sort: String, query: String = "") {
        let urlString = "\(baseUrl)\(sort)?api_key=\(apiKey)&page=\(page)\(query)"
        if urlString != lastUrl {
            performRequest(whith: urlString)
            lastUrl = urlString
        }
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
    
    func parseJSON(_ movieData: Data) -> [MovieModel]?{
        let decoder = JSONDecoder()
        do {
            
            let decodedData = try decoder.decode(MovieData.self, from: movieData)
            
            let results = decodedData.results
            
            let currentPage = decodedData.page
            var totalPages: Int{
                if decodedData.total_pages > 500 {
                    return 500
                } else {
                    return decodedData.total_pages
                }
            }
            var movies: [MovieModel] = []
            for result in results {
                
                if let imagePath = result.poster_path {
                    let imageURL = "https://image.tmdb.org/t/p/w300\(imagePath)"
                    if let image = self.urlToImage(urlPath: imageURL) {
                        movies.append(MovieModel(posterImage: image,
                                                 id: result.id,
                                                 currentPage: currentPage,
                                                 totalPages: totalPages))
                        
                    }
                }
            }
            return movies
            
        }catch{
            delegate?.didFailWithError(error: error)
            return nil
        }
    }
    
    func urlToImage(urlPath: String) -> UIImage? {
        if let url = URL(string: urlPath){
            do {
                let data = try Data(contentsOf: url)
                
                
                let image = UIImage(data: data)
                return image
                
            }catch {
                delegate?.didFailWithError(error: error)
            }
            
        }
        return nil
    }
}
