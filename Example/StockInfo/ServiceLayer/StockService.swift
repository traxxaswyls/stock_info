//
//  StockService.swift
//  StockInfo
//
//  Created by Dmitry Savinov on 24.10.2022.
//  Copyright © 2022 alexdremov. All rights reserved.
//

import Foundation


public struct StocksPlainObject: Codable, Equatable {

    let stoks: [StockInfoPlainObject]
}

public struct StockInfoPlainObject: Codable, Equatable {

    let updateTime: Double
    let companyName: String
    let tickerName: String
    let lastPrice: Double
    let percentUpdate: Double
    let volumeInMillions: Double
    let percentUpdateWeek: Double
    let percentUpdateMonth: Double
    let percentUpdateStartYear: Double
    let percentUpdateYear: Double
    let capitalizationInBillionRUB: Double
    let capitalizationInBillionUSD: Double
}

// MARK: - StockService

public class StockService: Service {

    // MARK: - Implementation

    func stoks(sort: String, completion: @escaping (Result<StocksPlainObject>) -> Void) {
        dataRequest(
            with: "https://functions.yandexcloud.net/d4eskk8mf4j1a6no6s36",
            objectType: StocksPlainObject.self
        ) { result in
            completion(result)
        }
    }
}

// APIError enum which shows all possible Network errors
enum APIError: Error {
    case networkError(Error)
    case dataNotFound
    case jsonParsingError(Error)
    case invalidStatusCode(Int)
    case badURL(String)
}

// Result enum to show success or failure
enum Result<T> {
    case success(T)
    case failure(APIError)
}

public class Service {

    // dataRequest which sends request to given URL and convert to Decodable Object
    func dataRequest<T: Decodable>(with url: String, objectType: T.Type, completion: @escaping (Result<T>) -> Void) {

        // create the url with NSURL
        guard let dataURL = URL(string: url) else {
            completion(.failure(APIError.badURL(url)))
            return
        }

        // create the session object
        let session = URLSession.shared

        // now create the URLRequest object using the url object
        let request = URLRequest(url: dataURL, cachePolicy: .useProtocolCachePolicy, timeoutInterval: 60)

        // create dataTask using the session object to send data to the server
        let task = session.dataTask(with: request, completionHandler: { data, response, error in

            guard error == nil else {
                completion(Result.failure(APIError.networkError(error!)))
                return
            }

            guard let data = data else {
                completion(Result.failure(APIError.dataNotFound))
                return
            }

            do {
                // create decodable object from data
                let decodedObject = try JSONDecoder().decode(objectType.self, from: data)
                completion(Result.success(decodedObject))
            } catch let error {
                completion(Result.failure(APIError.jsonParsingError(error as! DecodingError)))
            }
        })

        task.resume()
    }
}
