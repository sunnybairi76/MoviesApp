//
//  ProtocalModal.swift
//  Assigntment
//
//  Created by Bairi Akash on 31/08/23.
//

import Foundation

class FirstPageDataModel : ObservableProtocol,PageControlHandler{
    
    var observer: ObserverProtocol?
    var presentPage = 1
    var lastPage : Int!
    var movies: [Film] = []
    
    func gotoNextPage() {
        presentPage += 1
        fetchMovies()
    }
    
    func gotoPrevPage() {
        presentPage -= 1
        fetchMovies()
    }
    
    var responseData : APIresponseData!
    
    func fetchMovies(isFirstPage: Bool = false ){
        if isFirstPage {
            presentPage = 1
        }
        MovieManager.fetchPopularMovies(pageNumber: presentPage){ (response)  in
                if let responseData = response {
                    self.responseData = responseData
                    self.processPopularMoviesResults()
                    self.notifyObservers()
                    
                }
        }
    }
    
    func processPopularMoviesResults(){
        movies = responseData.results
        lastPage = responseData.total_pages
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
