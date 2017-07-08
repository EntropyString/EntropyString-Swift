//
//  EntropyStringTests.swift
//  EntropyStringTests
//
//  Created by Paul Rogers on 7/6/17.
//  Copyright © 2017 Knoxen. All rights reserved.
//

import XCTest
@testable import EntropyString

class EntropyStringTests: XCTestCase {
  var randomString: RandomString!
  var charSets: [CharSet]!
  var powers: [Entropy.Power]!
  
  override func setUp() {
    super.setUp()
    
    randomString = RandomString()
    charSets = [.charSet64, .charSet32, .charSet16, .charSet8, .charSet4, .charSet2] as [CharSet]
    powers = [.ten01, .ten02, .ten03, .ten04, .ten05, .ten06, .ten07, .ten08, .ten09, .ten10,
              .ten11, .ten12, .ten13, .ten14, .ten15, .ten16, .ten17, .ten18, .ten19, .ten10,
              .ten21, .ten22, .ten23, .ten24, .ten25, .ten26, .ten27, .ten28, .ten29, .ten30] as [Entropy.Power]
  }
  
  func testCharSetLengths() {
    for charSet in charSets {
      var count = RandomString.characters(for: charSet).characters.count
      XCTAssertEqual(count, String.CharacterView.IndexDistance(charSet.rawValue))

      count = randomString.characters(for: charSet).characters.count
      XCTAssertEqual(count, String.CharacterView.IndexDistance(charSet.rawValue))
    }
  }
  
  func testEntropyLengths() {
    for charSet in charSets {
      let iters = 32
      for i in 0 ..< Int(iters) {
        var string = RandomString.entropy(of: Float(i), using: charSet)
        var count = string.characters.count
        let expected: Int = Int(ceil(Float(i) / Float(charSet.entropyPerChar)))
        XCTAssertEqual(count, expected)

        string = randomString.entropy(of: Float(i), using: charSet)
        count = string.characters.count
        XCTAssertEqual(count, expected)
      }
    }
  }
  
  func testCustom64Chars() {
    do {
      try randomString.use("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz)!@#$%^&*(+=", for: .charSet64)
      try randomString.use("1234567890-=[];,./~!@#$%^&*()_+{}|:<>?abcdefghijklmnopqrstuvwxyz", for: .charSet64)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.charSet64, "")
    invalidCharCount(.charSet64, String(repeating: "x", count: 65))
    
    notUniqueChars(.charSet64, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ab")
    
    forceNotUnique(.charSet64, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ab")
  }
  
  func testCustom32Chars() {
    do {
      try randomString.use("0123456789)!@#$%^&*(+=[]{}\\|_-/?", for: .charSet32)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.charSet32, "0123456789ABCDEF")
    invalidCharCount(.charSet32, String(repeating: "x", count: 33))
    
    notUniqueChars(.charSet32, "01234567890123456789012345678901")
    
    forceNotUnique(.charSet32, "01234567890123456789012345678901")
  }
  
  func testCustom16Chars() {
    let lowerString = randomString.entropy(of: 32, using: .charSet16)
    assert(lowerString == lowerString.lowercased())
    assert(lowerString != lowerString.uppercased())
    
    do {
      try randomString.use("0123456789ABCDEF", for: .charSet16)
      let upperString = randomString.entropy(of: 32, using: .charSet16)
      XCTAssertNotEqual(upperString, upperString.lowercased())
      XCTAssertEqual(upperString, upperString.uppercased())
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.charSet16, "0123456789abcde")
    invalidCharCount(.charSet16, "0123456789abcdefg")
    
    notUniqueChars(.charSet16, "0123456789abcdee")
    
    forceNotUnique(.charSet16, "0123456789abcdee")
  }
  
  func testCustom8Chars() {
    do {
      for _ in 0..<50 {
        try randomString.use("abcdefgh", for: .charSet8)
        let string = randomString.entropy(of: 3, using: .charSet8)
        XCTAssertTrue(string == "a" || string == "b" || string == "c" || string == "d"
          || string == "e" || string == "f" || string == "g" || string == "h")
      }
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.charSet8, "0123456")
    invalidCharCount(.charSet8, "012345678")
    
    notUniqueChars(.charSet8, "01233456")
    
    forceNotUnique(.charSet8,  "01233456")
  }
  
  func testCustom4Chars() {
    do {
      for _ in 0..<20 {
        try randomString.use("0123", for: .charSet4)
        let string = randomString.entropy(of: 2, using: .charSet4)
        XCTAssertTrue(string == "0" || string == "1" || string == "2" || string == "3")
      }
    }
    catch {
      XCTFail(error.localizedDescription)
    }

    invalidCharCount(.charSet4,  "TF")
    invalidCharCount(.charSet4,  "AEIOU")

    notUniqueChars(.charSet4,  "0120")
    
    forceNotUnique(.charSet4,  "0120")
  }
  
  func testCustom2Chars() {
    do {
      for _ in 0..<10 {
        try randomString.use("HT", for: .charSet2)
        let string = randomString.entropy(of: 1, using: .charSet2)
        XCTAssertTrue(string == "H" || string == "T")
      }
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.charSet2,  "F")
    invalidCharCount(.charSet2,  "TFH")
    
    notUniqueChars(.charSet2,  "aa")
    
    forceNotUnique(.charSet2,  "aa")
  }
  
  func invalidCharCount(_ charSet: CharSet, _ chars: String) {
    do {
      try randomString.use(chars, for: charSet)
      XCTFail("Should have thrown")
    }
    catch {
      if let error = error as? RandomString.RandomStringError {
        XCTAssertEqual(error, RandomString.RandomStringError.invalidCharCount)
      }
      else {
        XCTFail("Error not a RandomStringError")
      }
    }
  }
  
  func notUniqueChars(_ charSet: CharSet, _ chars: String) {
    do {
      try randomString.use(chars, for: charSet)
      XCTFail("Should have thrown")
    }
    catch {
      if let error = error as? RandomString.RandomStringError {
        XCTAssertEqual(error, RandomString.RandomStringError.charsNotUnique)
      }
      else {
        XCTFail("Error not a RandomStringError")
      }
    }
  }
  
  func forceNotUnique(_ charSet: CharSet, _ chars: String) {
    do {
      try randomString.use(chars, for: charSet, force: true)
    }
    catch {
      XCTFail("Should not throw")
    }
  }
  
  func testZeroEntropy() {
    for charSet in charSets {
      XCTAssertEqual(RandomString.entropy(of: 0, using: charSet), "")
    }
  }
  
  func testBase64Entropy() {
    entropy(.charSet64,   5,  1)
    entropy(.charSet64,   6,  1)
    entropy(.charSet64,   7,  2)
    entropy(.charSet64,  18,  3)
    entropy(.charSet64,  50,  9)
    entropy(.charSet64, 122, 21)
    entropy(.charSet64, 128, 22)
    entropy(.charSet64, 132, 22)
  }
  
  func testBase32Entropy() {
    entropy(.charSet32,   4,  1)
    entropy(.charSet32,   5,  1)
    entropy(.charSet32,   6,  2)
    entropy(.charSet32,  20,  4)
    entropy(.charSet32,  32,  7)
    entropy(.charSet32, 122, 25)
    entropy(.charSet32, 128, 26)
    entropy(.charSet32, 130, 26)
  }
  
  func testBase16Entropy() {
    entropy(.charSet16,   3,  1)
    entropy(.charSet16,   4,  1)
    entropy(.charSet16,   5,  2)
    entropy(.charSet16,  14,  4)
    entropy(.charSet16,  40, 10)
    entropy(.charSet16, 122, 31)
    entropy(.charSet16, 128, 32)
  }
  
  func testBase8Entropy() {
    entropy(.charSet8,   2,  1)
    entropy(.charSet8,   3,  1)
    entropy(.charSet8,   4,  2)
    entropy(.charSet8,  32, 11)
    entropy(.charSet8,  48, 16)
    entropy(.charSet8, 120, 40)
    entropy(.charSet8, 122, 41)
    entropy(.charSet8, 128, 43)
  }
  
  func testBase4Entropy() {
    entropy(.charSet4,   1,  1)
    entropy(.charSet4,   2,  1)
    entropy(.charSet4,   3,  2)
    entropy(.charSet4,  32, 16)
    entropy(.charSet4,  48, 24)
    entropy(.charSet4, 122, 61)
    entropy(.charSet4, 128, 64)
  }
  
  func testBase2Entropy() {
    entropy(.charSet2,   1,   1)
    entropy(.charSet2,   2,   2)
    entropy(.charSet2,   3,   3)
    entropy(.charSet2,  32,  32)
    entropy(.charSet2,  48,  48)
    entropy(.charSet2, 122, 122)
    entropy(.charSet2, 128, 128)
  }
  
  func entropy(_ charSet: CharSet, _ bits: Float, _ expected: Int) {
    var string = RandomString.entropy(of: bits, using: charSet)
    XCTAssertEqual(string.characters.count, expected)
  }
  
  func testTotalEntropy() {
    for risk in powers {
      _ = Entropy.bits(for: 10000, risk: risk)
    }
    
    entropyBits(    30,   .ten06,   29)
    entropyBits(100000,   .ten12,   73)
    entropyBits(UInt.max, .ten15,  177)

    stringLength(30, .ten06, .charSet64,  5)
    stringLength(30, .ten06, .charSet32,  6)
    stringLength(30, .ten06, .charSet16,  8)
    stringLength(30, .ten06, .charSet8,  10)
    stringLength(30, .ten06, .charSet4,  15)
    stringLength(30, .ten06, .charSet2,  29)

    stringLength(100000, .ten12, .charSet64,  13)
    stringLength(100000, .ten12, .charSet32,  15)
    stringLength(100000, .ten12, .charSet16,  19)
    stringLength(100000, .ten12, .charSet8,   25)
    stringLength(100000, .ten12, .charSet4,   37)
    stringLength(100000, .ten12, .charSet2,   73)

    stringLength(UInt.max, .ten15, .charSet64,  30)
    stringLength(UInt.max, .ten15, .charSet32,  36)
    stringLength(UInt.max, .ten15, .charSet16,  45)
    stringLength(UInt.max, .ten15, .charSet8,   59)
    stringLength(UInt.max, .ten15, .charSet4,   89)
    stringLength(UInt.max, .ten15, .charSet2,  177)
  }
  
  func entropyBits(_ total: UInt, _ risk: Entropy.Power, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    XCTAssertEqual(UInt(ceil(bits)), expected)
  }

  func stringLength(_ total: UInt, _ risk: Entropy.Power, _ charSet: CharSet, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    let len = UInt(ceil(bits / Float(charSet.entropyPerChar)))
    XCTAssertEqual(len,  expected)
  }
  
  func testPowerEntropy() {
    for total in powers {
      for risk in powers {
        _ = Entropy.bits(for: total, risk: risk)
      }
    }
    
    stringLength(.ten05, .ten12, .charSet64, 13)
    stringLength(.ten05, .ten12, .charSet32, 15)
    stringLength(.ten05, .ten12, .charSet16, 19)
    stringLength(.ten05, .ten12, .charSet8,  25)
    stringLength(.ten05, .ten12, .charSet4,  37)
    stringLength(.ten05, .ten12, .charSet2,  73)
    
    stringLength(.ten10, .ten09, .charSet64, 16)
    stringLength(.ten10, .ten09, .charSet32, 20)
    stringLength(.ten10, .ten09, .charSet16, 24)
    stringLength(.ten10, .ten09, .charSet8,  32)
    stringLength(.ten10, .ten09, .charSet4,  48)
    stringLength(.ten10, .ten09, .charSet2,  96)
  }
  
  func stringLength(_ power: Entropy.Power, _ risk: Entropy.Power, _ charSet: CharSet, _ expected: UInt) {
    let bits = Entropy.bits(for: power, risk: risk)
    let len = UInt(ceil(bits / Float(charSet.entropyPerChar)))
    XCTAssertEqual(len,  expected)
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
  
  func invalidBytes(_ bits: Float, _ charSet: CharSet, _ bytes: RandomString.Bytes) {
    do {
      _ = try randomString.entropy(of: bits, using: charSet, bytes: bytes)
      XCTFail("Should have thrown")
    }
    catch {
      if let error = error as? RandomString.RandomStringError {
        XCTAssertEqual(error, RandomString.RandomStringError.tooFewBytes)
      }
      else {
        XCTFail("Error not a RandomStringError")
      }
    }
  }

  func testBase64() {
    entropy( 6, .charSet64, [0xdd],                                                 "3")
    entropy(12, .charSet64, [0x78, 0xfc],                                           "eP")
    entropy(18, .charSet64, [0xc5, 0x6f, 0x21],                                     "xW8")
    entropy(24, .charSet64, [0xc9, 0x68, 0xc7],                                     "yWjH")
    entropy(30, .charSet64, [0xa5, 0x62, 0x20, 0x87],                               "pWIgh")
    entropy(36, .charSet64, [0x39, 0x51, 0xca, 0xcc, 0x8b],                         "OVHKzI")
    entropy(42, .charSet64, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],                   "g4kAx_Q")
    entropy(48, .charSet64, [0x51, 0xbc, 0xa8, 0xc7, 0xc9, 0x17],                   "Ubyox8kX")
    entropy(54, .charSet64, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52],             "0uPp2hmXU")
    entropy(60, .charSet64, [0xd9, 0x39, 0xc1, 0xaf, 0x1e, 0x2e, 0x69, 0x48],       "2TnBrx4uaU")
    entropy(66, .charSet64, [0x78, 0x3f, 0xfd, 0x93, 0xd1, 0x06, 0x90, 0x4b, 0xd6], "eD_9k9EGkEv")
    entropy(72, .charSet64, [0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80], "nZlOpdI_jIaA")
  }
  
  func testBase32() {
    entropy( 5, .charSet32, [0xdd],                                     "N")
    entropy(10, .charSet32, [0x78, 0xfc],                               "p6")
    entropy(15, .charSet32, [0x78, 0xfc],                               "p6R")
    entropy(20, .charSet32, [0xc5, 0x6f, 0x21],                         "JFHt")
    entropy(25, .charSet32, [0xa5, 0x62, 0x20, 0x87],                   "DFr43")
    entropy(30, .charSet32, [0xa5, 0x62, 0x20, 0x87],                   "DFr433")
    entropy(35, .charSet32, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7")
    entropy(40, .charSet32, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7h")
    entropy(45, .charSet32, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],       "qn7q3rTD2")
    entropy(50, .charSet32, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQ")
    entropy(55, .charSet32, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQf")
  }
  
  func testBase16() {
    entropy( 4, .charSet16, [0x9d],             "9")
    entropy( 8, .charSet16, [0xae],             "ae")
    entropy(12, .charSet16, [0x01, 0xf2],       "01f")
    entropy(16, .charSet16, [0xc7, 0xc9],       "c7c9")
    entropy(20, .charSet16, [0xc7, 0xc9, 0x00], "c7c90")
  }
  
  func testBase8() {
    entropy( 3, .charSet8, [0x5a],                   "2")
    entropy( 6, .charSet8, [0x5a],                   "26")
    entropy( 9, .charSet8, [0x21, 0xa4],             "103")
    entropy(12, .charSet8, [0x21, 0xa4],             "1032")
    entropy(15, .charSet8, [0xda, 0x19],             "66414")
    entropy(18, .charSet8, [0xfd, 0x93, 0xd1],       "773117")
    entropy(21, .charSet8, [0xfd, 0x93, 0xd1],       "7731172")
    entropy(24, .charSet8, [0xfd, 0x93, 0xd1],       "77311721")
    entropy(27, .charSet8, [0xc7, 0xc9, 0x07, 0xc9], "617444076")
    entropy(30, .charSet8, [0xc7, 0xc9, 0x07, 0xc9], "6174440762")
  }
  
  func testBase4() {
    entropy( 2, .charSet4, [0x5a],       "T")
    entropy( 4, .charSet4, [0x5a],       "TT")
    entropy( 6, .charSet4, [0x93],       "CTA")
    entropy( 8, .charSet4, [0x93],       "CTAG")
    entropy(10, .charSet4, [0x20, 0xf1], "ACAAG")
    entropy(12, .charSet4, [0x20, 0xf1], "ACAAGG")
    entropy(14, .charSet4, [0x20, 0xf1], "ACAAGGA")
    entropy(16, .charSet4, [0x20, 0xf1], "ACAAGGAT")
  }
  
  func testBase2() {
    entropy( 1, .charSet2, [0x27],       "0")
    entropy( 2, .charSet2, [0x27],       "00")
    entropy( 3, .charSet2, [0x27],       "001")
    entropy( 4, .charSet2, [0x27],       "0010")
    entropy( 5, .charSet2, [0x27],       "00100")
    entropy( 6, .charSet2, [0x27],       "001001")
    entropy( 7, .charSet2, [0x27],       "0010011")
    entropy( 8, .charSet2, [0x27],       "00100111")
    entropy( 9, .charSet2, [0xe3, 0xe9], "111000111")
    entropy(16, .charSet2, [0xe3, 0xe9], "1110001111101001")
  }

  func entropy(_ bits: Float, _ charSet: CharSet, _ bytes: [UInt8], _ expected: String) {
    do {
      var string = try RandomString.entropy(of: bits, using: charSet, bytes: bytes)
      XCTAssertEqual(string, expected)
      string = try randomString.entropy(of: bits, using: charSet, bytes: bytes)
      XCTAssertEqual(string, expected)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func testSecure() {
    for charSet in charSets {
      var secure = false
      _ = RandomString.entropy(of: 36, using: charSet, secure: &secure)
      XCTAssertFalse(secure)
      
      secure = true
      _ = RandomString.entropy(of: 36, using: .charSet64, secure: &secure)
    }
  }
  
  // Adopt XCTestCaseProvider to run test on  Linux
  var allTests: [(String, () throws -> ())] {
    return [
      ("testCharSetLengths",  testCharSetLengths),
      ("testEntropyLengths",   testEntropyLengths),
      ("testCustom64Chars",    testCustom64Chars),
      ("testCustom32Chars",    testCustom32Chars),
      ("testCustom16Chars",    testCustom16Chars),
      ("testCustom8Chars",     testCustom8Chars),
      ("testCustom4Chars",     testCustom4Chars),
      ("testCustom2Chars",     testCustom2Chars),
      ("testInvalidBytes",     testInvalidBytes),
      ("testBase64",           testBase64),
      ("testBase32",           testBase32),
      ("testBase16",           testBase16),
      ("testBase8",            testBase8),
      ("testBase4",            testBase4),
      ("testBase2",            testBase2),
      ("testZeroEntropy",      testZeroEntropy),
      ("testBase64Entropy",    testBase64Entropy),
      ("testBase32Entropy",    testBase32Entropy),
      ("testBase16Entropy",    testBase16Entropy),
      ("testBase8Entropy",     testBase8Entropy),
      ("testBase4Entropy",     testBase4Entropy),
      ("testBase2Entropy",     testBase2Entropy),
      ("testSecure",           testSecure)
    ]
  }
}

// MARK: - Protocols
// Polyfill XCTestCaseProvider for Apple OSes
#if os(OSX) || os(iOS) || os(tvOS) || os(watchOS)
  public protocol XCTestCaseProvider {
    var allTests: [(String, () throws -> ())] { get }
  }
#endif
