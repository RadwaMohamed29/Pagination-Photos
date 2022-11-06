//
//  APIClient.swift
//  Pagination Photos
//
//  Created by Radwa on 05/11/2022.
//

import Foundation
import Alamofire

protocol NetworkServiceProtocol{
    
    func getAllPhotos(completion: @escaping(Result<Photos,Error>) -> Void)
    
}
class APIClient: NetworkServiceProtocol{
    func getAllPhotos(completion: @escaping (Result<Photos, Error>) -> Void) {
        fetchData(endpoint: .photos, completion: completion)
    }
    
    func fetchData<T :Codable>(endpoint: EndPoints, completion: @escaping (Result<T, Error>)-> Void){
        let url = "\(endpoint.path)"
        AF.request(url, method: .get, parameters: nil, encoding: JSONEncoding.default, headers: nil).response{ res in
            switch res.result{
            case .failure(let error):
                completion(.failure(error))
                print("errorfromapi \(error.localizedDescription)")

            case .success(_):
                guard let data = res.data else{return}
                do{
                    let json = try JSONDecoder().decode(T.self, from: data)
                    print("fromNnnnnnnnn\(json)")
                    completion(.success(json))
                }catch let error{
                    completion(.failure(error))
                    print("errorfromapi \(error.localizedDescription)")
                }
            }
            
        }

    }
}
