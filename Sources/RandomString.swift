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
  /// - parameter charSet: Character set for string generation
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public static func entropy(of bits: Float, using charSet: CharSet) -> String {
    return RandomString.instance.entropy(of: bits, using: charSet)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
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
  public static func entropy(of bits: Float, using charSet: CharSet, secure: inout Bool) -> String {
    return RandomString.instance.entropy(of: bits, using: charSet, secure: &secure)
  }

  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
  /// - parameter bytes: The array of __UInt8__ btues used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public static func entropy(of bits: Float, using charSet: CharSet, bytes: Bytes) throws -> String {
    return try RandomString.instance.entropy(of: bits, using: charSet, bytes: bytes)
  }

  /// The characters being used for a particular charSet. These characters are fixed for
  /// __RandomString__ class calls.
  ///
  /// - parameter: charSet: Character set to inspect
  ///
  /// - return: String of characters
  public static func characters(for charSet: CharSet) -> String {
    return RandomString.instance.characters(for: charSet)
  }
  
  public init() {
    chars = Chars()
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
    public func entropy(of bits: Float, using charSet: CharSet) -> String {
    var secure = true
    return entropy(of: bits, using: charSet, secure: &secure)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
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
  public func entropy(of bits: Float, using charSet: CharSet, secure: inout Bool) -> String {
    let count: UInt = UInt(ceil(bits / Float(charSet.entropyPerChar)))
    guard 0 < count else { return "" }
    
    // genBytes sets secure
    let bytes = RandomString.genBytes(count, charSet, &secure)
    
    // genBytes ensures enough bytes so this call will not fail
    return try! entropy(of: bits, using: charSet, bytes: bytes)
  }
  
  /// Generates a random string.
  ///
  /// - parameter bits: Minimum bits of entropy.
  /// - parameter charSet: The character set to use
  /// - parameter bytes: The array of __UInt8__ btues used to generate characters.
  ///
  /// - throws: `.tooFewBytes` if there are an insufficient number of bytes to generate the string.
  ///
  /// - return: A string. The returned string's entropy is a multiple of the _entropy per char_
  ///     for the character set in use. The entropy returned is the smallest such multiple larger
  ///     than `bits`.
  public func entropy(of bits: Float, using charSet: CharSet, bytes: Bytes) throws -> String {
    let count: UInt = UInt(ceil(bits / Float(charSet.entropyPerChar)))
    guard 0 < count else { return "" }

    let needed = Int(ceil(Float(charSet.entropyPerChar)/8 * Float(count)))
    guard needed <= bytes.count else { throw RandomStringError.tooFewBytes }
    
    let chunks   = count / charSet.charsPerChunk
    let partials = count % charSet.charsPerChunk
    
    var chars: String
    var ndxFn: (Bytes, Int, Int) -> UInt8
    switch charSet {
    case .charSet64:
      ndxFn = charSet64Ndx
      chars = self.chars.charSet64
    case .charSet32:
      ndxFn = charSet32Ndx
      chars = self.chars.charSet32
    case .charSet16:
      ndxFn = charSet16Ndx
      chars = self.chars.charSet16
    case .charSet8:
      ndxFn = charSet8Ndx
      chars = self.chars.charSet8
    case .charSet4:
      ndxFn = charSet4Ndx
      chars = self.chars.charSet4
    case .charSet2:
      ndxFn = charSet2Ndx
      chars = self.chars.charSet2
    }
    
    var result = ""
    for chunk in 0 ..< chunks {
      for slice in 0 ..< charSet.charsPerChunk {
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
  
  /// The characters being used for a particular charSet. These characters can be set on instances
  /// of __RandomString__.
  ///
  /// - parameter: charSet: Character set to inspect
  ///
  /// - return: String of characters
  public func characters(for charSet: CharSet) -> String {
    switch charSet {
    case .charSet64:
      return chars.charSet64
    case .charSet32:
      return chars.charSet32
    case .charSet16:
      return chars.charSet16
    case .charSet8:
      return chars.charSet8
    case .charSet4:
      return chars.charSet4
    case .charSet2:
      return chars.charSet2
    }
  }

  /// Specify the characters to use for a particular character set.
  ///
  /// - parameter characters: The string of characters to use
  /// - parameter charSet: The character set to alter
  ///
  /// - throws `invalidCharCount` if not the exact number of characters expected for the charSet.
  public func use(_ characters: String, for charSet: CharSet, force: Bool = false) throws {
    switch charSet {
    case .charSet64:
      try chars.set(charSet64: characters, force: force)
    case .charSet32:
      try chars.set(charSet32: characters, force: force)
    case .charSet16:
      try chars.set(charSet16: characters, force: force)
    case .charSet8:
      try chars.set(charSet8: characters, force: force)
    case .charSet4:
      try chars.set(charSet4: characters, force: force)
    case .charSet2:
      try chars.set(charSet2: characters, force: force)
    }
  }

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
  private static func genBytes(_ count: UInt, _ charSet: CharSet, _ secure: inout Bool) -> Bytes {
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
  
  /// Determines index into `charSet64` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet64` characters.
  private func charSet64Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
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
      fatalError("Invalid slice for charSet64 chars")
    }
    return ndx
  }

  /// Determines index into `charSet32` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet32` characters.
  private func charSet32Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
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
      fatalError("Invalid slice for charSet32 chars")
    }
    return ndx
  }
  
  /// Determines index into `charSet16` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet16` characters.
  private func charSet16Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    let bNum = chunk
    var ndx: UInt8 = 0
    switch slice {
    case 0:
      ndx = bytes[bNum]>>4
    case 1:
      ndx = (bytes[bNum]<<4)>>4
    default:
      fatalError("Invalid slice for charSet16 chars")
    }
    return ndx
  }
  
  /// Determines index into `charSet8` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet8` characters.
  private func charSet8Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
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
      fatalError("Invalid slice for charSet8 chars")
    }
    return ndx
  }
  
  /// Determines index into `charSet4` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet4` characters.
  private func charSet4Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
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
      fatalError("Invalid slice for charSet4 chars")
    }
    return ndx
  }
  
  /// Determines index into `charSet2` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// chunk of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet2` characters.
  private func charSet2Ndx(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
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
      fatalError("Invalid slice for charSet2 chars")
    }
    return ndx
  }

  /// Gets a character from the character set.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The characters string
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
    
    private var _charSet64: String?
    var charSet64: String {
      return _charSet64 ?? Chars.default64
    }
    mutating func set(charSet64: String, force: Bool) throws {
      guard charSet64.characters.count == Int(CharSet.charSet64.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: charSet64) else { throw RandomStringError.charsNotUnique }
      _charSet64 = charSet64
    }
    
    private var _charSet32: String?
    var charSet32: String {
      return _charSet32 ?? Chars.default32
    }
    mutating func set(charSet32: String, force: Bool) throws {
      guard charSet32.characters.count == Int(CharSet.charSet32.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: charSet32) else { throw RandomStringError.charsNotUnique }
      _charSet32 = charSet32
    }
    
    private var _charSet16: String?
    var charSet16: String {
      return _charSet16 ?? Chars.default16
    }
    mutating func set(charSet16: String, force: Bool) throws {
      guard charSet16.characters.count == Int(CharSet.charSet16.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: charSet16) else { throw RandomStringError.charsNotUnique }
      _charSet16 = charSet16
    }
    
    private var _charSet8: String?
    var charSet8: String {
      return _charSet8 ?? Chars.default8
    }
    mutating func set(charSet8: String, force: Bool) throws {
      guard charSet8.characters.count == Int(CharSet.charSet8.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: charSet8) else { throw RandomStringError.charsNotUnique }
      _charSet8 = charSet8
    }
    
    private var _charSet4: String?
    var charSet4: String {
      return _charSet4 ?? Chars.default4
    }
    mutating func set(charSet4: String, force: Bool) throws {
      guard charSet4.characters.count == Int(CharSet.charSet4.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: charSet4) else { throw RandomStringError.charsNotUnique }
      _charSet4 = charSet4
    }
    
    private var _charSet2: String?
    var charSet2: String {
      return _charSet2 ?? Chars.default2
    }
    mutating func set(charSet2: String, force: Bool) throws {
      guard charSet2.characters.count == Int(CharSet.charSet2.rawValue) else { throw RandomStringError.invalidCharCount }
      guard force || unique(string: charSet2) else { throw RandomStringError.charsNotUnique }
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
