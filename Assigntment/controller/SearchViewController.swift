//
//  SearchViewController.swift
//  Assigntment
//
//  Created by Bairi Akash on 10/09/23.
//

import UIKit

class SearchViewController: UIViewController {

    @IBOutlet weak var searchTitle: UITextField!
    @IBOutlet weak var searchTableView: UITableView!
    @IBOutlet weak var pageNumber: UILabel!
    @IBOutlet weak var nextPage: UIButton!
    @IBOutlet weak var prevPage: UIButton!
    
    
    var searchViewDataModel : SearchViewDataModel!
    var loader : LoadHandler!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        searchTableView.delegate = self
        searchTableView.dataSource = self
        //sets the delegate and data source of the movieTableView to self
        
        searchViewDataModel = SearchViewDataModel()
        searchViewDataModel.addObserver(observer: self)
        
        loader = Loader(superview: self.view)
       
    }
    
    
    @IBAction func searchButton(_ sender: UIButton) {
        loader.addLoader(onto: self.view)
        searchViewDataModel.fetchMoviesWithTitle(title: self.searchTitle.text ?? "")
    }
    
    @IBAction func loadNextPage(_ sender: UIButton) {
        loader.addLoader(onto: self.view)
        searchViewDataModel.gotoNextPage()
    }
    
    @IBAction func loadPrevPage(_ sender: UIButton) {
        loader.addLoader(onto: self.view)
        searchViewDataModel.gotoPrevPage()
    }
    
    
    
    func reloadCurrentPage() {
        searchTableView.reloadData()
        scrollToTopofTableView()
        pageNumber.text = String(searchViewDataModel.presentPage)
        enablePageControllers(currentPage: searchViewDataModel.presentPage, lastPage:searchViewDataModel.lastPage)
    }
    
    func scrollToTopofTableView(){
        let topRow = IndexPath(row: 0, section: 0)
        searchTableView.scrollToRow(at: topRow,at: .top,animated: false)
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
    
    

}
extension SearchViewController:UITableViewDataSource, UITableViewDelegate {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return searchViewDataModel.movies.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = searchTableView.dequeueReusableCell(withIdentifier: "SecondCell", for: indexPath)

        guard let cell = cell as? FirstPageTableViewCell else {
            return cell
        }

        let basePath = "https://image.tmdb.org/t/p/w500/"
        let movieImagePath = basePath + (searchViewDataModel.movies[indexPath.row].poster_path ?? "")
        //This URL points to the movie's poster image.

        cell.movieTitle.text = searchViewDataModel.movies[indexPath.row].title
        cell.movieOverview.text = searchViewDataModel.movies[indexPath.row].overview
        //updating texts


        MovieManager.fetchMoviePoster(from: movieImagePath) { (image) in
            //fetching of the movie poster image from the provided URL

            DispatchQueue.main.async {
                cell.moviePoster.layer.cornerRadius = 8

                //if image successfully fetched
                if let image = image {
                    cell.moviePoster.image = image
                }else {
                    cell.moviePoster.image = UIImage(systemName: "photo")

                    //else sets to defaultImage photo
                }
            }

        }
        return cell
    }
    
    
}
extension SearchViewController: ObserverProtocol{
    func onValueChanged( ){
        DispatchQueue.main.async {
           
            self.loader.removeLoader()
            self.searchTableView.reloadData()
        }
    }
}
