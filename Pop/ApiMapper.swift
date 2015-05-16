//
//  NetworkService.swift
//  Pop
//
//  Created by Hrishikesh Sawant on 07/05/15.
//  Copyright (c) 2015 Hrishikesh. All rights reserved.
//

import Foundation

protocol ApiMapper {
    typealias T
    func createFromJSON(json: [NSDictionary]) -> T
}
