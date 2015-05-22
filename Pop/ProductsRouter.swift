//
//  ProductsRouter.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 01/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import Alamofire

enum ProductRouter: URLRequestConvertible {
    
    static let baseUrlString = ApiRouter.baseURLString + "/products"
    
    // Cases
    case Products(page: Int, perPage: Int)
    case CreateProduct(product: NSDictionary)
    case LikeProduct(id: Int, liked: Bool)
    
    
    // Methods
    var method: Alamofire.Method {
        switch self {
        case .Products:
            return .GET
        case .CreateProduct:
            return .POST
        case .LikeProduct:
            return .PATCH
        }
    }
    
    // Url endpoints
    var path: String {
        switch self {
        case .Products:
            return ""
        case .CreateProduct:
            return ""
        case .LikeProduct:
            return ""
        }
    }
    
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: ProductRouter.baseUrlString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .Products(let page, let perPage):
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: ["page": page, "limit": perPage]).0
        case .CreateProduct(let product):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters: ["product": product]).0
        case .LikeProduct(let id, let liked):
            return Alamofire.ParameterEncoding.JSON.encode(mutableURLRequest, parameters:
            ["id": id, "liked": liked]).0
        }
    }
    
}
