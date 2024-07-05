//
//  FinalMovieViewController.swift
//  Assigntment
//
//  Created by Bairi Akash on 24/08/23.
//

import UIKit

class FinalPageViewController: UIViewController {
    
    var film : Film!
    
    @IBOutlet weak var filmPoster: UIImageView!
    @IBOutlet weak var filmReleaseDate: UILabel!
    @IBOutlet weak var filmRating: UILabel!
    @IBOutlet weak var filmPopularity: UILabel!
    @IBOutlet weak var filmOverview: UILabel!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        title = film.title
        filmReleaseDate.text = film.release_date
        filmRating.text = String(film.vote_average!)
        filmPopularity.text = String(film.popularity!)
        filmOverview.text = film.overview
        
        
        let  basePath = "https://image.tmdb.org/t/p/w500/"
        let movieImagePath = basePath + (film.poster_path!)

        MovieManager.fetchMoviePoster(from: movieImagePath) { (image) in

            DispatchQueue.main.async {
                self.filmPoster.layer.cornerRadius = 20
                if let image = image {
                    self.filmPoster.image = image
                }else {
                    self.filmPoster.image = UIImage(systemName: "photo")
                }
            }

        }
    }
    
    
    
}
