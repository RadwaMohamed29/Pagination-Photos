//
//  PhotosViewModel.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation
import UIKit
protocol PhotosViewModelType{
    func callFuncToGetALlPhotos(completion: @escaping(Bool)-> Void)
    var getPhotos: ((PhotosViewModelType)-> Void)? {get set}
    var listOfPhotos: [PhotosData] {get set}
    var paginationPhotos: [PhotosData] {get set}
    var photoList: [Photo]? {get set}
    func returnPhotosCount()-> Int
    func getUsedPhotos(at row: Int) -> PhotosData
    func willDisplayPhoto(at row: Int)
    func saveToCoreData(title: String, url: String,completion:@escaping (Bool) -> Void) throws
    func getAllPhotosFromCoreData(completion: @escaping (Bool) -> Void) throws
    
}

class PhotosViewModel: PhotosViewModelType{

   private var network: APIClient
    var pages = 10
    var limit = 10
    var paginationPhotos: [PhotosData] = []
    private var view: PhotosView?
    var photoList: [Photo]?
    var localDataSource:LocalDataSourcable?
    init(_ view: PhotosView, network: APIClient = APIClient() ){
        self.network = network
        self.view = view
        localDataSource = LocalDataSource(appDelegate: ((UIApplication.shared.delegate as? AppDelegate)!))
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
    func saveToCoreData(title: String, url: String,completion:@escaping (Bool) -> Void) throws {
        do{
            try localDataSource?.saveToCoreData(title: title, url: url)
            completion(true)
            
        }catch let error {
            completion(false)
            throw error
        }
    }
  
    func getAllPhotosFromCoreData(completion: @escaping (Bool) -> Void) throws {
        do{
            try  photoList =  localDataSource?.getPhotosFromCoreData()
            completion(true)
        }catch let error{
            completion(false)
            throw error
        }
    }
    

    
}
