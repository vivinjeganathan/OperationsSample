//
//  ViewController.swift
//  OperationsSample
//
//  Created by Jeganathan, Vivin on 7/20/19.
//  Copyright © 2019 Jeganathan, Vivin. All rights reserved.
//

import UIKit

class ViewController: UIViewController {
    let network = NetworkHelperOperationQueue()
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        NetworkHelperDispatchGroup().getAllData { (result) in

        }
        
//        network.getAllData { (result) in
//
//        }
        
        var arr = [1,2,3,4,5]
        
        for (index,element) in arr.enumerated() {
            if element == 2 {
                arr.remove(at: index)
            }
        }
        print(arr)
        
    }


}

