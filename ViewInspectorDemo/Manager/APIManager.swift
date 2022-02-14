//
//  APIManager.swift
//  ViewInspectorDemo
//
//  Created by AlexanderPan on 2021/5/7.
//

import Foundation
import Combine
import RxSwift

enum APIManagerError: Error {
    case dataNull
}

class APIManager {

    static let shareInstance = APIManager.init()

    func getUserByCombine(name:String) -> AnyPublisher<SearchUserResponse, Error> {
        let request = APIManager.makeUserRequest(name)
        return URLSession.shared.dataTaskPublisher(for: request)
            .map { $0.data }
            .decode(type: SearchUserResponse.self, decoder: JSONDecoder()).eraseToAnyPublisher()
    }

    func getUserByRxSwift(name:String) -> Single<SearchUserResponse> {

        return Single<SearchUserResponse>.create { (event) -> Disposable in
            let request = APIManager.makeUserRequest(name)
            URLSession.shared.dataTask(with: request) { (data, response, error) in
                if let strongError = error  {
                    event(.failure(strongError))
                } else {
                    if let strongData = data {
                        do {
                            event(.success(try JSONDecoder().decode(SearchUserResponse.self, from: strongData)))
                        } catch {
                            event(.failure(error))
                        }
                    } else {
                        event(.failure(APIManagerError.dataNull))
                    }
                }
            }.resume()

            return Disposables.create()
        }
    }

    private static func makeUserRequest(_ name:String) -> URLRequest {
        var urlComponents = URLComponents(string: "https://api.github.com/search/users")!
        urlComponents.queryItems = [URLQueryItem(name: "q", value: name)]
        var request = URLRequest(url: urlComponents.url!)
        request.httpMethod = "GET"
        request.addValue("application/json", forHTTPHeaderField: "Content-Type")
        return request
    }
}
