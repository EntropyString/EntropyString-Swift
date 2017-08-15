//
//  RandomTests.swift
//  EntropyString
//
//  Created by Paul Rogers on 8/14/17.
//  Copyright © 2017 Knoxen. All rights reserved.
//

import XCTest
@testable import EntropyString

class RandomTests: XCTestCase {
  var random: Random!
  var charSets = [.charSet64, .charSet32, .charSet16, .charSet8,  .charSet4,  .charSet2] as [CharSet]

  func testCharSet64() {
    random = Random(charSet: .charSet64)
    entropyString( 6, [0xdd],                                                 "3")
    entropyString(12, [0x78, 0xfc],                                           "eP")
    entropyString(18, [0xc5, 0x6f, 0x21],                                     "xW8")
    entropyString(24, [0xc9, 0x68, 0xc7],                                     "yWjH")
    entropyString(30, [0xa5, 0x62, 0x20, 0x87],                               "pWIgh")
    entropyString(36, [0x39, 0x51, 0xca, 0xcc, 0x8b],                         "OVHKzI")
    entropyString(42, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],                   "g4kAx_Q")
    entropyString(48, [0x51, 0xbc, 0xa8, 0xc7, 0xc9, 0x17],                   "Ubyox8kX")
    entropyString(54, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52],             "0uPp2hmXU")
    entropyString(60, [0xd9, 0x39, 0xc1, 0xaf, 0x1e, 0x2e, 0x69, 0x48],       "2TnBrx4uaU")
    entropyString(66, [0x78, 0x3f, 0xfd, 0x93, 0xd1, 0x06, 0x90, 0x4b, 0xd6], "eD_9k9EGkEv")
    entropyString(72, [0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80], "nZlOpdI_jIaA")
  }

  func testCharSet32() {
    random = Random(charSet: .charSet32)
    entropyString( 5, [0xdd],                                     "N")
    entropyString(10, [0x78, 0xfc],                               "p6")
    entropyString(15, [0x78, 0xfc],                               "p6R")
    entropyString(20, [0xc5, 0x6f, 0x21],                         "JFHt")
    entropyString(25, [0xa5, 0x62, 0x20, 0x87],                   "DFr43")
    entropyString(30, [0xa5, 0x62, 0x20, 0x87],                   "DFr433")
    entropyString(35, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7")
    entropyString(40, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7h")
    entropyString(45, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],       "qn7q3rTD2")
    entropyString(50, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQ")
    entropyString(55, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQf")
  }

  func testCharSet16() {
    random = Random(charSet: .charSet16)
    entropyString( 4, [0x9d],             "9")
    entropyString( 8, [0xae],             "ae")
    entropyString(12, [0x01, 0xf2],       "01f")
    entropyString(16, [0xc7, 0xc9],       "c7c9")
    entropyString(20, [0xc7, 0xc9, 0x00], "c7c90")
  }
  
  func testCharSet8() {
    random = Random(charSet: .charSet8)
    entropyString( 3, [0x5a],                   "2")
    entropyString( 6, [0x5a],                   "26")
    entropyString( 9, [0x21, 0xa4],             "103")
    entropyString(12, [0x21, 0xa4],             "1032")
    entropyString(15, [0xda, 0x19],             "66414")
    entropyString(18, [0xfd, 0x93, 0xd1],       "773117")
    entropyString(21, [0xfd, 0x93, 0xd1],       "7731172")
    entropyString(24, [0xfd, 0x93, 0xd1],       "77311721")
    entropyString(27, [0xc7, 0xc9, 0x07, 0xc9], "617444076")
    entropyString(30, [0xc7, 0xc9, 0x07, 0xc9], "6174440762")
  }
  
  func testCharSet4() {
    random = Random(charSet: .charSet4)
    entropyString( 2, [0x5a],       "T")
    entropyString( 4, [0x5a],       "TT")
    entropyString( 6, [0x93],       "CTA")
    entropyString( 8, [0x93],       "CTAG")
    entropyString(10, [0x20, 0xf1], "ACAAG")
    entropyString(12, [0x20, 0xf1], "ACAAGG")
    entropyString(14, [0x20, 0xf1], "ACAAGGA")
    entropyString(16, [0x20, 0xf1], "ACAAGGAT")
  }
  
  func testCharSet2() {
    random = Random(charSet: .charSet2)
    entropyString( 1, [0x27],       "0")
    entropyString( 2, [0x27],       "00")
    entropyString( 3, [0x27],       "001")
    entropyString( 4, [0x27],       "0010")
    entropyString( 5, [0x27],       "00100")
    entropyString( 6, [0x27],       "001001")
    entropyString( 7, [0x27],       "0010011")
    entropyString( 8, [0x27],       "00100111")
    entropyString( 9, [0xe3, 0xe9], "111000111")
    entropyString(16, [0xe3, 0xe9], "1110001111101001")
  }
  
  func testStringLengths() {
    for charSet in charSets {
      let random = Random(charSet: charSet)
      let iters = 128
      for i in 0 ..< iters {
        let string = random.string(bits: Float(i))
        let count = string.characters.count
        let expected: Int = Int(ceil(Float(i) / Float(charSet.bitsPerChar)))
        XCTAssertEqual(count, expected)
      }
    }
  }
  
  func testCustomChars() {
    var random: Random
    var string: String
    do {
      random = try Random(chars: "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWXYZ9876543210_-")
      string = try random.string(bits: 72, using: [0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80])
      XCTAssertEqual(string, "NzLoPDi-JiAa")
      
      random = try Random(chars: "2346789BDFGHJMNPQRTbdfghjlmnpqrt")
      string = try random.string(bits: 55, using: [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52])
      XCTAssertEqual(string, "mHRrbgQlTqF")

      random = try Random(chars: "0123456789ABCDEF")
      string = try random.string(bits: 20, using: [0xc7, 0xc9, 0x00])
      XCTAssertEqual(string, "C7C90")
      
      random = try Random(chars: "abcdefgh")
      string = try random.string(bits: 30, using: [0xc7, 0xc9, 0x07, 0xc9])
      XCTAssertEqual(string, "gbheeeahgc")

      random = try Random(chars: "atcg")
      string = try random.string(bits: 16, using: [0x20, 0xf1])
      XCTAssertEqual(string, "acaaggat")

      random = try Random(chars: "HT")
      string = try random.string(bits: 16, using: [0xe3, 0xe9])
      XCTAssertEqual(string, "TTTHHHTTTTTHTHHT")
    }
    catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func testInvalidCharCount() {
    invalidCharCount("")
    invalidCharCount("1")
    invalidCharCount("123")
    invalidCharCount("1234567")
    invalidCharCount("123456789")
    invalidCharCount("1234567890abcde")
    invalidCharCount("1234567890abcdefg")
    invalidCharCount("1234567890abcdefghijklmnopqrstu")
    invalidCharCount("1234567890abcdefghijklmnopqrstuvw")
    invalidCharCount("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-")
    invalidCharCount("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_&")
  }
  
  func testNonUniqueChars() {
    nonUniqueChars("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ab")
    nonUniqueChars("01234567890123456789012345678901")
    nonUniqueChars("0123456789abcd3f")
    nonUniqueChars("01233456")
    nonUniqueChars("0120")
    nonUniqueChars("TT")
  }
  
  func testInvalidBytes() {
    invalidBytes( 7, .charSet64, [1])
    invalidBytes(13, .charSet64, [1,2])
    invalidBytes(25, .charSet64, [1,2,3])
    invalidBytes(31, .charSet64, [1,2,3,4])
    
    invalidBytes( 6, .charSet32, [1])
    invalidBytes(16, .charSet32, [1,2])
    invalidBytes(21, .charSet32, [1,2,3])
    invalidBytes(31, .charSet32, [1,2,3,4])
    invalidBytes(41, .charSet32, [1,2,3,4,5])
    invalidBytes(46, .charSet32, [1,2,3,4,5,6])
    
    invalidBytes( 9, .charSet16, [1])
    invalidBytes(17, .charSet16, [1,2])
    
    invalidBytes( 7, .charSet8,  [1])
    invalidBytes(16, .charSet8,  [1,2])
    invalidBytes(25, .charSet8,  [1,2,3])
    invalidBytes(31, .charSet8,  [1,2,3,4])
    
    invalidBytes( 9, .charSet4,  [1])
    invalidBytes(17, .charSet4,  [1,2])
    
    invalidBytes( 9, .charSet2,  [1])
    invalidBytes(17, .charSet2,  [1,2])
  }
  
  func testNegativeEntropy() {
    do {
      let random = Random(charSet: .charSet32)
      let _ = try random.string(bits: -6, using: [0x33])
    }
    catch {
      if let error = error as? EntropyStringError {
        XCTAssertEqual(error, EntropyStringError.negativeEntropy)
      }
      else {
        XCTFail("Error not a EntropyStringError")
      }
    }
  
  }

  #if !os(Linux)
  func testSecRand() {
    for charSet in charSets {
      let random = Random(charSet: charSet)
      var secRand = false
      _ = random.string(bits: 36, secRand: &secRand)
      XCTAssertFalse(secRand)
      
      secRand = true
      _ = random.string(bits: 36, secRand: &secRand)
      XCTAssertTrue(secRand)
    }
  }
  #endif

  func entropyString(_ bits: Float, _ bytes: [UInt8], _ expected: String) {
    do {
      let string = try random.string(bits: bits, using: bytes)
      XCTAssertEqual(string, expected)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
  }

  func entropyString(_ bits: Float, _ charSet: CharSet, _ bytes: [UInt8], _ expected: String) {
    do {
      let random = Random(charSet: charSet)
      let string = try random.string(bits: bits, using: bytes)
      XCTAssertEqual(string, expected)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
  }

  func nonUniqueChars(_ chars: String) {
    do {
      let _ = try Random(chars: chars)
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

  func invalidCharCount(_ chars: String) {
    do {
      let _ = try Random(chars: chars)
      XCTFail("Should have thrown")
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
  
  func invalidBytes(_ bits: Float, _ charSet: CharSet, _ bytes: [UInt8]) {
    do {
      let random = Random(charSet: charSet)
      _ = try random.string(bits: bits, using: bytes)
      XCTFail("Should have thrown")
    }
    catch {
      if let error = error as? EntropyStringError {
        XCTAssertEqual(error, EntropyStringError.tooFewBytes)
      }
      else {
        XCTFail("Error not a EntropyStringError")
      }
    }
  }

}
