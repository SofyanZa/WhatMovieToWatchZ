//
//  MovieManager.swift
//  Info Movie
//
//  Created by Sofyan Zarouri  on 23/08/2022.
//

import Foundation

import UIKit

/// Délégué de MovieManager qui prend en parametre MovieManager , le MovieModel et le protocol Error

enum ErrorCases: Error {
    case invalidRequest
    case errorDecode
    case errorNetwork
}


struct MovieManager{
    
    var lastUrl = ""
    
    let baseUrl = "https://api.themoviedb.org/3/"
    let apiKey = K.apiKey
    
    
    private var session: URLSession

    //initializer to allow fake double for testing
    init(session: URLSession = URLSession(configuration: .default)) {
        self.session = session
    }
    
     func fetchMovies(page: Int, sort: String, query: String = "", callback: @escaping (Result <[MovieModel], ErrorCases>) -> Void) {
        let urlString = "\(baseUrl)\(sort)?api_key=\(apiKey)&page=\(page)\(query)"
        if urlString != lastUrl {
            if let url = URL(string: urlString) {
                //Create URL session
                
                let urlSession = session
                
                // give a task to the session
                let task = urlSession.dataTask(with: url) { data, response, error in
                    
                    if error != nil{
                       // delegate?.didFailWithError(error: error!)
                        callback(.failure(.errorNetwork))
                        return
                    }
                    if let safeData = data{
                        if let movies = parseJSON(safeData){
                         //   delegate?.didUpdateMovie(self, movie: movie)
                            callback(.success(movies))
                        } else {
                            callback(.failure(.errorDecode))
                        }
                    } else {
                        callback(.failure(.errorDecode))
                    }
                }
                // start task
                task.resume()
            }
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
            return nil
        }
    }
    
    func urlToImage(urlPath: String) -> UIImage? {
        if let url = URL(string: urlPath){
            do {
                let data = try Data(contentsOf: url)
                
                
                let image = UIImage(data: data)
                return image
                
            } catch {
               // delegate?.didFailWithError(error: error)
            }
            
        }
        return nil
    }
}
