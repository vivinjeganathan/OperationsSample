//
//  NetworkHelper.swift
//  Verizon
//
//  Created by Jeganathan, Vivin on 7/13/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

enum MyError: Error {
    case badURL
    case networkError
    case responseError
    case downloadError
    case none
}

class NetworkHelperDispatchGroup: NSObject, URLSessionDelegate {
    
    static var todosUrl = "https://jsonplaceholder.typicode.com/todos"
    static var photosUrl = "https://jsonplaceholder.typicode.com/photos"
    static var commentsUrl = "https://jsonplaceholder.typicode.com/comments"
    
    func getAllData(completionHandler: (Result<([Todo]?, [Comment]?, [Photo]?), MyError>) -> Void) {
        
        var todos = [Todo](), photos = [Photo](), comments = [Comment]()
        var errorA = MyError.none
        fetchData1(urlString: NetworkHelperDispatchGroup.todosUrl, completionHandler: { result in
            
            switch result {
            case .success(let todosArray):
                todos = todosArray
            case .failure(let myError):
                errorA = myError
            }
        })
        
        print("inside fetchAllOperation")
        let group = DispatchGroup()

        group.enter()
        self.fetchTodos(completionHandler: { (result) in
            switch result {
            case .success(let todosArray):
                todos = todosArray
            case .failure(let myError):
                errorA = myError
            }
            group.leave()
        })

        group.enter()
        self.fetchPhotos(completionHandler: { (result) in
            switch result {
            case .success(let photosArray):
                photos = photosArray
            case .failure(let myError):
                errorA = myError
            }
            group.leave()
        })

        group.enter()
        self.fetchComments(completionHandler: { (result) in
            switch result {
            case .success(let commentsArray):
                comments = commentsArray
            case .failure(let myError):
                errorA = myError
            }
            group.leave()
        })

        group.notify(queue: .main) {
            if errorA != .none {

            } else {
                print("Todo's count \(todos.count)")
                print("photo's count \(photos.count)")
                print("coment's count \(comments.count)")
            }
        }
    }
    
    func fetchTodos(completionHandler: @escaping (Result<[Todo], MyError>) -> Void) {
        SampleNetworkHelper().fetchData(urlString: NetworkHelperDispatchGroup.todosUrl, responseModel: [Todo].self, completionHandler: completionHandler)
    }
    
    func fetchPhotos(completionHandler: @escaping (Result<[Photo], MyError>) -> Void) {
        SampleNetworkHelper().fetchData(urlString: NetworkHelperDispatchGroup.photosUrl, responseModel: [Photo].self, completionHandler: completionHandler)
    }

    func fetchComments(completionHandler: @escaping (Result<[Comment], MyError>) -> Void) {
        SampleNetworkHelper().fetchData(urlString: NetworkHelperDispatchGroup.commentsUrl, responseModel: [Comment].self, completionHandler: completionHandler)
    }
    
    func fetchData1(urlString: String, completionHandler: (@escaping (Result<[Todo], MyError>) -> Void)) {
    
        print("fetching ...", urlString)
        guard let url = URL(string: urlString) else {
            completionHandler(.failure(.badURL))
            return
        }
        
        let urlSession = URLSession(configuration: URLSessionConfiguration.default, delegate: self, delegateQueue: nil)
        urlSession.dataTask(with: url) { (data, response, error) in
            
            if error != nil {
                completionHandler(.failure(.networkError))
                return
            }
            
            if let data = data {
                do {
                    let parsedData = try JSONDecoder().decode([Todo].self, from: data)
                    print("downloaded data - ", parsedData.count)
                    completionHandler(.success(parsedData))
                } catch {
                    completionHandler(.failure(.responseError))
                }
                
            } else {
                completionHandler(.failure(.responseError))
            }
            
        }.resume()
    }
}
