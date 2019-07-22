//
//  NetworkHelper.swift
//  OperationsSample
//
//  Created by Jeganathan, Vivin on 7/20/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class SampleNetworkHelper: NSObject, URLSessionDelegate {
    
    func fetchData<T: Decodable>(urlString: String, responseModel: T.Type, completionHandler: (@escaping (Result<T, MyError>) -> Void)) {
        
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
                    let parsedData = try JSONDecoder().decode(responseModel, from: data)
                    print("downloaded data - ", responseModel)
                    completionHandler(.success(parsedData))
                } catch {
                    completionHandler(.failure(.responseError))
                }
                
            } else {
                completionHandler(.failure(.responseError))
            }
            
            }.resume()
    }
    
    func urlSession(_ session: URLSession, didReceive challenge: URLAuthenticationChallenge, completionHandler: @escaping (URLSession.AuthChallengeDisposition, URLCredential?) -> Void) {
        let urlCredential = URLCredential(trust: challenge.protectionSpace.serverTrust!)
        completionHandler(.useCredential, urlCredential)
    }
}
