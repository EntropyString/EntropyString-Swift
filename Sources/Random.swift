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

/// Errors thrown by Random
public enum EntropyStringError: Error {
  case tooFewBytes
  case negativeEntropy
  case invalidCharCount
  case charsNotUnique
}

public class Random {
  static let bitsPerByte: UInt8 = 8

  public private(set) var charSet: CharSet

  // MARK: - Public Initializers
  //
  /// Create a `Random` instance
  ///
  /// - parameter charSet: The default `CharSet`
  public init(_ charSet: CharSet) {
    self.charSet = charSet
  }
  
  /// Create a `Random` instance with default `CharSet` set to `.charSet32`
  ///
  convenience public init() {
    self.init(CharSet.charSet32)
  }
  
  /// Create a `Random` instance
  ///
  /// - paramter chars: String of characters for the `CharSet`
  ///
  /// - throws: `.invalidCharCount` if String length not a multiple of 2
  /// - throws: `.charsNotUnique` if any character repeats
  convenience public init(_ chars: String) throws {
    let charSet = try CharSet(chars)
    self.init(charSet)
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
  /// - paramter charSet: The `CharSet` to use
  public func use(_ charSet: CharSet) {
    self.charSet = charSet
  }
  
  /// Sets the default `CharSet` to use
  ///
  /// - paramter chars: String of characters for the `CharSet`
  ///
  /// - throws: `.invalidCharCount` if String length not a multiple of 2
  /// - throws: `.charsNotUnique` if any character repeats
  public func use(_ chars: String) throws {
    let charSet = try CharSet(chars)
    self.charSet = charSet
  }

  /// The characters of the default `CharSet`
  @available(*, deprecated, message: "use charSet.chars instead")
  public var chars: String {
    return charSet.chars
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
  /// - parameter charSet: The `CharSet` to use
  ///
  /// - return: A string with a one in a million chance of repeat in 30 strings.
  public func smallID(_ charSet: CharSet) -> String {
    var secRand = true
    return string(bits: 29, charSet: charSet, secRand: &secRand)
  }
  
  /// Generates a medium ID
  ///
  /// - return: A string with a one in a billion chance of repeat in a million strings.
  public func mediumID() -> String {
    return mediumID(self.charSet)
  }

  /// Generates a medium ID
  ///
  /// - parameter charSet: The `CharSet` to use
  ///
  /// - return: A string with a one in a billion chance of repeat in a million strings.
  public func mediumID(_ charSet: CharSet) -> String {
    var secRand = true
    return string(bits: 69, charSet: charSet, secRand: &secRand)
  }
  
  /// Generates a large ID
  ///
  /// - return: A string with a one in a trillion chance of repeat in a billion strings.
  public func largeID() -> String {
    return largeID(self.charSet)
  }

  /// Generates a large ID
  ///
  /// - parameter charSet: The `CharSet` to use
  ///
  /// - return: A string with a one in a trillion chance of repeat in a billion strings.
  public func largeID(_ charSet: CharSet) -> String {
    var secRand = true
    return string(bits: 99, charSet: charSet, secRand: &secRand)
  }

  /// Generates a 128 bit random session ID.
  ///
  /// - return: A string suitable for a OWASP recommended session ID.
  public func sessionID() -> String {
    return sessionID(self.charSet)
  }

  /// Generates a 128 bit random session ID.
  ///
  /// - parameter charSet: The `CharSet` to use
  ///
  /// - return: A string suitable for a OWASP recommended session ID.
  public func sessionID(_ charSet: CharSet) -> String {
    var secRand = true
    return string(bits: 128, charSet: charSet, secRand: &secRand)
  }

  /// Generates a 256 bit random token
  ///
  /// - return: A 256 bit string
  public func token() -> String {
    return token(self.charSet)
  }
  
  /// Generates a 256 bit random token
  ///
  /// - parameter charSet: The `CharSet` to use
  ///
  /// - return: A 256 bit string
  public func token(_ charSet: CharSet) -> String {
    var secRand = true
    return string(bits: 256, charSet: charSet, secRand: &secRand)
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
  public func string(bits: Float, charSet: CharSet) -> String {
    var secRand = true
    return string(bits: bits, charSet: charSet, secRand: &secRand)
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
    return string(bits:bits, charSet: self.charSet, secRand: &secRand)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The `CharSet` to use
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
  public func string(bits: Float, charSet: CharSet, secRand: inout Bool) -> String {
    guard 0 < bits else { return "" }
    // `Bytes.random` sets `secRand`
    let bytes = Bytes.random(bits, charSet, &secRand)
    // `Bytes.random` ensures enough bytes so this call will not fail
    return try! string(bits: bits, charSet: charSet, using: bytes)
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
    return try string(bits: bits, charSet: self.charSet, using: bytes)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The `CharSet` to use
  /// - parameter bytes: `Bytes` used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float, charSet: CharSet, using bytes: [UInt8]) throws -> String {
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
        string.append(char(ndx, charSet))
      }
    }
    for slice in 0 ..< partials {
      let ndx = charSet.ndxFn(bytes, chunks, slice)
      string.append(char(ndx, charSet))
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
    return char(ndx, self.charSet)
  }
  
  /// Gets a character from the specified `CharSet` characters.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The characters string
  ///
  /// - return: The character
  private func char(_ ndx: CharSet.Ndx, _ charSet: CharSet) -> Character {
    let chars = charSet.chars
    guard Int(ndx) < chars.characters.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
  
}
