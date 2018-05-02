//
//  ACL+Header.swift
//  S3Storage
//
//  Created by Anthony Castelli on 5/2/18.
//

import Foundation
import HTTP

protocol Header {
    var header: [String : String]? { get }
}

extension PredefinedACL: Header {
    var header: [String : String]? {
        switch self {
        case .default: return nil
            
        // For Object and Bucket
        case .private: return ["x-amz-acl": "private"]
        case .publicRead: return ["x-amz-acl": "public-read"]
        case .publicReadWrite: return ["x-amz-acl": "public-read-write"]
        case .awsExecRead: return ["x-amz-acl": "aws-exec-read"]
        case .authenticatedRead: return ["x-amz-acl": "authenticated-read"]
            
        // For Object
        case .bucketOwnerRead: return ["x-amz-acl": "bucket-owner-read"]
        case .bucketOwnerFullControl: return ["x-amz-acl": "bucket-owner-full-control"]
            
        // Bucket
        case .logDeliveryWrite: return nil
        }
    }
}


