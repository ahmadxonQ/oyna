//
//  NetworkLogger.swift
//  oyna
//
//  Created by Ahmadxon Qodirov on 21/02/25.
//


import Foundation

final class NetworkLogger {
    
    nonisolated(unsafe) static let shared = NetworkLogger()
    private init() {}
    
    private var requests: [NetworkRequest] = []
    
    public func logRequest(
        url: String,
        statusCode: Int,
        headers: [String: LogValue],
        requestData: LogValue,
        responseData: LogValue
    ){
        print("\n🚀 [Network Logger] Request Logged 🚀")
        print("🌐 URL: \(url)")
        print("📡 Status Code: \(statusCode)")

        print("📌 Headers:")
        for (key, value) in headers {
            print("  - \(key): \(value.stringValue)")
        }

        print("📤 Request Data:")
        print(requestData.stringValue)

        print("📥 Response Data:")
        print(responseData.stringValue)

        print("✅ End of Request Log\n")
    }
}
