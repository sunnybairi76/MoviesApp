//
//  FirstListViewController.swift
//  Assigntment
//
//  Created by Bairi Akash on 24/08/23.
//

import UIKit

class FirstPageViewController: UIViewController {
    
    @IBOutlet weak var movieTableView: UITableView!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var prevPage: UIButton!
    
    var firstPageDataModel : FirstPageDataModel!
    var loader : LoadHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        movieTableView.delegate = self
        movieTableView.dataSource = self
        //sets the delegate and data source of the movieTableView to self
        
        firstPageDataModel = FirstPageDataModel()
        firstPageDataModel.addObserver(observer: self)
        
        loader = Loader(superview: self.view)
        loadContent()
       
    }
    
    
    @IBAction func loadNextPage(_ sender: UIButton) {
        loader.addLoader(onto: self.view)
        disablePageControllers()
        firstPageDataModel.gotoNextPage()
    }
    
    @IBAction func loadPreviousPage(_ sender: UIButton) {
        loader.addLoader(onto: self.view)
        disablePageControllers()
        firstPageDataModel.gotoPrevPage()
    }
    
    func loadContent() {
        loader.addLoader(onto: self.view)
        disablePageControllers()
        firstPageDataModel.fetchMovies()
    }
    
    func reloadCurrentPage() {
        movieTableView.reloadData()
        scrollToTopofTableView()
        pageNumber.text = String(firstPageDataModel.presentPage)
        enablePageControllers(currentPage: firstPageDataModel.presentPage, lastPage:firstPageDataModel.lastPage)
    }
    
    func scrollToTopofTableView(){
        let topRow = IndexPath(row: 0, section: 0)
        movieTableView.scrollToRow(at: topRow,at: .top,animated: false)
    }
    
    
    func disablePageControllers(){
        pageNumber.text = ""
        prevPage.isEnabled = false
        nextPage.isEnabled = false
    }
    
    func enablePageControllers(currentPage: Int, lastPage: Int){
        if currentPage > 1 {
            prevPage.isEnabled = true
        }
        if currentPage < lastPage {
            nextPage.isEnabled = true
        }
    }
    
    
    
    var selectedRow: Int!
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // to prepare data to be passed to the destination view controller
        if segue.identifier == "nextPageSegue" {
            if let destinationVC = segue.destination as? FinalPageViewController {
                destinationVC.film = firstPageDataModel.movies[selectedRow]
            }
        }
    }
    
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        self.selectedRow = indexPath.row
        performSegue(withIdentifier: "nextPageSegue", sender: nil)
    }
    
}



extension FirstPageViewController : UITableViewDelegate,UITableViewDataSource{
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return firstPageDataModel.movies.count
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = movieTableView.dequeueReusableCell(withIdentifier: "FirstCell", for: indexPath)

        guard let cell = cell as? FirstPageTableViewCell else {
            return cell
        }

        let basePath = "https://image.tmdb.org/t/p/w500/"
        let movieImagePath = basePath + (firstPageDataModel.movies[indexPath.row].poster_path! )

        cell.movieTitle.text = firstPageDataModel.movies[indexPath.row].title
        cell.movieOverview.text = firstPageDataModel.movies[indexPath.row].overview
       
        
        MovieManager.fetchMoviePoster(from: movieImagePath) { (image) in
            //fetching of the movie poster image from the provided URL

            DispatchQueue.main.async {
                cell.moviePoster.layer.cornerRadius = 8
                if let image = image {
                    cell.moviePoster.image = image
                }else {
                    cell.moviePoster.image = UIImage(systemName: "photo")
                }
            }
        }
        return cell
    }
}



extension FirstPageViewController : ObserverProtocol{
    func onValueChanged( ){
        DispatchQueue.main.async {
            self.movieTableView.reloadData()
            self.loader.removeLoader()
            self.enablePageControllers(currentPage: self.firstPageDataModel.presentPage, lastPage: self.firstPageDataModel.lastPage)
        }
    }
}
