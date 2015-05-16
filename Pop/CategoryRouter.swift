//
//  CategoryRouter.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 06/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation
import Alamofire

enum CategoryRouter: URLRequestConvertible {
    
    static let baseUrlString = ApiRouter.baseURLString + "/categories"
    
    // Cases
    case CategoriesWithAttributes()
    
    // Methods
    var method: Alamofire.Method {
        switch self {
        case .CategoriesWithAttributes:
            return .GET
        }
    }
    
    // Url endpoints
    var path: String {
        switch self {
        case .CategoriesWithAttributes:
            return ""
        }
    }
    
    
    var URLRequest: NSURLRequest {
        let URL = NSURL(string: CategoryRouter.baseUrlString)!
        let mutableURLRequest = NSMutableURLRequest(URL: URL.URLByAppendingPathComponent(path))
        mutableURLRequest.HTTPMethod = method.rawValue
        
        switch self {
        case .CategoriesWithAttributes():
            return Alamofire.ParameterEncoding.URL.encode(mutableURLRequest, parameters: nil).0
        }
    }
}
