//
//  NetworkRequest.swift
//  oyna
//
//  Created by Ahmadxon Qodirov on 21/02/25.
//

import Foundation

struct NetworkRequest {
    let url: String
    let statusCode: Int
    let headers: [String: String]
    let body: Data
    let response: Data
}


// Enum to support both single values and arrays
public enum LogValue {
    case single(String)
    case multiple([String])

    var stringValue: String {
        switch self {
        case .single(let value):
            return value
        case .multiple(let values):
            return values.joined(separator: "\n  - ")
        }
    }
}

