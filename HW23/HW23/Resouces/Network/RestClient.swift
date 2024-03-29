//
//  RestClient.swift
//  HW23
//
//  Created by  Евгений on 25.07.2022.
//

import Foundation

// Запрашивает данные с серверов
public final class RESTClient {
    
    // MARK: - Types
    
    public enum RequestType: String {
        case put = "PUT"
        case get = "GET"
        case post = "POST"
    }

    // MARK: - Typealiases
    
    public typealias SessionCompletionHandler = (Data?, URLResponse?, Error?) -> Void
    public typealias ResultCompletionHandler = (ResponseResult<Data?, HTTPURLResponse, ServerError>) -> Void
    
    // MARK: - Public methods
    
    public static func call(request: URLRequest, session: URLSession?, completion handler: @escaping ResultCompletionHandler) {
        
        let completionHandler: SessionCompletionHandler = { data, response, error in
            guard let httpResponse = response as? HTTPURLResponse else {
                handler(ResponseResult.failure(ServerError.networkProblem))
                return
            }
            
            switch httpResponse.statusCode {
            case 200:
                handler(ResponseResult.success(data, httpResponse))
            case 500:
                handler(ResponseResult.failure(ServerError.serverFail))
            default:
                if let error = error as NSError? {
                    let errorTuple = (error.code, error.localizedDescription)
                    handler(ResponseResult.failure(ServerError.invalidRequest(errorTuple)))
                }
                if data != nil {
                } else {
                    handler(ResponseResult.failure(ServerError.serverFail))
                }
            }
        }
        
        self.resumeDataTask(with: request, session: session, completionHandler: completionHandler)
    }
    
    public static func resumeDataTask(with request: URLRequest,
                               session: URLSession?,
                               completionHandler: @escaping (Data?, URLResponse?, Error?) -> Void)
    {
        (session ?? URLSession.shared)
            .dataTask(with: request, completionHandler: completionHandler).resume()
    }
}
