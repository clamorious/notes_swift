//
//  MD5.swift
//  notes
//
//  Created by Douglas Gelsleichter on 10/11/19.
//  Copyright © 2019 Douglas Gelsleichter. All rights reserved.
//

import Foundation
import CommonCrypto

class MD5 {
    
    static func encrypt(_ string: String) -> String? {
        let length = Int(CC_MD5_DIGEST_LENGTH)
        var digest = [UInt8](repeating: 0, count: length)

        if let d = string.data(using: String.Encoding.utf8) {
            _ = d.withUnsafeBytes { (body: UnsafePointer<UInt8>) in
                CC_MD5(body, CC_LONG(d.count), &digest)
            }
        }

        return (0..<length).reduce("") {
            $0 + String(format: "%02x", digest[$1])
        }
    }
}
