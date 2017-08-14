//
//  RandomString.swift
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

public class RandomString {

  // MARK: - Enums
  /// Errors thrown by RandomString
  public enum RandomStringError: Error {
    case tooFewBytes
    case invalidCharCount
    case charsNotUnique
    case negativeEntropy
  }
  
  // MARK: - Private Vars (Class)
  private static let instance = RandomString()
  
  // MARK: - Private Vars (Instance)
//  private var chars: Chars

  // MARK: - Public API (Class)
  //
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: Character set for string generation
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public static func string(bits: Float, using charSet: CharSet) -> String {
    return RandomString.instance.string(bits: bits, using: charSet)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
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
  public static func string(bits: Float, using charSet: CharSet, secRand: inout Bool) -> String {
    return RandomString.instance.string(bits: bits, using: charSet, secRand: &secRand)
  }

  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
  /// - parameter bytes: __Bytes__ used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public static func string(bits: Float, using charSet: CharSet, bytes: [UInt8]) throws -> String {
    guard 0 < bits else { throw RandomStringError.negativeEntropy }
    
    let count: Int = Int(ceil(bits / Float(charSet.bitsPerChar)))
    guard 0 < count else { return "" }
    
    let needed = Int(ceil(Float(charSet.bitsPerChar)/8 * Float(count)))
    guard needed <= bytes.count else { throw RandomStringError.tooFewBytes }
    
    let chunks   = count / Int(charSet.charsPerChunk)
    let partials = UInt8(count) % charSet.charsPerChunk
    
    var string = ""
    for chunk in 0 ..< chunks {
      for slice in 0 ..< charSet.charsPerChunk {
        let ndx = charSet.ndxFn(bytes, chunk, slice)
        string.append(char(ndx, from: charSet.chars))
      }
    }
    for slice in 0 ..< partials {
      let ndx = charSet.ndxFn(bytes, chunks, slice)
      string.append(char(ndx, from: charSet.chars))
    }
    return string
  }

  public init() {
//    chars = Chars()
  }
  
  // MARK: - Public API (Instance)
  //
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: Character set for string generation
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
    public func string(bits: Float, using charSet: CharSet) -> String {
    var secRand = true
    return string(bits: bits, using: charSet, secRand: &secRand)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
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
  public func string(bits: Float, using charSet: CharSet, secRand: inout Bool) -> String {
    let count: UInt = UInt(ceil(bits / Float(charSet.bitsPerChar)))
    guard 0 < count else { return "" }
    
    // genBytes sets secRand
    let bytes = Bytes.random(count, charSet.bitsPerChar, &secRand)
    
    // genBytes ensures enough bytes so this call will not fail
    return try! RandomString.string(bits: bits, using: charSet, bytes: bytes)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
  /// - parameter bytes: __Bytes__ used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func string(bits: Float, using charSet: CharSet, bytes: [UInt8]) throws -> String {
    return try RandomString.string(bits: bits, using: charSet, bytes: bytes)
  }
  
  /// Gets a character from the character set.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The characters string
  ///
  /// - return: The character
  private static func char(_ ndx: CharSet.Ndx, from chars: String) -> Character {
    guard Int(ndx) < chars.characters.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
}
