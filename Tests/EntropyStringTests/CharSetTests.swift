//
//  CharSetTests.swift
//  EntropyString
//
//  Created by Paul Rogers on 8/15/17.
//  Copyright © 2017 Knoxen. All rights reserved.
//

import XCTest
@testable import EntropyString

class CharSetTests: XCTestCase {

  func testInitChars() {
    initChars(chars: "&abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9876543210@", bitsPerChunk: 6, charsPerChunk: 4)
    initChars(chars: "0123456789zyxwvutsrqponmlkjihgfe", bitsPerChunk: 5, charsPerChunk: 8)
    initChars(chars: "0123456789zyxwvu", bitsPerChunk: 4, charsPerChunk: 2)
    initChars(chars: "zyxwvuts", bitsPerChunk: 3, charsPerChunk: 8)
    initChars(chars: "zyxw", bitsPerChunk: 2, charsPerChunk: 4)
    initChars(chars: "zy", bitsPerChunk: 1, charsPerChunk: 8)
  }
  
  func initChars(chars: String, bitsPerChunk: UInt8, charsPerChunk: UInt8) {
    do {
      let charSet = try CharSet(chars)
      XCTAssertEqual(chars, charSet.chars)
      XCTAssertEqual(charSet.bitsPerChar, bitsPerChunk)
      XCTAssertEqual(charSet.charsPerChunk, charsPerChunk)
      XCTAssertNotNil(charSet.ndxFn)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func testNonUniqueChars() {
    nonUniqueChars("@ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789@")
    nonUniqueChars("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdeK")
    nonUniqueChars("ABCDEFGHIJKLMNOC")
    nonUniqueChars("ABCDEFGC")
    nonUniqueChars("ABCC")
    nonUniqueChars("AA")
  }
  
  func nonUniqueChars(_ chars: String) {
    do {
      let _ = try CharSet(chars)
      XCTFail("Should have thrown")
    }
    catch {
      if let error = error as? EntropyStringError {
        XCTAssertEqual(error, EntropyStringError.charsNotUnique)
      }
      else {
        XCTFail("Error not a EntropyStringError")
      }
    }
  }

  func testInvalidChars() {
    invalidChars("")
    invalidChars("a")
    invalidChars("abc")
    invalidChars("abcde")
    invalidChars("abcdefg")
    invalidChars("abcdefghi")
    invalidChars("abcdefghijklmno")
    invalidChars("abcdefghijklmnopq")
    invalidChars("abcdefghijklmnopqrstuvwxyzABCDE")
    invalidChars("abcdefghijklmnopqrstuvwxyzABCDEFH")
    invalidChars("abcdefghijklmnopqrstuvwxyzABCDEFHIJKLMNOPQRSTUVWXYZ0987654321(")
    invalidChars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321-")
    invalidChars("abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ0987654321-_^")
  }

  func invalidChars(_ chars: String) {
    do {
      let _ = try CharSet(chars)
      XCTFail("Should have thrown: \(chars)")
    }
    catch {
      if let error = error as? EntropyStringError {
        XCTAssertEqual(error, EntropyStringError.invalidCharCount)
      }
      else {
        XCTFail("Error not a EntropyStringError")
      }
    }
  }

  func testStatics() {
    XCTAssertNotNil(CharSet.charSet64)
    XCTAssertNotNil(CharSet.charSet32)
    XCTAssertNotNil(CharSet.charSet16)
    XCTAssertNotNil(CharSet.charSet8)
    XCTAssertNotNil(CharSet.charSet4)
    XCTAssertNotNil(CharSet.charSet2)
  }
}
