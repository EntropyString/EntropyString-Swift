//
//  Bytes.swift
//  EntropyString
//
//  Copyright © 2017-2018 Knoxen. All rights reserved.
//
//  The MIT License (MIT)
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//
import Foundation

internal struct Bytes {
  #if os(Linux)
  // On first use will attempt to load `arc4random_buf`
  private typealias Arc4Random_Buf = @convention(c) (ImplicitlyUnwrappedOptional<UnsafeMutableRawPointer>, Int) -> ()
  private var arc4random_buf: Arc4Random_Buf?
  private static var instance = Bytes()
  
  private init() {
    if let handle = dlopen(nil, RTLD_NOW), let result = dlsym(handle, "arc4random_buf") {
      arc4random_buf = unsafeBitCast(result, to: Arc4Random_Buf.self)
    }
  }
  #endif
  
  /// Generates random bytes
  ///
  /// The number of bytes returned is sufficient to generate a string with `bits` of entropy using `CharSet`
  ///
  /// - parameter bits: Entropy bits
  /// - paramater charset: The character set that will be used.
  /// - parameter secRand: On Apple OSes, if _secRand_ is `true`, attempt to use `SecRandomCopyBytes` to
  ///     generate random bytes; if `false` use `arc4random_buf`. This parameter is ignored on Linux OS.
  ///
  /// - return: Random bytes. On Apple OSes, if _secRand_ is passed as `true`, the value on return
  ///     indicates whether `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`) was used.
  ///
  static func random(_ bits: Float, _ charset: CharSet, _ secRand: inout Bool) -> [UInt8] {
    let bytesNeeded = charset.bytesNeeded(bits: bits)
    var bytes = [UInt8](repeating: 0, count: bytesNeeded)
    
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
    Bytes.instance.arc4random_buf?(buffer, size)
  }
  #else
  private static func fill(_ bytes: inout [UInt8], _ secRand: inout Bool) {
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
