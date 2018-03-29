//
//  CharSetTests.swift
//  EntropyString
//
//  Created by Paul Rogers on 8/15/17.
//  Copyright © 2017-2018 Knoxen. All rights reserved.
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
      let charset = try CharSet(chars)
      XCTAssertEqual(chars, charset.chars)
      XCTAssertEqual(charset.bitsPerChar, bitsPerChunk)
      XCTAssertEqual(charset.charsPerChunk, charsPerChunk)
      XCTAssertNotNil(charset.ndxFn)
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
  
  func testBytesNeeded() {
    let doTest: (CharSet, Float) -> () = { (charset: CharSet, bits: Float) -> () in
      let bytesNeeded = charset.bytesNeeded(bits: bits)
      let atLeast = Int(ceil(bits / Float(Entropy.bitsPerByte)))
      XCTAssertTrue(atLeast <= bytesNeeded)
      let atMost = atLeast + 1
      XCTAssertTrue(bytesNeeded <= atMost)
    }

    let charsets = [.charset64, .charset32, .charset16, .charset8,  .charset4,  .charset2] as [CharSet]
    for charset in charsets {
      for bits in 0 ... 10 {
        doTest(charset, Float(bits))
      }
      for bits in stride(from: 12, through: 132, by: 5) {
        doTest(charset, Float(bits))
      }
    }
  }
  
  func testStatics() {
    XCTAssertNotNil(CharSet.charset64)
    XCTAssertNotNil(CharSet.charset32)
    XCTAssertNotNil(CharSet.charset16)
    XCTAssertNotNil(CharSet.charset8)
    XCTAssertNotNil(CharSet.charset4)
    XCTAssertNotNil(CharSet.charset2)
  }
}

extension CharSetTests {
// Adopt XCTestCaseProvider to run test on  Linux
  static var tests: [(String, (CharSetTests) -> () throws -> ())] {
    return [
      ("testInitChars",      testInitChars),
      ("testNonUniqueChars", testNonUniqueChars),
      ("testInvalidChars",   testInvalidChars),
      ("testStatics",        testStatics)
    ]
  }
}
