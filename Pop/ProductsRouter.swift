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
    
    
    // Methods
    var method: Alamofire.Method {
        switch self {
        case .Products:
            return .GET
        }
    }
    
    // Url endpoints
    var path: String {
        switch self {
        case .Products:
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
            
        }
    }
    
}
