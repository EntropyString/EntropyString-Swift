//
//  RandomString.swift
//  EntropyString
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

public class RandomString {

  // MARK: - Types
  /// An array of unsigned bytes
  public typealias Bytes = [UInt8]
  
  // MARK: - Enums
  /// Errors thrown by RandomString
  enum RandomStringError: Error {
    case tooFewBytes
    case invalidCharCount
    case charsNotUnique
  }
  
  // MARK: - Private Vars (Class)
  private static let instance = RandomString()
  
  // MARK: - Private Vars (Instance)
  private var chars: Chars

  // MARK: - Public API (Class)
  //
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter base: Character base for String generation
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public static func entropy(of bits: Float, using base: CharBase) -> String {
    return RandomString.instance.entropy(of: bits, using: base)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter base: The characters to use
  /// - parameter secure: If _secure_ is `true`, attempt to use `SecRandomCopyBytes` to
  ///     generate the random bytes used to generate the random characters for the returned string;
  ///     otherwise use `arc4random_buf` to generate random bytes.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  ///
  ///     If _secure_ is passed in as `true`, the value of _secure_ on return indicates whether
  ///     `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`) was used.
  public static func entropy(of bits: Float, using base: CharBase, secure: inout Bool) -> String {
    return RandomString.instance.entropy(of: bits, using: base, secure: &secure)
  }

  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter base: The characters to use
  /// - parameter bytes: The array of __UInt8__ btues used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public static func entropy(of bits: Float, using base: CharBase, bytes: Bytes) throws -> String {
    return try RandomString.instance.entropy(of: bits, using: base, bytes: bytes)
  }

  /// The characters being used for a particular base. These characters are fixed for
  /// __RandomString__ class calls.
  ///
  /// - parameter: base: Character base to inspect
  ///
  /// - return: String of characters
  public static func characters(for base: CharBase) -> String {
    return RandomString.instance.characters(for: base)
  }
  
  public init() {
    chars = Chars()
  }
  
  // MARK: - Public API (Instance)
  //
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter base: Character base for String generation
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
    public func entropy(of bits: Float, using base: CharBase) -> String {
    var secure = true
    return entropy(of: bits, using: base, secure: &secure)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter base: The characters to use
  /// - parameter secure: If _secure_ is `true`, attempt to use `SecRandomCopyBytes` to
  ///     generate the random bytes used to generate the random characters for the returned string;
  ///     otherwise use `arc4random_buf` to generate random bytes.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  ///
  ///     If _secure_ is passed in as `true`, the value of _secure_ on return indicates whether
  ///     `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`) was used.
  public func entropy(of bits: Float, using base: CharBase, secure: inout Bool) -> String {
    let count: UInt = UInt(ceil(bits / Float(base.entropyPerChar)))
    guard 0 < count else { return "" }
    
    // genBytes sets secure
    let bytes = RandomString.genBytes(count, base, &secure)
    
    // genBytes ensures enough bytes so this call will not fail
    return try! entropy(of: bits, using: base, bytes: bytes)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter base: The characters to use
  /// - parameter bytes: The array of __UInt8__ btues used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func entropy(of bits: Float, using base: CharBase, bytes: Bytes) throws -> String {
    let count: UInt = UInt(ceil(bits / Float(base.entropyPerChar)))
    guard 0 < count else { return "" }

    let needed = Int(ceil(Float(base.entropyPerChar)/8 * Float(count)))
    guard needed <= bytes.count else { throw RandomStringError.tooFewBytes }
    
    let chunks   = count / base.charsPerChunk
    let partials = count % base.charsPerChunk
    
    var chars: String
    var ndxFn: (Bytes, Int, Int) -> UInt8
    switch base {
    case .base64:
      ndxFn = base64Ndx
      chars = self.chars.base64
    case .base32:
      ndxFn = base32Ndx
      chars = self.chars.base32
    case .base16:
      ndxFn = base16Ndx
      chars = self.chars.base16
    case .base8:
      ndxFn = base8Ndx
      chars = self.chars.base8
    case .base4:
      ndxFn = base4Ndx
      chars = self.chars.base4
    case .base2:
      ndxFn = base2Ndx
      chars = self.chars.base2
    }
    
    var result = ""
    for chunk in 0 ..< chunks {
      for slice in 0 ..< base.charsPerChunk {
        let ndx = ndxFn(bytes, Int(chunk), Int(slice))
        result.append(char(ndx, from: chars))
      }
    }
    for slice in 0..<partials {
      let ndx = ndxFn(bytes, Int(chunks), Int(slice))
      result.append(char(ndx, from: chars))
    }
    
    return result
  }
  
  /// The characters being used for a particular base. These characters can be set on instances
  /// of __RandomString__.
  ///
  /// - parameter: base: Character base to inspect
  ///
  /// - return: String of characters
  public func characters(for base: CharBase) -> String {
    switch base {
    case .base64:
      return chars.base64
    case .base32:
      return chars.base32
    case .base16:
      return chars.base16
    case .base8:
      return chars.base8
    case .base4:
      return chars.base4
    case .base2:
      return chars.base2
    }
  }

  /// Specify the characters to use for a particular base.
  ///
  /// - parameter characters: The string of characters to use
  /// - parameter base: The character base to set
  ///
  /// - throws `invalidCharCount` if not the exact number of characters expected for the base.
  public func use(_ characters: String, for base: CharBase, force: Bool = false) throws {
    switch base {
    case .base64:
      try chars.set(base64: characters, force: force)
    case .base32:
      try chars.set(base32: characters, force: force)
    case .base16:
      try chars.set(base16: characters, force: force)
    case .base8:
      try chars.set(base8: characters, force: force)
    case .base4:
      try chars.set(base4: characters, force: force)
    case .base2:
      try chars.set(base2: characters, force: force)
    }
  }

  // MARK: - Private
  /// Generates __Bytes__.
  ///
  /// The number of __Bytes__ returned is sufficient to generate _count_ characters from the `base`.
  ///
  /// - parameter count: The number of characters that can be generated.
  /// - paramater base: The character base that will be used.
  /// - parameter secure: Whether to attemp to use `SecRandomCopyBytes`. If _secure_ is `true`,
  ///     attempt to use `SecRandomCopyBytes` to generate the random bytes used to generate the
  ///     random characters for the returned string; otherwise use `arc4random_buf` to generate
  ///     random bytes.
  ///
  /// - return: Random __Bytes__. If _secure_ is passed in as `true`, the value of _secure_ on
  ///     return indicates whether `SecRandomCopyBytes` (`true`) or `arc4random_buf` (`false`)
  ///     was used.
  private static func genBytes(_ count: UInt, _ base: CharBase, _ secure: inout Bool) -> Bytes {
    // Each slice forms a chars and requires entropy per char bits
    let bytesPerSlice = Double(base.entropyPerChar)/8;
    
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
  
  /// Determines index into `base64` characters for a specific character.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `base64` characters.
  private func base64Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = 3 * chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>2
    case 1:
      ndx = (bytes[bNum]<<6)>>2 + bytes[bNum+1]>>4
    case 2:
      ndx = (bytes[bNum+1]<<4)>>2 + bytes[bNum+2]>>6
    case 3:
      ndx = (bytes[bNum+2]<<2)>>2
    default:
      fatalError("Invalid slice for base64 chars")
    }
    return ndx
  }

  /// Determines index into `base32` characters for a specific character.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `base32` characters.
  private func base32Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = 5 * chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>3
    case 1:
      ndx = (bytes[bNum]<<5)>>3 + bytes[bNum+1]>>6
    case 2:
      ndx = (bytes[bNum+1]<<2)>>3
    case 3:
      ndx = (bytes[bNum+1]<<7)>>3 + bytes[bNum+2]>>4
    case 4:
      ndx = (bytes[bNum+2]<<4)>>3 + bytes[bNum+3]>>7
    case 5:
      ndx = (bytes[bNum+3]<<1)>>3
    case 6:
      ndx = (bytes[bNum+3]<<6)>>3 + bytes[bNum+4]>>5
    case 7:
      ndx = (bytes[bNum+4]<<3)>>3
    default:
      fatalError("Invalid slice for base32 chars")
    }
    return ndx
  }
  
  /// Determines index into `base16` characters for a specific character.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `base16` characters.
  private func base16Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>4
    case 1:
      ndx = (bytes[bNum]<<4)>>4
    default:
      fatalError("Invalid slice for base16 chars")
    }
    return ndx
  }
  
  /// Determines index into `base8` characters for a specific character.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `base8` characters.
  private func base8Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = 3 * chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>5
    case 1:
      ndx = (bytes[bNum]<<3)>>5
    case 2:
      ndx = (bytes[bNum]<<6)>>5 + bytes[bNum+1]>>7
    case 3:
      ndx = (bytes[bNum+1]<<1)>>5
    case 4:
      ndx = (bytes[bNum+1]<<4)>>5
    case 5:
      ndx = (bytes[bNum+1]<<7)>>5 + bytes[bNum+2]>>6
    case 6:
      ndx = (bytes[bNum+2]<<2)>>5
    case 7:
      ndx = (bytes[bNum+2]<<5)>>5
    default:
      fatalError("Invalid slice for base8 chars")
    }
    return ndx
  }
  
  /// Determines index into `base4` characters for a specific character.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `base4` characters.
  private func base4Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>6
    case 1:
      ndx = (bytes[bNum]<<2)>>6
    case 2:
      ndx = (bytes[bNum]<<4)>>6
    case 3:
      ndx = (bytes[bNum]<<6)>>6
    default:
      fatalError("Invalid slice for base4 chars")
    }
    return ndx
  }
  
  /// Determines index into `base2` characters for a specific character.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `base2` characters.
  private func base2Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>7
    case 1:
      ndx = (bytes[bNum]<<1)>>7
    case 2:
      ndx = (bytes[bNum]<<2)>>7
    case 3:
      ndx = (bytes[bNum]<<3)>>7
    case 4:
      ndx = (bytes[bNum]<<4)>>7
    case 5:
      ndx = (bytes[bNum]<<5)>>7
    case 6:
      ndx = (bytes[bNum]<<6)>>7
    case 7:
      ndx = (bytes[bNum]<<7)>>7
    default:
      fatalError("Invalid slice for base2 chars")
    }
    return ndx
  }

  /// Gets a character from the character base.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The character base
  ///
  /// - return: The character
  private func char(_ ndx: UInt8, from chars: String) -> Character {
    guard Int(ndx) < chars.characters.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
  
  // MARK: - Private Structs
  private struct Chars {
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
    
    private var _base64: String?
    var base64: String {
      return _base64 ?? Chars.default64
    }
    mutating func set(base64: String, force: Bool) throws {
      guard base64.characters.count == Int(CharBase.base64.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: base64) else { throw RandomStringError.charsNotUnique }
      _base64 = base64
    }
    
    private var _base32: String?
    var base32: String {
      return _base32 ?? Chars.default32
    }
    mutating func set(base32: String, force: Bool) throws {
      guard base32.characters.count == Int(CharBase.base32.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: base32) else { throw RandomStringError.charsNotUnique }
      _base32 = base32
    }
    
    private var _base16: String?
    var base16: String {
      return _base16 ?? Chars.default16
    }
    mutating func set(base16: String, force: Bool) throws {
      guard base16.characters.count == Int(CharBase.base16.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: base16) else { throw RandomStringError.charsNotUnique }
      _base16 = base16
    }
    
    private var _base8: String?
    var base8: String {
      return _base8 ?? Chars.default8
    }
    mutating func set(base8: String, force: Bool) throws {
      guard base8.characters.count == Int(CharBase.base8.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: base8) else { throw RandomStringError.charsNotUnique }
      _base8 = base8
    }
    
    private var _base4: String?
    var base4: String {
      return _base4 ?? Chars.default4
    }
    mutating func set(base4: String, force: Bool) throws {
      guard base4.characters.count == Int(CharBase.base4.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: base4) else { throw RandomStringError.charsNotUnique }
      _base4 = base4
    }
    
    private var _base2: String?
    var base2: String {
      return _base2 ?? Chars.default2
    }
    mutating func set(base2: String, force: Bool) throws {
      guard base2.characters.count == Int(CharBase.base2.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: base2) else { throw RandomStringError.charsNotUnique }
      _base2 = base2
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
  
  public enum CharBase: UInt {
    // Supported character bases
    case base64 = 64
    case base32 = 32
    case base16 = 16
    case base8  =  8
    case base4  =  4
    case base2  =  2

    // Entropy per character for the supported character bases
    public var entropyPerChar: UInt {
      get {
        switch self {
        case .base64:
          return 6
        case .base32:
          return 5
        case .base16:
          return 4
        case .base8:
          return 3
        case .base4:
          return 2
        case .base2:
          return 1
        }
      }
    }

    // Characters per chunk of bytes. A slice of bits is used to create a single character. A chunk
    // of bytes is the number of Bytes required for a exact multiple of character slice.
    var charsPerChunk: UInt {
      get {
        switch self {
        case .base64:
          return 4
        case .base32:
          return 8
        case .base16:
          return 2
        case .base8:
          return 8
        case .base4:
          return 4
        case .base2:
          return 8
        }
      }
    }
  }
}
