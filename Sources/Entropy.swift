//
//  Entropy.swift
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

/// Errors thrown by Entropy
public enum EntropyStringError: Error {
  case tooFewBytes
  case negativeEntropy
  case invalidCharCount
  case charsNotUnique
}

public class Entropy {
  static let bitsPerByte: UInt8 = 8

  public private(set) var charset: CharSet

  // MARK: - Public Initializers
  //
  /// Create a `Entropy` instance
  ///
  /// - parameter charset: The default `CharSet`
  public init(_ charset: CharSet) {
    self.charset = charset
  }
  
  /// Create a `Entropy` instance with default `CharSet` set to `.charset32`
  ///
  convenience public init() {
    self.init(CharSet.charset32)
  }
  
  /// Create a `Entropy` instance
  ///
  /// - paramter chars: String of characters for the `CharSet`
  ///
  /// - throws: `.invalidCharCount` if String length not a multiple of 2
  /// - throws: `.charsNotUnique` if any character repeats
  convenience public init(_ chars: String) throws {
    let charset = try CharSet(chars)
    self.init(charset)
  }

  // MARK: - Public Static
  /// Calculates required bits of entropy
  ///
  /// - parameter total: Number of total items expressed as *10^power*
  /// - parameter risk: Accepted probability expressed as 1 in *10^risk* chance of repeat
  ///
  /// - return: Bits of entropy required to cover the *risk* of repeat in *total* items.
  public static func bits(for numStrings: Float , risk: Float) -> Float {
    guard 0 < numStrings else { return 0 }
    let N = numStrings < 10001 ? log2(numStrings) + log2(numStrings-1) : 2 * log2(numStrings)
    return N + log2(risk) - 1
  }
  
  // MARK: - Characters
  //
  /// Sets the default `CharSet` for generating random strings
  ///
  /// - paramter charset: The `CharSet` to use
  public func use(_ charset: CharSet) {
    self.charset = charset
  }
  
  /// Sets the default `CharSet` to use
  ///
  /// - paramter chars: String of characters for the `CharSet`
  ///
  /// - throws: `.invalidCharCount` if String length not a multiple of 2
  /// - throws: `.charsNotUnique` if any character repeats
  public func use(_ chars: String) throws {
    let charset = try CharSet(chars)
    self.charset = charset
  }

  /// The characters of the default `CharSet`
  @available(*, deprecated, message: "use charset.chars instead")
  public var chars: String {
    return charset.chars
  }
  
  // MARK: - Public API
  /// Generates a small ID
  ///
  /// - return: A string with a one in a million chance of repeat in 30 strings.
  public func smallID() -> String {
    var secRand = true
    return string(bits: 29, secRand: &secRand)
  }
  
  /// Generates a small ID
  ///
  /// - parameter charset: The `CharSet` to use
  ///
  /// - return: A string with a one in a million chance of repeat in 30 strings.
  public func smallID(_ charset: CharSet) -> String {
    var secRand = true
    return string(bits: 29, charset: charset, secRand: &secRand)
  }
  
  /// Generates a medium ID
  ///
  /// - return: A string with a one in a billion chance of repeat in a million strings.
  public func mediumID() -> String {
    return mediumID(self.charset)
  }

  /// Generates a medium ID
  ///
  /// - parameter charset: The `CharSet` to use
  ///
  /// - return: A string with a one in a billion chance of repeat in a million strings.
  public func mediumID(_ charset: CharSet) -> String {
    var secRand = true
    return string(bits: 69, charset: charset, secRand: &secRand)
  }
  
  /// Generates a large ID
  ///
  /// - return: A string with a one in a trillion chance of repeat in a billion strings.
  public func largeID() -> String {
    return largeID(self.charset)
  }

  /// Generates a large ID
  ///
  /// - parameter charset: The `CharSet` to use
  ///
  /// - return: A string with a one in a trillion chance of repeat in a billion strings.
  public func largeID(_ charset: CharSet) -> String {
    var secRand = true
    return string(bits: 99, charset: charset, secRand: &secRand)
  }

  /// Generates a 128 bit random session ID.
  ///
  /// - return: A string suitable for a OWASP recommended session ID.
  public func sessionID() -> String {
    return sessionID(self.charset)
  }

  /// Generates a 128 bit random session ID.
  ///
  /// - parameter charset: The `CharSet` to use
  ///
  /// - return: A string suitable for a OWASP recommended session ID.
  public func sessionID(_ charset: CharSet) -> String {
    var secRand = true
    return string(bits: 128, charset: charset, secRand: &secRand)
  }

  /// Generates a 256 bit random token
  ///
  /// - return: A 256 bit string
  public func token() -> String {
    return token(self.charset)
  }
  
  /// Generates a 256 bit random token
  ///
  /// - parameter charset: The `CharSet` to use
  ///
  /// - return: A 256 bit string
  public func token(_ charset: CharSet) -> String {
    var secRand = true
    return string(bits: 256, charset: charset, secRand: &secRand)
  }
  
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
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float, charset: CharSet) -> String {
    var secRand = true
    return string(bits: bits, charset: charset, secRand: &secRand)
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
    return string(bits:bits, charset: self.charset, secRand: &secRand)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charset: The `CharSet` to use
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
  public func string(bits: Float, charset: CharSet, secRand: inout Bool) -> String {
    guard 0 < bits else { return "" }
    // `Bytes.random` sets `secRand`
    let bytes = Bytes.random(bits, charset, &secRand)
    // `Bytes.random` ensures enough bytes so this call will not fail
    return try! string(bits: bits, charset: charset, using: bytes)
  }

  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter bytes: `Bytes` used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float, using bytes: [UInt8]) throws -> String {
    return try string(bits: bits, charset: self.charset, using: bytes)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charset: The `CharSet` to use
  /// - parameter bytes: `Bytes` used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float, charset: CharSet, using bytes: [UInt8]) throws -> String {
    guard !(bits < 0) else { throw EntropyStringError.negativeEntropy }
    guard 0 < bytes.count else { return "" }
    
    let count: Int = Int(ceil(bits / Float(charset.bitsPerChar)))
    guard 0 < count else { return "" }
    
    let needed = Int(ceil(Float(charset.bitsPerChar)/8 * Float(count)))
    guard needed <= bytes.count else { throw EntropyStringError.tooFewBytes }
    
    let chunks   = count / Int(charset.charsPerChunk)
    let partials = UInt8(count % Int(charset.charsPerChunk))
    
    var string = ""
    for chunk in 0 ..< chunks {
      for slice in 0 ..< charset.charsPerChunk {
        let ndx = charset.ndxFn(bytes, chunk, slice)
        string.append(char(ndx, charset))
      }
    }
    for slice in 0 ..< partials {
      let ndx = charset.ndxFn(bytes, chunks, slice)
      string.append(char(ndx, charset))
    }
    return string
  }
  
  // MARK: - Private
  
  /// Gets a character from the current `CharSet` characters.
  ///
  /// - parameter ndx: The index of the character
  ///
  /// - return: The character
  private func char(_ ndx: CharSet.Ndx) -> Character {
    return char(ndx, self.charset)
  }
  
  /// Gets a character from the specified `CharSet` characters.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The characters string
  ///
  /// - return: The character
  private func char(_ ndx: CharSet.Ndx, _ charset: CharSet) -> Character {
    let chars = charset.chars
    guard Int(ndx) < chars.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
  
}
