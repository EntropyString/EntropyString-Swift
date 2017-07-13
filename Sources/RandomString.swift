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
  public enum RandomStringError: Error {
    case tooFewBytes
    case invalidCharCount
    case charsNotUnique
  }
  
  // MARK: - Private Vars (Class)
  private static let instance = RandomString()
  
  // MARK: - Private Vars (Instance)
  private var chars: CharSet.Chars

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
    chars = CharSet.Chars()
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
    for slice in 0..<partials {
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
  private func ndx64(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    guard slice < 4 else { fatalError("Invalid slice for charSet64 chars") }
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
  private func ndx32(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    guard slice < 8 else { fatalError("Invalid slice for charSet32 chars") }
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
  private func ndx16(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    guard slice < 2 else { fatalError("Invalid slice for charSet16 chars") }
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
  private func ndx8(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    guard slice < 8 else { fatalError("Invalid slice for charSet8 chars") }
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
  private func ndx4(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    guard slice < 4 else { fatalError("Invalid slice for charSet4 chars") }
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
  private func ndx2(_ bytes: Bytes, _ chunk: Int, _ slice: Int) -> UInt8 {
    guard slice < 8 else { fatalError("Invalid slice for charSet2 chars") }
    return (bytes[chunk]<<UInt8(slice))>>7
  }

  private func ndxGen(_ bytes: Bytes, _ chunk: Int, _ slice: Int, _ bitsPerSlice: Int) -> UInt8 {
    var ndx: UInt8 = 0
    
    let bitsPerByte: Int = 8
    let slicesPerChunk = lcm(bitsPerSlice, bitsPerByte) / bitsPerByte

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
  private func char(_ ndx: UInt8, from chars: String) -> Character {
    guard Int(ndx) < chars.characters.count else { fatalError("Index out of bounds") }
    let charIndex = chars.index(chars.startIndex, offsetBy: Int(ndx))
    return chars[charIndex]
  }
  
  private func gcd(_ a: Int, _ b: Int) -> Int {
    let r = a % b
    return r != 0 ? gcd(b, r) : b
  }

  private func lcm(_ a: Int, _ b: Int) -> Int {
    return a / gcd(a,b) * b
  }
  
}
