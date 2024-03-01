//
//  MD5Hash.swift
//  race-condition-5e
//
//  Created by Sergei Panov on 01.03.2024.
//

import Foundation
import CryptoKit

public func generateMD5Hash(strings: [String]) -> String {
    let concatenatedString = strings.joined()
    
    if let data = concatenatedString.data(using: .utf8) {
        let md5 = Insecure.MD5.hash(data: data)
        let md5String = md5.map { String(format: "%02hhx", $0) }.joined()
        return md5String
    } else {
        // Handle error in converting string to data
        return ""
    }
}
