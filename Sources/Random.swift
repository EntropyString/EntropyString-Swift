//
//  Random.swift
//  EntropyString
//
//  Copyright © 2017 Knoxen. All rights reserved.
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

public class Random {

  public private(set) var charSet: CharSet

  // MARK: - Public Initializers
  //

  public init(_ charSet: CharSet) {
    self.charSet = charSet
  }
  
  convenience public init() {
    self.init(CharSet.charSet32)
  }
  
  convenience public init(_ chars: String) throws {
    let charSet = try CharSet(chars)
    self.init(charSet)
  }

  /// The characters of the default `CharSet`
  @available(*, deprecated, message: "use charSet.chars instead")
  public var chars: String {
    return charSet.chars
  }
  
  public func use(_ charSet: CharSet) {
    self.charSet = charSet
  }
  
  public func use(_ chars: String) throws {
    let charSet = try CharSet(chars)
    self.charSet = charSet
  }
  
  // MARK: - Public API
  //
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float) -> String {
    var secRand = true
    return string(bits: bits, secRand: &secRand)
  }
  
  /// Generates a random session ID.
  ///
  /// - return: A string suitable for a OWASP recommended session ID. The returned string's characters
  ///     are from the character set in use.
  public func sessionID() -> String {
    var secRand = true
    return string(bits: 128, secRand: &secRand)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter secRand: If _secRand_ is `true`, attempt to use `SecRandomCopyBytes` to
  ///     generate the random bytes used to generate the random characters for the returned string;
  ///     otherwise use `arc4random_buf` to generate random bytes.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  ///
  ///     If _secRand_ is passed in as `true`, the value of _secRand_ on return indicates whether
  ///     `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`) was used.
  public func string(bits: Float, secRand: inout Bool) -> String {
    guard 0 < bits else { return "" }
    
    // `Bytes.random` sets `secRand`
    let bytes = Bytes.random(bits, charSet, &secRand)
    
    // `Bytes.random` ensures enough bytes so this call will not fail
    return try! string(bits: bits, using: bytes)
  }

  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter bytes: __Bytes__ used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float, using bytes: [UInt8]) throws -> String {
    guard !(bits < 0) else { throw EntropyStringError.negativeEntropy }
    guard 0 < bytes.count else { return "" }
    
    let count: Int = Int(ceil(bits / Float(charSet.bitsPerChar)))
    guard 0 < count else { return "" }
    
    let needed = Int(ceil(Float(charSet.bitsPerChar)/8 * Float(count)))
    guard needed <= bytes.count else { throw EntropyStringError.tooFewBytes }
    
    let chunks   = count / Int(charSet.charsPerChunk)
    let partials = UInt8(count % Int(charSet.charsPerChunk))
    
    var string = ""
    for chunk in 0 ..< chunks {
      for slice in 0 ..< charSet.charsPerChunk {
        let ndx = charSet.ndxFn(bytes, chunk, slice)
        string.append(char(ndx))
      }
    }
    for slice in 0 ..< partials {
      let ndx = charSet.ndxFn(bytes, chunks, slice)
      string.append(char(ndx))
    }
    return string
  }
  
  // MARK: - Private
  
  /// Gets a character from the current `CharSet` characters.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The characters string
  ///
  /// - return: The character
  private func char(_ ndx: CharSet.Ndx) -> Character {
    let chars = charSet.chars
    guard Int(ndx) < chars.characters.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
}
