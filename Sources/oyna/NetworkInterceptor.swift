//
//  NetworkInterceptor.swift
//  oyna
//
//  Created by Ahmadxon Qodirov on 21/02/25.
//

import Foundation

public class NetworkInterceptor: URLProtocol {
    
    nonisolated(unsafe) public static var loggedRequests: [(request: URLRequest, response: HTTPURLResponse?, data: Data?)] = []
    
    
    public override class func canInit(with request: URLRequest) -> Bool {
        if URLProtocol.property(forKey: "Intercepted", in: request) != nil {
            return false
        }
        return true
        
    }
    
    public override class func canonicalRequest(for request: URLRequest) -> URLRequest {
        request
    }
    
    
    public override func startLoading() {
        guard let client = client else { return }
        
        let request = self.request
        let startTime = Date()
        
        let task = URLSession.shared.dataTask(with: request) { data, response, error in
            let endTime = Date()
            let duration = endTime.timeIntervalSince(startTime)
            
            
            var responseLog: HTTPURLResponse?
            if let httpResponse = response as? HTTPURLResponse {
                responseLog = httpResponse
            }
            
            let headersDict = (responseLog?.allHeaderFields as? [String: String])?.reduce(into: [String: LogValue]()) { result, pair in
                result[pair.key] = .single(pair.value)
            } ?? [:]
            
            // Log the request
            NetworkInterceptor.loggedRequests.append((request, responseLog, data))
            
            NetworkLogger.shared.logRequest(
                url: request.url?.absoluteString ?? "Unknown URL",
                statusCode: responseLog?.statusCode ?? 0,
                headers: headersDict,
                requestData: request.httpBody.map { .single(String(decoding: $0, as: UTF8.self)) } ?? .single("No Request Body"),
                responseData: data.map { .single(String(decoding: $0, as: UTF8.self)) } ?? .single("No Response Data")
            )
            
            // Send response back to the client
            if let response = response {
                client.urlProtocol(self, didReceive: response, cacheStoragePolicy: .notAllowed)
            }
            
            if let data = data {
                client.urlProtocol(self, didLoad: data)
            }
            
            if let error = error {
                client.urlProtocol(self, didFailWithError: error)
            }
            
            client.urlProtocolDidFinishLoading(self)
        }
        
        task.resume()
    }
    
    // Stop loading the request
    public override func stopLoading() {
        print("Loading stopped")
    }
    
    // Register this class as a URLProtocol
    public static func register() {
        URLProtocol.registerClass(NetworkInterceptor.self)
    }
}
   
