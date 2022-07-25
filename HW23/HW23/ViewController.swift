//
//  ViewController.swift
//  HW23
//
//  Created by  Евгений on 25.07.2022.
//

import UIKit

class ViewController: UIViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
    }

    func getData(urlRequest: String) {
        let urlRequest = URL(string: urlRequest)
        guard let url = urlRequest else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else { return }
                let dataAsString = String(data: data, encoding: .utf8)
            }
        }.resume()
    }
    
}

