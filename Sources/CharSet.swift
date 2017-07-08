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
public enum CharSet: UInt {
  // Supported character sets
  case charSet64 = 64
  case charSet32 = 32
  case charSet16 = 16
  case charSet8  =  8
  case charSet4  =  4
  case charSet2  =  2
  
  // Entropy per character for the supported character bases
  public var entropyPerChar: UInt {
    get {
      switch self {
      case .charSet64:
        return 6
      case .charSet32:
        return 5
      case .charSet16:
        return 4
      case .charSet8:
        return 3
      case .charSet4:
        return 2
      case .charSet2:
        return 1
      }
    }
  }
  
  // Characters per chunk of bytes. A slice of bits is used to create a single character. A chunk
  // of bytes is the number of Bytes required for a exact multiple of character slice.
  var charsPerChunk: UInt {
    get {
      switch self {
      case .charSet64:
        return 4
      case .charSet32:
        return 8
      case .charSet16:
        return 2
      case .charSet8:
        return 8
      case .charSet4:
        return 4
      case .charSet2:
        return 8
      }
    }
  }
}
