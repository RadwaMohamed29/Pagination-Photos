//
//  LocalDataSource.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation
import CoreData

protocol LocalDataSourcable{
    func getPhotosFromCoreData() throws -> [Photo]
    func saveToCoreData(title: String,url:String)throws
}
class LocalDataSource:LocalDataSourcable{
    private var context: NSManagedObjectContext!
    private var entity: NSEntityDescription!
    init(appDelegate: AppDelegate){
        context = appDelegate.persistentContainer.viewContext
        entity = NSEntityDescription.entity(forEntityName: "Photo", in: context)
        
    }
    func saveToCoreData(title: String,url:String)throws{
        let photo = Photo(entity: entity, insertInto: context)
        photo.url = url
        photo.title = title
        
        do{
            try context.save()
            
        }catch let error as NSError{
            throw error
        }
        
    }
    
    
    func getPhotosFromCoreData()throws -> [Photo] {
        var photos : [Photo] = []
        let fetchRequest = Photo.fetchRequest()
        do{
            let photoList = try context.fetch(fetchRequest)
            for item in photoList {
                photos.append(item)
            }
            return photos
        }
        catch let error as NSError{
            throw error
            
        }
    }
    
}

