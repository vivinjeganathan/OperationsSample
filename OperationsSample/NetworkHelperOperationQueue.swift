//
//  NetworkHelperOperationQueue.swift
//  OperationsSample
//
//  Created by Jeganathan, Vivin on 7/20/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NetworkHelperOperationQueue: NSObject {
    static var todosUrl = "https://jsonplaceholder.typicode.com/todos"
    static var photosUrl = "https://jsonplaceholder.typicode.com/photos"
    static var commentsUrl = "https://jsonplaceholder.typicode.com/comments"
    
    func getAllData(completionHandler: (Result<([Todo]?, [Comment]?, [Photo]?), MyError>) -> Void) {
        
        let operationQueue = OperationQueue()
        
        var todos = [Todo](), photos = [Photo](), comments = [Comment]()
        var errorA = MyError.none
        
        let fetchAllOperation = BlockOperation { [weak self] in
            
            let group = DispatchGroup()
            
            group.enter()
            self?.fetchTodos(completionHandler: { (result) in
                switch result {
                case .success(let todosArray):
                    todos = todosArray
                case .failure(let myError):
                    errorA = myError
                }
                group.leave()
            })
            
            group.enter()
            self?.fetchPhotos(completionHandler: { (result) in
                switch result {
                case .success(let photosArray):
                    photos = photosArray
                case .failure(let myError):
                    errorA = myError
                }
                group.leave()
            })
            
            group.enter()
            self?.fetchComments(completionHandler: { (result) in
                switch result {
                case .success(let commentsArray):
                    comments = commentsArray
                case .failure(let myError):
                    errorA = myError
                }
                group.leave()
            })
            
            group.wait()
        }
        
        let updateUIOperation = BlockOperation {
            DispatchQueue.main.async {
                if errorA != .none {
                   
                } else {
                    print("Todo's count \(todos.count)")
                    print("photo's count \(photos.count)")
                    print("coment's count \(comments.count)")
                }
            }
        }
    
        updateUIOperation.addDependency(fetchAllOperation)
        operationQueue.addOperation(fetchAllOperation)
        operationQueue.addOperation(updateUIOperation)
        
        //operationQueue
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
}
