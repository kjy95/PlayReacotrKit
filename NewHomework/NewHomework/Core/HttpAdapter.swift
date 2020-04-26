//
//  HttpAdapter.swift
//  NewHomework
//
//  Created by draak on 02/05/2019.
//  Copyright © 2019 Draak. All rights reserved.
//

import Alamofire
import RxSwift
import RxCocoa

struct HttpAdapterErrorModel: Decodable {
    
    var errorCode: String?
    var message: String?
    
    init(code: Int, message: String) {
        self.errorCode = String(code)
        self.message = message
    }
    
}

public enum RequestType : String{
    case GET, POST
}

protocol ApiRequest{
    var method : RequestType { get }
    var path : String { get }
    var parameters : [String : String ]{ get}
}

extension ApiRequest {
    func request(with baseURL : URL) -> URLRequest {

        guard var components = URLComponents(url: baseURL.appendingPathComponent(path), resolvingAgainstBaseURL: false) else {
            fatalError("Unable to create URL compoenents")
        }

        components.queryItems = parameters.map{
            URLQueryItem(name: String($0), value: String($1))
        }

        guard let url = components.url else {
            fatalError("Could not get url")
        }

        let request : URLRequest = {
            var request = URLRequest(url: url)
            request.httpMethod = method.rawValue
            request.addValue("application/json", forHTTPHeaderField: "Accept")
            return request
        }()
        return request
    }
}
class HttpAdapter {
    
    func get<T: Codable>(urlString: String, apiRequest: ApiRequest) -> Observable<T> {
        
        return Observable<T>.create { observer in
            let request = apiRequest.request(with: URL(string: urlString)!)
            let dataRequest = Alamofire.request(request).responseData{
                response in
                switch response.result {
                case .success(let data) :
                    do {
                        let model : T = try JSONDecoder().decode(T.self, from: data)
                        observer.onNext(model)
                    } catch let error {
                        observer.onError(error)
                    }
                case .failure(let error):
                    observer.onError(error)
                }
                observer.onCompleted()
            }
            return Disposables.create {
                dataRequest.cancel()
            }
        }
    }
    
    
    // GET
    static func get<T: Decodable>(_ path: String, failure: @escaping (HttpAdapterErrorModel?) -> Void, success: @escaping (T?) -> Void) {
        guard let url = URL(string: path) else { return }
        var urlRequest = URLRequest(url: url)
        urlRequest.httpMethod = "GET"
        
        Alamofire.request(urlRequest).responseData { responseData in
            switch responseData.result {
            case .success:
                do {
                    let dataModel = try JSONDecoder().decode(T.self, from: responseData.data!)
                    success(dataModel)
                } catch let error {
                    print(error.localizedDescription)
                }
            case .failure:
                failure(HttpAdapterErrorModel(code: responseData.response?.statusCode ?? 0, message: responseData.description))
            }
        }
    }
    
}

