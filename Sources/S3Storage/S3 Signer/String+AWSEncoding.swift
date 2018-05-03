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
        var allowed = CharacterSet.alphanumerics
        allowed.insert(charactersIn: type)
        return self.addingPercentEncoding(withAllowedCharacters: allowed)
    }
}
