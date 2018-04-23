//
//  Region.swift
//  StorageS3
//
//  Created by Anthony Castelli on 4/16/18.
//

/// AWS Region
public enum Region: String {
    /// US East (N. Virginia)
    case usEast1 = "us-east-1"
    
    /// US East (Ohio)
    case usEast2 = "us-east-2"
    
    /// US West (N. California)
    case usWest1 = "us-west-1"
    
    /// US West (Oregon)
    case usWest2 = "us-west-2"
    
    /// Canada (Central)
    case caCentral1 = "ca-central-1" // Canada (Central)
    
    /// EU (Frankfurt)
    case euCentral1 = "eu-central-1" // EU (Frankfurt)
    
    /// EU (Ireland)
    case euWest1 = "eu-west-1"
    
    /// EU (London)
    case euWest2 = "eu-west-2"
    
    /// EU (Paris)
    case euWest3 = "eu-west-3"
    
    /// Asia Pacific (Tokyo)
    case apNortheast1 = "ap-northeast-1"
    
    /// Asia Pacific (Seoul)
    case apNortheast2 = "ap-northeast-2"
    
    /// Asia Pacific (Osaka-Local)
    case apNortheast3 = "ap-northeast-3"
    
    /// Asia Pacific (Singapore)
    case apSoutheast1 = "ap-southeast-1"
    
    /// Asia Pacific (Sydney
    case apSoutheast2 = "ap-southeast-2"
    
    /// Asia Pacific (Mumbai)
    case apSouth1 = "ap-south-1"
    
    /// South America (São Paulo)
    case saEast1 = "sa-east-1"
}

extension Region {
    /// Generate the base URL
    public var host: String {
        return "https://s3.\(self.rawValue).amazonaws.com".finished(with: "/")
    }
}
