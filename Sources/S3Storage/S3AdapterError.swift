//
//  S3AdapterError.swift
//  StorageS3
//
//  Created by Anthony Castelli on 4/16/18.
//

import Debugging

/// Errors that can be thrown while working with Local Adapter.
public struct S3AdapterError: Debuggable {
    public static let readableName = "S3 Adapter Error"
    public let identifier: String
    public var reason: String
    public var sourceLocation: SourceLocation?
    public var stackTrace: [String]
    public var suggestedFixes: [String]
    public var possibleCauses: [String]
    
    init(identifier: String, reason: String, suggestedFixes: [String] = [], possibleCauses: [String] = [], source: SourceLocation) {
        self.identifier = identifier
        self.reason = reason
        self.sourceLocation = source
        self.stackTrace = S3AdapterError.makeStackTrace()
        self.suggestedFixes = suggestedFixes
        self.possibleCauses = possibleCauses
    }
}
