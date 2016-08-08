//
//  PDService.swift
//  PicDrizzle
//
//  Created by 胡胡赛军 on 8/6/16.
//  Copyright © 2016 胡胡赛军. All rights reserved.
//

//import Foundation
import UIKit
import Moya
import Alamofire

enum PDService {
    case login(email: String, password: String)
    case register(email:String, password: String )
    case getImageResources(page: Int)
    case userLikePhotos(user: String, page: Int)
    case likePhoto(photoID: String)
    case unlikePhoto(photoID: String)
}
// MARK: - TargetType Protocol Implementation
extension PDService: TargetType {
    
//    let ACCESS_TOKEN = "e3cee9eb2e20e4acb3b15214f52eee60f29831880e11c4bad6aa98e5dab55289"
    var baseURL: NSURL { return NSURL(string: "https://api.unsplash.com")! }
    
    var path: String {
        switch self {
        case .login(_,_):
            return "/users"
        case .register(_, _):
            return "/users"
        case .getImageResources(_):
            return "photos/curated"
        case .userLikePhotos(let user,_):
            return "/users/\(user)/likes"
        case .likePhoto(let id):
            return "/photos/\(id)/like"
        case .unlikePhoto(let id):
            return "/photos/\(id)/like"
        }
    }
    var method: Moya.Method {
        switch self {
        case .getImageResources, .userLikePhotos:
            return .GET
        case .login, .register,.likePhoto:
            return .POST
        case .unlikePhoto:
            return .DELETE
        }
    }
    var parameters: [String: AnyObject]? {
        switch self {
        case .login, .likePhoto, .unlikePhoto:
            return [:]
        case .getImageResources(let page):
            return ["page": page]
        case .userLikePhotos( _, let page):
            return ["page": page]
        case .register(let email, let password):
            return ["email": email, "password": password]
        }
    }
    var sampleData: NSData {
//        switch self {
//        case .login:
//            return "Half measures are as bad as nothing at all.".UTF8EncodedData
//        case .register(let id):
//            return "{\"id\": \(id), \"first_name\": \"Harry\", \"last_name\": \"Potter\"}".UTF8EncodedData
//        case .getImageResources:
//            return "{\"id\": 100, \"first_name\": \")\", \"last_name\": \")\"}".UTF8EncodedData
//        }
        return NSData()
    }

//    var multipartBody: [MultipartFormData]? {
//        // Optional
//        return nil
//    }
}

let myEndpointClosure = { (target: PDService) -> Endpoint<PDService> in
    let url = target.baseURL.URLByAppendingPathComponent(target.path).absoluteString
    let endpoint: Endpoint<PDService> = Endpoint<PDService>(URL: url, sampleResponseClosure: {.NetworkResponse(200, target.sampleData)}, method: target.method, parameters: target.parameters)
    let headers = headerForTarget(.getImageResources(page: 1))
    return endpoint.endpointByAddingHTTPHeaderFields(headers)
//    return endpoint.endpointByAddingHTTPHeaderFields(["Authorization": "Bearer e3cee9eb2e20e4acb3b15214f52eee60f29831880e11c4bad6aa98e5dab55289"])
    
}


let requestClosure = { (endpoint: Endpoint<PDService>, done: NSURLRequest -> Void) in
    let request = endpoint.urlRequest
    
    // Modify the request however you like.
    
    done(request)
}

let provider = MoyaProvider<PDService>(endpointClosure: myEndpointClosure)
//let provider = MoyaProvider<PDService>(endpointClosure: myEndpointClosure, requestClosure: MoyaProvider.RequestClosure, stubClosure: MoyaProvider.StubClosure, manager: MoyaProvider.DefaultAlamofireManager(), plugins: [NetworkActivityPlugin])

//        let provider = MoyaProvider<PDService>()


// MARK: - Helpers
public extension String {
    var URLEscapedString: String {
        return self.stringByAddingPercentEncodingWithAllowedCharacters(NSCharacterSet.URLHostAllowedCharacterSet())!
    }
    var UTF8EncodedData: NSData {
        return self.dataUsingEncoding(NSUTF8StringEncoding)!
    }
}
public func url(route: TargetType) -> String {
    return route.baseURL.URLByAppendingPathComponent(route.path).absoluteString
}

func headerForTarget(target: PDService) -> [String: String]{
    switch target {
    case .getImageResources(_):
        return ["Authorization": "Bearer e3cee9eb2e20e4acb3b15214f52eee60f29831880e11c4bad6aa98e5dab55289"]
    default: return ["Authorization": "Bearer e3cee9eb2e20e4acb3b15214f52eee60f29831880e11c4bad6aa98e5dab55289"]
    }
}



