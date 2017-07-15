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
  public typealias Byte = UInt8
  public typealias Bytes = [Byte]
  
  #if os(Linux)
  
  // On first use, Random will attempt to load `arc4random_buf`
  
  private typealias Arc4Random_Buf = @convention(c) (ImplicitlyUnwrappedOptional<UnsafeMutableRawPointer>, Int) -> ()
  private var arc4random_buf: Arc4Random_Buf?
  public static var instance = Random()
  
  private init() {
    if let handle = dlopen(nil, RTLD_NOW), let result = dlsym(handle, "arc4random_buf") {
      arc4random_buf = unsafeBitCast(result, to: Arc4Random_Buf.self)
    }
  }

  #endif
  
  /// Generates __Bytes__.
  ///
  /// The number of __Bytes__ returned is sufficient to generate _count_ characters from the `charSet`.
  ///
  /// - parameter count: The number of characters that can be generated.
  /// - paramater charSet: The character set that will be used.
  /// - parameter secRand: On Apple OSes, if _secRand_ is `true`, attempt to use `SecRandomCopyBytes` to
  ///     generate random bytes; if `false` use `arc4random_buf`. This parameter is ignored on Linux OS.
  ///
  /// - return: Random __Bytes__. On Apple OSes, if _secRand_ is passed as `true`, the value on return
  ///     indicates whether `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`) was used.
  ///
  public static func bytes(_ count: UInt, _ charSet: CharSet, _ secRand: inout Bool) -> Bytes {
    // Each slice forms a chars and requires entropy per char bits
    let bytesPerSlice = Double(charSet.entropyPerChar)/8;
    
    let bytesNeeded = Int(ceil(Double(count) * bytesPerSlice))
    var bytes = [Byte](repeating: 0, count: bytesNeeded)

    #if os(Linux)
      let buf = UnsafeMutableRawPointer(mutating: bytes)
      fill(buffer: buf, size: bytes.count)
    #else
      fill(&bytes, &secRand)
    #endif

    return bytes
  }
  
  // MARK: - Private
  
  #if os(Linux)

  private static func fill(buffer: UnsafeMutableRawPointer, size: Int) {
    Random.instance.arc4random_buf?(buffer, size)
  }

  #else

  private static func fill(_ bytes: inout Bytes, _ secRand: inout Bool) {
    // If `secRand` requested, attempt to form bytes using `SecRandomCopyBytes`, which can potentially
    // fail; and if so, use `arc4random` and set the `inout secRand Bool` to `false`
    // to notify that `SecRandomCopyBytes` wasn't used.
    if secRand {
      if SecRandomCopyBytes(kSecRandomDefault, bytes.count, &bytes) != 0 {
        arc4random_buf(&bytes, bytes.count)
        secRand = false
      }
    }
    else {
      arc4random_buf(&bytes, bytes.count)
    }
  }
  
  #endif
  
}
