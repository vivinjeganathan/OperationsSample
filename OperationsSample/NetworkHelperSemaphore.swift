//
//  NetworkHelperSemaphore.swift
//  OperationsSample
//
//  Created by Jeganathan, Vivin on 7/21/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class NetworkHelperSemaphore: NSObject {
    static var todosUrl = "https://jsonplaceholder.typicode.com/todos"
    static var photosUrl = "https://jsonplaceholder.typicode.com/photos"
    static var commentsUrl = "https://jsonplaceholder.typicode.com/comments"
    
    func getAllData(completionHandler: (Result<([Todo]?, [Comment]?, [Photo]?), MyError>) -> Void) {
        
        
    }
}
