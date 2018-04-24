//
//  Payload.swift
//  S3Storage
//
//  Created by Anthony Castelli on 4/23/18.
//

import Foundation
import Vapor
import Crypto

public enum Payload {
    case bytes(Data)
    case none
    case unsigned
}

extension Payload {
    internal func hashed() throws -> String {
        switch self {
        case .bytes(let bytes): return try SHA256.hash(bytes).hexEncodedString()
        case .none: return try SHA256.hash("".convertToData()).hexEncodedString()
        case .unsigned: return "UNSIGNED-PAYLOAD"
        }
    }
    
    internal var bytes: Data {
        switch self {
        case .bytes(let bytes): return bytes
        default: return "".convertToData()
        }
    }
    
    internal var isBytes: Bool {
        switch self {
        case .bytes( _), .none: return true
        default: return false
        }
    }
    
    internal var size: String {
        switch self {
        case .bytes, .none: return self.bytes.count.description
        case .unsigned: return "UNSIGNED-PAYLOAD"
        }
    }
    
    internal var isUnsigned: Bool {
        switch self {
        case .unsigned: return true
        default: return false
        }
    }
}
