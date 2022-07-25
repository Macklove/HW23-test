//
//  ViewController.swift
//  HW23
//
//  Created by  Евгений on 25.07.2022.
//

import UIKit
import CryptoKit

class ViewController: UIViewController {
    
    @IBOutlet weak var ActivityParsed: UIActivityIndicatorView!
    
    private let endpointClient = EndpointClient(applicationSettings: ApplicationSettingsService())
    
    override func viewDidLoad() {
        super.viewDidLoad()
        executeCall()
    }
    
    func getData(urlRequest: String) {
        let urlRequest = URL(string: urlRequest)
        guard let url = urlRequest else { return }
        URLSession.shared.dataTask(with: url) { data, response, error in
            if error != nil {
                
            } else if let response = response as? HTTPURLResponse, response.statusCode == 200 {
                guard let data = data else { return }
                let dataString = String(data: data, encoding: .utf8)
            }
        }.resume()
    }
    
    func executeCall() {
        let endpoint = GetNameEndpoint()
        let completion: EndpointClient.ObjectEndpointCompletion<String> = { result, response in
            guard let responseUnwrapped = response else { return }
            
            print("\n\n response = \(responseUnwrapped.allHeaderFields) ;\n \(responseUnwrapped.statusCode) \n")
            switch result {
            case .success(let team):
                print("team = \(team)")
                
            case .failure(let error):
                print(error)
            }
        }
        endpointClient.executeRequest(endpoint, completion: completion)
    }
}

final class GetNameEndpoint: ObjectResponseEndpoint<String> {
    
    let publicKey = "96732abd690b89d71a8daeccb564a4be"
    let privateKey = "6713c39a1931bb5bfef0fe63be2eb22bb3aa096a"
    let tsValue = "1"
    
    override var method: RESTClient.RequestType { return .get }
    override var path: String { "/v1/public/characters/1010743/series" }
    
    override init() {
        super.init()
        
        queryItems = [URLQueryItem(name: "ts",value: tsValue),
                      URLQueryItem(name: "apikey",value: publicKey),
                      URLQueryItem(name: "hash",value: (tsValue + privateKey + publicKey).md5)]
    }
}

func decodeJSONOld() {
    let str = """
        {\"team\": [\"ios\", \"android\", \"backend\"]}
    """
    
    let data = Data(str.utf8)
    
    do {
        if let json = try JSONSerialization.jsonObject(with: data, options: []) as? [String: Any] {
            if let names = json["team"] as? [String] {
                print(names)
            }
        }
    } catch let error as NSError {
        print("Failed to load: \(error.localizedDescription)")
    }
}

extension String {
    var md5: String? {
        guard let data = self.data(using: .utf8) else { return nil }
        let computed = Insecure.MD5.hash(data: data)
        return computed.map { String(format: "%02x", $0) }.joined()
    }
}
