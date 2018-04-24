//
//  String+AWSEncoding.swift
//  StorageS3
//
//  Created by Anthony Castelli on 4/16/18.
//

import Foundation

struct AWSEncoding {
    internal static let QueryAllowed = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._~=&"
    internal static let PathAllowed  = "0123456789abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ-._~/"
}

extension String {
    func awsStringEncoding(_ type: String) -> String? {
        let allowed = NSMutableCharacterSet.alphanumeric()
        allowed.addCharacters(in: type)
        return self.addingPercentEncoding(withAllowedCharacters: allowed as CharacterSet)
    }
}
