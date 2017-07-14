//
//  CharSet.swift
//  EntropyString
//
//  Copyright © 2017 Knoxen. All rights reserved.
//
//  The MIT License (MIT)
//
//  Copyright © 2017 Knoxen. All rights reserved.
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

public enum CharSet: UInt {
  // Supported character sets
  case charSet64 = 64
  case charSet32 = 32
  case charSet16 = 16
  case charSet8  =  8
  case charSet4  =  4
  case charSet2  =  2
  
  // Entropy per character for the supported character bases
  public var entropyPerChar: Int {
    return Int(log2(Float(rawValue)))
  }
  
  // Characters per chunk of bytes. A slice of bits is used to create a single character. A chunk
  // of bytes is the number of Bytes required for a exact multiple of character slice.
  var charsPerChunk: Int {
    return CharSet.lcm(entropyPerChar,8) / entropyPerChar
  }

  // Greatest common divisor. Needed for least common multiple
  static func gcd(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    return r != 0 ? gcd(b, r) : b
  }
  
  // Least common multiple
  static func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a,b) * b
  }
  
  // MARK: - Private Structs
  struct Chars {
    // File system and URL safe char set from RFC 4648.
    static let default64 = "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_"
    
    // Remove all upper and lower case vowels and 'Y'; all numbers that look like letters
    // [0,1,5], letters that look like numbers [l], and all letters that have poor distinction
    // between upper and lower case values.
    static let default32 = "2346789bdfghjmnpqrtBDFGHJLMNPQRT"
    
    // Hexadecimal
    static let default16 = "0123456789abcdef"
    
    // Octal
    static let default8  = "01234567"
    
    // DNA alphabet
    static let default4  = "ATCG"
    
    // Binary
    static let default2  = "01"
    
    private var _charSet64: String?
    var charSet64: String {
      return _charSet64 ?? Chars.default64
    }
    mutating func set(charSet64: String, force: Bool) throws {
      guard charSet64.characters.count == Int(CharSet.charSet64.rawValue) else { throw RandomString.RandomStringError.invalidCharCount }
      guard force || unique(string: charSet64) else { throw RandomString.RandomStringError.charsNotUnique }
      _charSet64 = charSet64
    }
    
    private var _charSet32: String?
    var charSet32: String {
      return _charSet32 ?? Chars.default32
    }
    mutating func set(charSet32: String, force: Bool) throws {
      guard charSet32.characters.count == Int(CharSet.charSet32.rawValue) else { throw RandomString.RandomStringError.invalidCharCount }
      guard force || unique(string: charSet32) else { throw RandomString.RandomStringError.charsNotUnique }
      _charSet32 = charSet32
    }
    
    private var _charSet16: String?
    var charSet16: String {
      return _charSet16 ?? Chars.default16
    }
    mutating func set(charSet16: String, force: Bool) throws {
      guard charSet16.characters.count == Int(CharSet.charSet16.rawValue) else { throw RandomString.RandomStringError.invalidCharCount }
      guard force || unique(string: charSet16) else { throw RandomString.RandomStringError.charsNotUnique }
      _charSet16 = charSet16
    }
    
    private var _charSet8: String?
    var charSet8: String {
      return _charSet8 ?? Chars.default8
    }
    mutating func set(charSet8: String, force: Bool) throws {
      guard charSet8.characters.count == Int(CharSet.charSet8.rawValue) else { throw RandomString.RandomStringError.invalidCharCount }
      guard force || unique(string: charSet8) else { throw RandomString.RandomStringError.charsNotUnique }
      _charSet8 = charSet8
    }
    
    private var _charSet4: String?
    var charSet4: String {
      return _charSet4 ?? Chars.default4
    }
    mutating func set(charSet4: String, force: Bool) throws {
      guard charSet4.characters.count == Int(CharSet.charSet4.rawValue) else { throw RandomString.RandomStringError.invalidCharCount }
      guard force || unique(string: charSet4) else { throw RandomString.RandomStringError.charsNotUnique }
      _charSet4 = charSet4
    }
    
    private var _charSet2: String?
    var charSet2: String {
      return _charSet2 ?? Chars.default2
    }
    mutating func set(charSet2: String, force: Bool) throws {
      guard charSet2.characters.count == Int(CharSet.charSet2.rawValue) else { throw RandomString.RandomStringError.invalidCharCount }
      guard force || unique(string: charSet2) else { throw RandomString.RandomStringError.charsNotUnique }
      _charSet2 = charSet2
    }
    
    private func unique(string: String) -> Bool {
      var charSet = Set<Character>()
      var unique = true
      for char in string.characters {
        let (inserted, _) = charSet.insert(char)
        unique = unique && inserted
        if !unique {
          break
        }
      }
      return unique
    }
  }
}
