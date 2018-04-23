//
//  S3Provider.swift
//  StorageS3
//
//  Created by Anthony Castelli on 4/16/18.
//

import Foundation
import Service

/// Registers and boots Local Adapter services.
public final class S3StorageProvider: Provider {
    /// See Provider.repositoryName
    public static let repositoryName = "storage-s3"
    
    /// Create a new Local provider.
    public init() { }
    
    /// See Provider.register
    public func register(_ services: inout Services) throws {
        try services.register(StorageKitProvider())
    }
    
    /// See Provider.boot
    public func didBoot(_ container: Container) throws -> Future<Void> {
        return .done(on: container)
    }
}
