//
//  S3Adapter.swift
//  StorageS3
//
//  Created by Anthony Castelli on 4/16/18.
//

import Foundation
import Vapor
import AEXML

extension Dictionary {
    init<S: Sequence>(_ s: S) where Element == S.Iterator.Element {
        self.init()
        var iterator = s.makeIterator()
        while let element: Element = iterator.next() {
            self[element.0] = element.1
        }
    }
}

extension Date {
    init(string: String) {
        if string == "" {
            self = Date()
            return
        }
        
        let formatter = DateFormatter()
        formatter.dateFormat = "yyyy-MM-dd'T'hh:mm:ss.zzzZ"
        self = formatter.date(from: string) ?? Date()
    }
}

extension AdapterIdentifier {
    /// The main AWS S3 adapter identifier.
    public static var s3: AdapterIdentifier<S3Adapter> {
        return .init("s3")
    }
}

/// `S3Adapter` provides an interface that allows the handeling of files
/// between Amazon's S3 Simple Storage Solution
public class S3Adapter: Adapter {
    /// The region where S3 bucket is located.
    public let region: Region
    
    /// AWS Access Key
    let accessKey: String
    
    /// AWS Secret Key
    let secretKey: String
    
    /// AWS Security Token. Used to validate temporary credentials, such as
    /// those from an EC2 Instance's IAM role
    let securityToken : String?
    
    /// Used within the AWS HMAC signing
    let service = "s3"
    
    /// Create a new Local adapter.
    public init(accessKey: String, secretKey: String, region: Region, securityToken: String? = nil) throws {
        self.accessKey = accessKey
        self.secretKey = secretKey
        self.region = region
        self.securityToken = securityToken
    }
}

/// Handles all of the network requests
extension S3Adapter {
    public func copy(object: String, from bucket: String, as: String, to targetBucket: String, on container: Container) throws -> EventLoopFuture<ObjectInfo> {
        throw S3AdapterError(identifier: "copy", reason: "Currently not implemented.", source: .capture())
    }
    
    public func create(object: String, in bucket: String, with content: Data, metadata: Codable?, on container: Container) throws -> EventLoopFuture<ObjectInfo> {
        let client = try container.make(Client.self)
        guard let url = URL(string: self.region.host + bucket.finished(with: "/") + object) else {
            throw S3AdapterError(identifier: "write", reason: "Couldnt not generate a valid URL path.", source: .capture())
        }
        let headers = try self.generateAuthHeader(.PUT, urlString: url.absoluteString, payload: .bytes(content))
        
        let request = Request(using: container)
        request.http.method = .PUT
        request.http.headers = headers
        request.http.body = HTTPBody(data: content)
        request.http.url = url
        return try client.respond(to: request).map(to: ObjectInfo.self) { response in
            return ObjectInfo(name: url.lastPathComponent, prefix: nil, size: nil, etag: "MD5-Hash", lastModified: Date())
        }
    }
    
    public func delete(object: String, in bucket: String, on container: Container) throws -> EventLoopFuture<Void> {
        let client = try container.make(Client.self)
        guard let url = URL(string: self.region.host + bucket.finished(with: "/") + object) else {
            throw S3AdapterError(identifier: "get", reason: "Couldnt not generate a valid URL path.", source: .capture())
        }
        let headers = try self.generateAuthHeader(.DELETE, urlString: url.absoluteString, payload: .none)
        let request = Request(using: container)
        request.http.method = .DELETE
        request.http.headers = headers
        request.http.url = url
        return try client.respond(to: request).map(to: Void.self) { response in
            guard response.http.status == .ok else {
                throw S3AdapterError(identifier: "delete", reason: "Couldnt not delete the file.", source: .capture())
            }
            return ()
        }
    }
    
    public func get(object: String, in bucket: String, on container: Container) throws -> EventLoopFuture<Data> {
        let client = try container.make(Client.self)
        guard let url = URL(string: self.region.host + bucket.finished(with: "/") + object) else {
            throw S3AdapterError(identifier: "get", reason: "Couldnt not generate a valid URL path.", source: .capture())
        }
        let headers = try self.generateAuthHeader(.GET, urlString: url.absoluteString, payload: .none)
        let request = Request(using: container)
        request.http.method = .GET
        request.http.headers = headers
        request.http.url = url
        return try client.respond(to: request).map(to: Data.self) { response in
            guard let data = response.http.body.data else {
                throw S3AdapterError(identifier: "get", reason: "Couldnt not extract data from the request.", source: .capture())
            }
            return data
        }
    }
    
    public func listObjects(in bucket: String, prefix: String?, on container: Container) throws -> EventLoopFuture<[ObjectInfo]> {
        let client = try container.make(Client.self)
        var urlComponents = URLComponents(string: self.region.host)
        urlComponents?.path = "/" + bucket
        urlComponents?.queryItems = []
        urlComponents?.queryItems?.append(URLQueryItem(name: "list-type", value: "2"))
        if let prefix = prefix {
            urlComponents?.queryItems?.append(URLQueryItem(name: "prefix", value: prefix))
        }
        guard let url = urlComponents?.url else {
            throw S3AdapterError(identifier: "list", reason: "Couldnt not generate a valid URL path.", source: .capture())
        }
        
        let headers = try self.generateAuthHeader(.GET, urlString: url.absoluteString, payload: .none)
        let request = Request(using: container)
        request.http.method = .GET
        request.http.headers = headers
        request.http.url = url
        return try client.respond(to: request).map(to: [ObjectInfo].self) { response in
            guard response.http.status == .ok else {
                throw S3AdapterError(identifier: "list", reason: "Error: \(response.http.status.reasonPhrase). There requested returned a \(response.http.status.code)", source: .capture())
            }
            guard let data = response.http.body.data else {
                throw S3AdapterError(identifier: "list", reason: "Couldnt not extract the data from the request.", source: .capture())
            }
            print(String(bytes: data, encoding: .utf8)!)
            let xml = try AEXMLDocument(xml: data)
            let items = xml.root.allDescendants(where: { $0.name == "Contents" }).map({ Dictionary($0.children.compactMap({ [$0.name: $0.value ?? ""] }).reduce([], { $0 + $1 })) })
            return items.map({ ObjectInfo(name: $0["Key"] ?? "", prefix: $0["Prefix"], size: Int($0["Size"] ?? "0"), etag: $0["ETag"] ?? "", lastModified: Date(string: $0["LastModified"] ?? "")) })
        }
    }
}

extension S3Adapter {
    public func create(bucket: String, metadata: Codable?, on container: Container) throws -> EventLoopFuture<Void> {
        fatalError("Not implemented")
    }
    
    public func delete(bucket: String, on container: Container) throws -> EventLoopFuture<Void> {
        fatalError("Not implemented")
    }
    
    public func get(bucket: String, on container: Container) throws -> EventLoopFuture<BucketInfo?> {
        fatalError("Not implemented")
    }
    
    public func list(on container: Container) throws -> EventLoopFuture<[BucketInfo]> {
        fatalError("Not implemented")
    }
}
