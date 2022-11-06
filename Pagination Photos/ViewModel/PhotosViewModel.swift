//
//  PhotosViewModel.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation
protocol PhotosViewModelType{
    func callFuncToGetALlPhotos(completion: @escaping(Bool)-> Void)
    var getPhotos: ((PhotosViewModelType)-> Void)? {get set}
    var listOfPhotos: [PhotosData] {get set}
    func returnPhotosCount()-> Int
    func getUsedPhotos(at row: Int) -> PhotosData
    func willDisplayPhoto(at row: Int)
    
}

class PhotosViewModel: PhotosViewModelType{

    var network = APIClient()
    var pages = 10
    var limit = 10
    var paginationPhotos: [PhotosData] = []
    private var view: PhotosView?
    
    init(_ view: PhotosView){
        self.view = view
    }
    
    var listOfPhotos: [PhotosData] = []{
        didSet{
            getPhotos?(self)
        }
    }
    func callFuncToGetALlPhotos(completion: @escaping (Bool) -> Void) {
        network.getAllPhotos { [weak self]
            result in
            switch result{
            case .success(let photos):
                self?.listOfPhotos = photos
                self?.limit = self?.listOfPhotos.count ?? 0
                
                for i in 0..<10{
                    self?.paginationPhotos.append(photos[i])
                }
                DispatchQueue.main.async { [weak self] in
                    self?.view?.reloadPhotosTableView()
                }
                print("fetch data\(photos.count)")
                completion(true)
            case .failure(_):
                completion(false)
                print("can not fetch data")
            }
        }
        completion (true)
    }
    
    var getPhotos: ((PhotosViewModelType) -> Void)?

    
    func returnPhotosCount() -> Int {
        return paginationPhotos.count
    }
    
    func getUsedPhotos(at row: Int) -> PhotosData {
        return paginationPhotos[row]
    }
    
    func willDisplayPhoto(at row: Int) {
        if row == paginationPhotos.count - 1 {
            addNewPhotos()
        }
    }
    

    
    private func addNewPhotos(){
        if pages >= limit {
            return
        }
        else if pages >= limit - 10 {
            for i in pages..<limit {
                paginationPhotos.append(listOfPhotos[i])
            }
            self.pages += 10
        }
        else {
            for i in pages..<pages + 10 {
                paginationPhotos.append(listOfPhotos[i])
            }
            self.pages += 10
        }
        DispatchQueue.main.async { [weak self] in
            self?.view?.reloadPhotosTableView()
        }
    }
    
    
}
