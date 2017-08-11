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
  
  // Entropy bits per character
  public var bitsPerChar: Int {
    return Int(log2(Float(rawValue)))
  }
  
  // Characters per chunk of bytes. A slice of bits is used to create a single character. A chunk
  // of bytes is the number of Bytes required for a exact multiple of character slice.
  var charsPerChunk: Int {
    let bitsPerByte: Int = 8
    return CharSet.lcm(bitsPerChar, bitsPerByte) / bitsPerChar
  }
  
  

  /// Determines index into `charSet16` characters.
  ///
  /// Each `slice` of bits is used to create a single character. A `chunk` is the number of
  /// __Bytes__ required for a exact multiple of `slice`s. This function indexes into the _chunk_
  /// of __Bytes__ to get the _slice_ of bits for generating a character.
  ///
  /// - parameter bytes: The __Bytes__ used for character generation
  /// - parameter chunk: The _chunk_ into the __Bytes__.
  /// - parameter slice: The _slice_ of the _chunk_.
  ///
  /// - return: The index into the `charSet16` characters.
  private func ndxFn(bitsPerChar: Int ) -> NdxFn? {
    
    return nil
  }
  
  // Least common multiple
  static func lcm(_ a: Int, _ b: Int) -> Int {
    func gcd(_ a: Int, _ b: Int) -> Int {
      let r = a % b
      return r != 0 ? gcd(b, r) : b
    }
    return a / gcd(a,b) * b
  }
  
  
}
