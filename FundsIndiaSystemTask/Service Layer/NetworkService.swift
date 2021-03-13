//
//  NetworkService.swift
//  FundsIndiaSystemTask
//
//  Created by Pradeep's Macbook on 12/03/21.
//  Copyright © 2021 Motiv Ate Fitness. All rights reserved.
//

import UIKit

enum APIError: Error {
    
    case error(_ errorString: String)
}

struct NetworkService {
    
    static let sharedInstance = NetworkService()
    
    func fetchData<T: Decodable>(endPoint: EndPoint,dateDecodingStrategy: JSONDecoder.DateDecodingStrategy = .deferredToDate, keyDecodingStrategy: JSONDecoder.KeyDecodingStrategy = .useDefaultKeys,completionHandler: ((Result<T, APIError>) -> Swift.Void)?) {
        
        guard let url = endPoint.url else {
            completionHandler?(.failure(.error(NSLocalizedString("Invalid URL", comment: ""))))
            return
        }
        
        URLSession.shared.dataTask(with: url) { (data, response, error) in
            DispatchQueue.main.async {
                if let  error = error {
                    completionHandler?(.failure(.error("Error: \(error.localizedDescription)")))
                    return
                }
                
                guard let unWrappedData = data else {
                    completionHandler?(.failure(.error(NSLocalizedString("Data Corrupt", comment: ""))))
                    return
                }
                
                let decoder = JSONDecoder()
                decoder.dateDecodingStrategy = dateDecodingStrategy
                decoder.keyDecodingStrategy = keyDecodingStrategy
                do {
                    let decodedObject = try decoder.decode(T.self, from: unWrappedData)
                    completionHandler?(.success(decodedObject))
                } catch let decodingError {
                    completionHandler?(.failure(.error("Error: \(decodingError.localizedDescription)")))
                }
            }
        }.resume()
    }
}
/** Basic Network Service Layer */
