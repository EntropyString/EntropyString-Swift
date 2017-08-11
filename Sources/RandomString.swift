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

  public typealias Byte  = Random.Byte
  public typealias Bytes = Random.Bytes

  typealias CharNdx = UInt8

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
  public static func entropy(of bits: Float, using charSet: CharSet, secRand: inout Bool) -> String {
    return RandomString.instance.entropy(of: bits, using: charSet, secRand: &secRand)
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
  public static func entropy(of bits: Float, using charSet: CharSet, bytes: Random.Bytes) throws -> String {
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
    var secRand = true
    return entropy(of: bits, using: charSet, secRand: &secRand)
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
  public func entropy(of bits: Float, using charSet: CharSet, secRand: inout Bool) -> String {
    let count: UInt = UInt(ceil(bits / Float(charSet.bitsPerChar)))
    guard 0 < count else { return "" }
    
    // genBytes sets secRand
    let bytes = Random.bytes(count, charSet, &secRand)
    
    // genBytes ensures enough bytes so this call will not fail
    return try! entropy(of: bits, using: charSet, bytes: bytes)
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
  public func entropy(of bits: Float, using charSet: CharSet, bytes: Bytes) throws -> String {
    guard 0 < bits else { throw RandomStringError.negativeEntropy }
    
    let count: Int = Int(ceil(bits / Float(charSet.bitsPerChar)))
    guard 0 < count else { return "" }

    let needed = Int(ceil(Float(charSet.bitsPerChar)/8 * Float(count)))
    guard needed <= bytes.count else { throw RandomStringError.tooFewBytes }
    
    let chunks   = count / charSet.charsPerChunk
    let partials = count % charSet.charsPerChunk
    
    var chars: String
    var ndxFn: (Bytes, Int, Int) -> CharNdx
    switch charSet {
    case .charSet64:
      ndxFn = ndx64
      chars = self.chars.charSet64
    case .charSet32:
      ndxFn = ndx32
      chars = self.chars.charSet32
    case .charSet16:
      ndxFn = ndx16
      chars = self.chars.charSet16
    case .charSet8:
      ndxFn = ndx8
      chars = self.chars.charSet8
    case .charSet4:
      ndxFn = ndx4
      chars = self.chars.charSet4
    case .charSet2:
      ndxFn = ndx2
      chars = self.chars.charSet2
    }
    
    var string = ""
    for chunk in 0 ..< chunks {
      for slice in 0 ..< charSet.charsPerChunk {
        let ndx = ndxFn(bytes, Int(chunk), Int(slice))
        string.append(char(ndx, from: chars))
      }
    }
    for slice in 0 ..< partials {
      let ndx = ndxFn(bytes, Int(chunks), Int(slice))
      string.append(char(ndx, from: chars))
    }
    
    return string
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
  public func use(_ characters: String, for charSet: CharSet) throws {
    switch charSet {
    case .charSet64:
      try chars.set(charSet64: characters)
    case .charSet32:
      try chars.set(charSet32: characters)
    case .charSet16:
      try chars.set(charSet16: characters)
    case .charSet8:
      try chars.set(charSet8: characters)
    case .charSet4:
      try chars.set(charSet4: characters)
    case .charSet2:
      try chars.set(charSet2: characters)
    }
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
  private func ndx64(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> CharNdx {
    guard slice < CharSet.charSet64.charsPerChunk else { fatalError("Invalid slice for charSet64 chars") }
    return ndxGen(bytes, chunk, slice, 6)
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
  private func ndx32(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> CharNdx {
    guard slice < CharSet.charSet32.charsPerChunk else { fatalError("Invalid slice for charSet32 chars") }
    return ndxGen(bytes, chunk, slice, 5)
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
  private func ndx16(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> CharNdx {
    guard slice < CharSet.charSet16.charsPerChunk else { fatalError("Invalid slice for charSet16 chars") }
    return (bytes[chunk]<<UInt8(4*slice))>>4
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
  private func ndx8(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> CharNdx {
    guard slice < CharSet.charSet8.charsPerChunk else { fatalError("Invalid slice for charSet8 chars") }
    return ndxGen(bytes, chunk, slice, 3)
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
  private func ndx4(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> CharNdx {
    guard slice < CharSet.charSet4.charsPerChunk else { fatalError("Invalid slice for charSet4 chars") }
    return (bytes[chunk]<<UInt8(2*slice))>>6
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
  private func ndx2(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> CharNdx {
    guard slice < CharSet.charSet2.charsPerChunk else { fatalError("Invalid slice for charSet2 chars") }
    return (bytes[chunk]<<UInt8(slice))>>7
  }

  /// Determines index into general CharSet characters.
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
  private func ndxGen(_ bytes: Bytes, _ chunk: Int, _ slice: Int, _ bitsPerSlice: Int) -> CharNdx {
    var ndx: CharNdx = 0
    
    let bitsPerByte: Int = 8
    let slicesPerChunk = CharSet.lcm(bitsPerSlice, bitsPerByte) / bitsPerByte

    let bNum = chunk * slicesPerChunk
    
    let rShiftIt = UInt8(bitsPerByte - bitsPerSlice)
    
    let lOffset = Int(Float(slice*bitsPerSlice/bitsPerByte))
    let lShift = UInt8((slice*bitsPerSlice) % bitsPerByte)
    ndx = (bytes[bNum+lOffset]<<(lShift))>>UInt8(rShiftIt)
    
    let rOffset = Int(ceil(Float(slice*bitsPerSlice)/Float(bitsPerByte)))
    let rShift = UInt8((bitsPerByte*(rOffset+1) - (slice+1)*bitsPerSlice) % bitsPerByte)
    if (rShiftIt < rShift) {
      ndx += bytes[bNum+rOffset]>>rShift
    }
    return ndx
  }

  /// Gets a character from the character set.
  ///
  /// - parameter ndx: The index of the character
  /// - parameter chars: The characters string
  ///
  /// - return: The character
  private func char(_ ndx: CharNdx, from chars: String) -> Character {
    guard Int(ndx) < chars.characters.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
  
}
