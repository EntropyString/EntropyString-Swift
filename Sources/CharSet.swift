//
//  CharSet.swift
//  EntropyString-iOS
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

public struct CharSet {
  public typealias Ndx = UInt8
  public typealias NdxFn = ([UInt8], Int, UInt8) -> Ndx
  
  // Predefined `CharSet`s
  /// RFC 4648 URL and file system safe characters
  public static let charSet64 = try! CharSet("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_")
  
  /// From a..z,A..Z,0..9
  ///  Remove all upper and lower case vowels (including y)
  ///  Remove all numbers that look like letters
  ///  Remove all letters that look like numbers
  ///  Remove all letters that have poor distinction between upper and lower case values
  public static let charSet32 = try! CharSet("2346789bdfghjmnpqrtBDFGHJLMNPQRT")
  
  /// Hexadecimal
  public static let charSet16 = try! CharSet("0123456789abcdef")
  
  /// Octal
  public static let charSet8  = try! CharSet("01234567")
  
  /// DNA alphabet
  public static let charSet4  = try! CharSet("ATCG")
  
  /// Binary
  public static let charSet2  = try! CharSet("01")

  /// String of characters in this `CharSet`
  public private(set) var chars: String

  /// Entropy bits per character in this `CharSet`
  public let bitsPerChar: UInt8

  /// The number of characters in a chunk of bytes. A chunk is the number of bytes needed for an exact multiple
  /// of bits per character.
  internal let charsPerChunk: UInt8
  
  /// Function to index into `CharSet`
  internal let ndxFn: NdxFn

  /// Create  from String of characters
  ///
  /// - parmater chars: The characters to use
  ///
  /// - throws: `.invalidCharCount` if String length not a multiple of 2
  /// - throws: `.charsNotUnique` if any character repeats
  public init(_ chars: String) throws {
    let length = chars.characters.count
    guard [2,4,8,16,32,64].contains(length) else { throw EntropyStringError.invalidCharCount }
    guard CharSet.unique(chars) else { throw EntropyStringError.charsNotUnique }
    
    self.chars = chars
    bitsPerChar = UInt8(log2(Float(length)))
    charsPerChunk = CharSet.lcm(bitsPerChar, Entropy.bitsPerByte) / bitsPerChar
    
    if CharSet.lcm(bitsPerChar, Entropy.bitsPerByte) == Entropy.bitsPerByte {
      ndxFn = CharSet.ndxFnForDivisor(bitsPerChar)
    }
    else {
      ndxFn = CharSet.ndxFnForNonDivisor(bitsPerChar)
    }
  }
  
  /// The bytes needed to form a String of entropy `bits` using this `CharSet`
  ///
  public func bytesNeeded(bits: Float) -> Int {
    let count = ceil(bits / Float(bitsPerChar))
    return Int(ceil(count * Float(bitsPerChar) / Float(Entropy.bitsPerByte)))
  }
  
  /// Determines index into `CharSet` characters when base is a multiple of 8.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// `Bytes` required for a exact multiple of `slice`s. This function returns a function
  /// that indexes into the _chunk_ chunk of `Bytes` to get the _slice_ of bits for
  /// generating a character.
  ///
  /// - parameter bytes: The `Bytes` used for character generation
  /// - parameter chunk: The _chunk_ into the `Bytes`.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The a function to index into the `CharSet` characters.
  private static func ndxFnForDivisor(_ bitsPerChar: UInt8) -> NdxFn {
    func ndxFn(bytes: [UInt8], chunk: Int, slice: UInt8) -> Ndx {
      let lShift = UInt8(bitsPerChar)
      let rShift = Entropy.bitsPerByte - bitsPerChar
      return (bytes[chunk]<<UInt8(slice*lShift))>>rShift
    }
    return ndxFn
  }
  
  /// Determines index into `CharSet` characters when base is not a multiple of 8.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// `Bytes` required for a exact multiple of `slice`s. This function returns a function
  /// that indexes into the _chunk_ chunk of `Bytes` to get the _slice_ of bits for
  /// generating a character.
  ///
  /// - parameter bytes: The `Bytes` used for character generation
  /// - parameter chunk: The _chunk_ into the `Bytes`.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The a function to index into the `CharSet` characters.
  private static func ndxFnForNonDivisor(_ bitsPerChar: UInt8) -> NdxFn {
    func ndxFn(bytes: [UInt8], chunk: Int, slice: UInt8) -> Ndx {
      let bitsPerByte = Entropy.bitsPerByte
      let slicesPerChunk = lcm(bitsPerChar, bitsPerByte) / bitsPerByte
      let bNum = chunk * Int(slicesPerChunk)
      
      let offset = Double(slice*bitsPerChar) / Double(bitsPerByte)
      let lOffset = Int(floor(offset))
      let rOffset = Int(ceil(offset))
      
      let rShift = bitsPerByte - bitsPerChar
      let lShift = (slice*bitsPerChar) % bitsPerByte
      
      var ndx = ((bytes[bNum+lOffset]<<lShift)&0xff)>>rShift

      let rOffsetNext = UInt8(rOffset + 1)
      let sliceNext = slice + 1
      let rShiftIt = (rOffsetNext*bitsPerByte - sliceNext*bitsPerChar) % bitsPerByte
      if (rShift < rShiftIt) {
        ndx += bytes[bNum+rOffset]>>rShiftIt
      }
      return ndx
    }
    return ndxFn
  }
  
  /// Determines if characters in `CharSet` are unique
  ///
  /// - return: `true` if no repeat characters in `CharSet`
  private static func unique(_ string: String) -> Bool {
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
  
  // Least common multiple
  private static func lcm(_ a: UInt8, _ b: UInt8) -> UInt8 {
    func gcd(_ a: UInt8, _ b: UInt8) -> UInt8 {
      let r = a % b
      return r != 0 ? gcd(b, r) : b
    }
    return a / gcd(a,b) * b
  }
  
}
