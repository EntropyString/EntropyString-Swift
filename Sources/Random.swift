//
//  Random.swift
//  EntropyString
//
//  Created by Paul Rogers on 7/14/17.
//  Copyright © 2017 Knoxen. All rights reserved.
//

import Foundation

public struct Random {
  
  // MARK: - Types
  /// An array of unsigned bytes
  public typealias Byte = UInt8
  public typealias Bytes = [Byte]
  
  // MARK: - Private
  /// Generates __Bytes__.
  ///
  /// The number of __Bytes__ returned is sufficient to generate _count_ characters from the `charSet`.
  ///
  /// - parameter count: The number of characters that can be generated.
  /// - paramater charSet: The character set that will be used.
  /// - parameter secure: Whether to attemp to use `SecRandomCopyBytes`. If _secure_ is `true`,
  ///     attempt to use `SecRandomCopyBytes` to generate the random bytes used to generate the
  ///     random characters for the returned string; otherwise use `arc4random_buf` to generate
  ///     random bytes.
  ///
  /// - return: Random __Bytes__. If _secure_ is passed in as `true`, the value of _secure_ on
  ///     return indicates whether `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`)
  ///     was used.
  static func bytes(_ count: UInt, _ charSet: CharSet, _ secure: inout Bool) -> Bytes {
    // Each slice forms a chars and requires entropy per char bits
    let bytesPerSlice = Double(charSet.entropyPerChar)/8;
    
    let bytesNeeded = Int(ceil(Double(count) * bytesPerSlice))
    var bytes = [UInt8](repeating: 0, count: bytesNeeded)
    
    // If secure requested, attempt to form bytes using SecRandomCopyBytes, which can potentially
    // fail, and if so, use arc4random (which is also purportedly "secure", but less so) and
    // set the inout secure Bool to false to notify that SecRandomCopyBytes wasn't used.
    if secure {
      if SecRandomCopyBytes(kSecRandomDefault, bytesNeeded, &bytes) != 0 {
        arc4random_buf(&bytes, bytesNeeded);
        secure = false
      }
    }
    else {
      arc4random_buf(&bytes, bytesNeeded);
    }
    return bytes
  }
  

}
