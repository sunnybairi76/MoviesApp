//
//  LoadHandler.swift
//  Assigntment
//
//  Created by Bairi Akash on 10/09/23.
//

import Foundation

class SearchViewDataModel : ObservableProtocol,PageControlHandler{
    
    var observer: ObserverProtocol?
    var presentPage = 1
    var lastPage : Int!
    var movies: [Film] = []
    var searchText: String!
    
    func gotoNextPage() {
        presentPage += 1
        fetchMoviesWithTitle(title: self.searchText)
    }
    
    func gotoPrevPage() {
        presentPage -= 1
        fetchMoviesWithTitle(title: self.searchText)
    }
    
    func fetchMoviesWithTitle(title : String){
        searchText = title
        
        MovieManager.fetchPopularMoviesWithTitle(titleTyped: title ){ (movieList) in
            if let movieList = movieList{
                self.movies = movieList
                self.notifyObservers()
               
            }
            print( movieList)
        }
    }
   
    func addObserver(observer: ObserverProtocol) {
        self.observer = observer
    }
    
    func removeObserver() {
        self.observer = nil
    }
    
    func notifyObservers() {
        observer?.onValueChanged()
    }
    
}

