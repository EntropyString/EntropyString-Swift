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
  var bases: [RandomString.CharBase]!
  var powers: [Entropy.Power]!
  
  override func setUp() {
    super.setUp()
    
    randomString = RandomString()
    bases = [.base64, .base32, .base16, .base8, .base4, .base2] as [RandomString.CharBase]
    powers = [.ten01, .ten02, .ten03, .ten04, .ten05, .ten06, .ten07, .ten08, .ten09, .ten10,
              .ten11, .ten12, .ten13, .ten14, .ten15, .ten16, .ten17, .ten18, .ten19, .ten10,
              .ten21, .ten22, .ten23, .ten24, .ten25, .ten26, .ten27, .ten28, .ten29, .ten30] as [Entropy.Power]
  }
  
  func testCharBaseLengths() {
    for base in bases {
      var count = RandomString.characters(for: base).characters.count
      XCTAssertEqual(count, String.CharacterView.IndexDistance(base.rawValue))

      count = randomString.characters(for: base).characters.count
      XCTAssertEqual(count, String.CharacterView.IndexDistance(base.rawValue))
    }
  }
  
  func testEntropyLengths() {
    for base in bases {
      let iters = 32
      for i in 0 ..< Int(iters) {
        var string = RandomString.entropy(of: Float(i), using: base)
        var count = string.characters.count
        let expected: Int = Int(ceil(Float(i) / Float(base.entropyPerChar)))
        XCTAssertEqual(count, expected)

        string = randomString.entropy(of: Float(i), using: base)
        count = string.characters.count
        XCTAssertEqual(count, expected)
      }
    }
  }
  
  func testCustom64Chars() {
    do {
      try randomString.use("ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz)!@#$%^&*(+=", for: .base64)
      try randomString.use("1234567890-=[];,./~!@#$%^&*()_+{}|:<>?abcdefghijklmnopqrstuvwxyz", for: .base64)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.base64, "")
    invalidCharCount(.base64, String(repeating: "x", count: 65))
    
    notUniqueChars(.base64, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ab")
    
    forceNotUnique(.base64, "ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789ab")
  }
  
  func testCustom32Chars() {
    do {
      try randomString.use("0123456789)!@#$%^&*(+=[]{}\\|_-/?", for: .base32)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.base32, "0123456789ABCDEF")
    invalidCharCount(.base32, String(repeating: "x", count: 33))
    
    notUniqueChars(.base32, "01234567890123456789012345678901")
    
    forceNotUnique(.base32, "01234567890123456789012345678901")
  }
  
  func testCustom16Chars() {
    let lowerString = randomString.entropy(of: 32, using: .base16)
    assert(lowerString == lowerString.lowercased())
    assert(lowerString != lowerString.uppercased())
    
    do {
      try randomString.use("0123456789ABCDEF", for: .base16)
      let upperString = randomString.entropy(of: 32, using: .base16)
      XCTAssertNotEqual(upperString, upperString.lowercased())
      XCTAssertEqual(upperString, upperString.uppercased())
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.base16, "0123456789abcde")
    invalidCharCount(.base16, "0123456789abcdefg")
    
    notUniqueChars(.base16, "0123456789abcdee")
    
    forceNotUnique(.base16, "0123456789abcdee")
  }
  
  func testCustom8Chars() {
    do {
      for _ in 0..<50 {
        try randomString.use("abcdefgh", for: .base8)
        let string = randomString.entropy(of: 3, using: .base8)
        XCTAssertTrue(string == "a" || string == "b" || string == "c" || string == "d"
          || string == "e" || string == "f" || string == "g" || string == "h")
      }
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.base8, "0123456")
    invalidCharCount(.base8, "012345678")
    
    notUniqueChars(.base8, "01233456")
    
    forceNotUnique(.base8,  "01233456")
  }
  
  func testCustom4Chars() {
    do {
      for _ in 0..<20 {
        try randomString.use("0123", for: .base4)
        let string = randomString.entropy(of: 2, using: .base4)
        XCTAssertTrue(string == "0" || string == "1" || string == "2" || string == "3")
      }
    }
    catch {
      XCTFail(error.localizedDescription)
    }

    invalidCharCount(.base4,  "TF")
    invalidCharCount(.base4,  "AEIOU")

    notUniqueChars(.base4,  "0120")
    
    forceNotUnique(.base4,  "0120")
  }
  
  func testCustom2Chars() {
    do {
      for _ in 0..<10 {
        try randomString.use("HT", for: .base2)
        let string = randomString.entropy(of: 1, using: .base2)
        XCTAssertTrue(string == "H" || string == "T")
      }
    }
    catch {
      XCTFail(error.localizedDescription)
    }
    
    invalidCharCount(.base2,  "F")
    invalidCharCount(.base2,  "TFH")
    
    notUniqueChars(.base2,  "aa")
    
    forceNotUnique(.base2,  "aa")
  }
  
  func invalidCharCount(_ base: RandomString.CharBase, _ chars: String) {
    do {
      try randomString.use(chars, for: base)
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
  
  func notUniqueChars(_ base: RandomString.CharBase, _ chars: String) {
    do {
      try randomString.use(chars, for: base)
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
  
  func forceNotUnique(_ base: RandomString.CharBase, _ chars: String) {
    do {
      try randomString.use(chars, for: base, force: true)
    }
    catch {
      XCTFail("Should not throw")
    }
  }
  
  func testZeroEntropy() {
    for base in bases {
      XCTAssertEqual(RandomString.entropy(of: 0, using: base), "")
    }
  }
  
  func testBase64Entropy() {
    entropy(.base64,   5,  1)
    entropy(.base64,   6,  1)
    entropy(.base64,   7,  2)
    entropy(.base64,  18,  3)
    entropy(.base64,  50,  9)
    entropy(.base64, 122, 21)
    entropy(.base64, 128, 22)
    entropy(.base64, 132, 22)
  }
  
  func testBase32Entropy() {
    entropy(.base32,   4,  1)
    entropy(.base32,   5,  1)
    entropy(.base32,   6,  2)
    entropy(.base32,  20,  4)
    entropy(.base32,  32,  7)
    entropy(.base32, 122, 25)
    entropy(.base32, 128, 26)
    entropy(.base32, 130, 26)
  }
  
  func testBase16Entropy() {
    entropy(.base16,   3,  1)
    entropy(.base16,   4,  1)
    entropy(.base16,   5,  2)
    entropy(.base16,  14,  4)
    entropy(.base16,  40, 10)
    entropy(.base16, 122, 31)
    entropy(.base16, 128, 32)
  }
  
  func testBase8Entropy() {
    entropy(.base8,   2,  1)
    entropy(.base8,   3,  1)
    entropy(.base8,   4,  2)
    entropy(.base8,  32, 11)
    entropy(.base8,  48, 16)
    entropy(.base8, 120, 40)
    entropy(.base8, 122, 41)
    entropy(.base8, 128, 43)
  }
  
  func testBase4Entropy() {
    entropy(.base4,   1,  1)
    entropy(.base4,   2,  1)
    entropy(.base4,   3,  2)
    entropy(.base4,  32, 16)
    entropy(.base4,  48, 24)
    entropy(.base4, 122, 61)
    entropy(.base4, 128, 64)
  }
  
  func testBase2Entropy() {
    entropy(.base2,   1,   1)
    entropy(.base2,   2,   2)
    entropy(.base2,   3,   3)
    entropy(.base2,  32,  32)
    entropy(.base2,  48,  48)
    entropy(.base2, 122, 122)
    entropy(.base2, 128, 128)
  }
  
  func entropy(_ base: RandomString.CharBase, _ bits: Float, _ expected: Int) {
    var string = RandomString.entropy(of: bits, using: base)
    XCTAssertEqual(string.characters.count, expected)
  }
  
  func testTotalEntropy() {
    for risk in powers {
      _ = Entropy.bits(for: 10000, risk: risk)
    }
    
    entropyBits(    30,   .ten06,   29)
    entropyBits(100000,   .ten12,   73)
    entropyBits(UInt.max, .ten15,  177)

    stringLength(30, .ten06, .base64,  5)
    stringLength(30, .ten06, .base32,  6)
    stringLength(30, .ten06, .base16,  8)
    stringLength(30, .ten06, .base8,  10)
    stringLength(30, .ten06, .base4,  15)
    stringLength(30, .ten06, .base2,  29)

    stringLength(100000, .ten12, .base64,  13)
    stringLength(100000, .ten12, .base32,  15)
    stringLength(100000, .ten12, .base16,  19)
    stringLength(100000, .ten12, .base8,   25)
    stringLength(100000, .ten12, .base4,   37)
    stringLength(100000, .ten12, .base2,   73)

    stringLength(UInt.max, .ten15, .base64,  30)
    stringLength(UInt.max, .ten15, .base32,  36)
    stringLength(UInt.max, .ten15, .base16,  45)
    stringLength(UInt.max, .ten15, .base8,   59)
    stringLength(UInt.max, .ten15, .base4,   89)
    stringLength(UInt.max, .ten15, .base2,  177)
  }
  
  func entropyBits(_ total: UInt, _ risk: Entropy.Power, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    XCTAssertEqual(UInt(ceil(bits)), expected)
  }

  func stringLength(_ total: UInt, _ risk: Entropy.Power, _ base: RandomString.CharBase, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    let len = UInt(ceil(bits / Float(base.entropyPerChar)))
    XCTAssertEqual(len,  expected)
  }
  
  func testPowerEntropy() {
    for total in powers {
      for risk in powers {
        _ = Entropy.bits(for: total, risk: risk)
      }
    }
    
    stringLength(.ten05, .ten12, .base64, 13)
    stringLength(.ten05, .ten12, .base32, 15)
    stringLength(.ten05, .ten12, .base16, 19)
    stringLength(.ten05, .ten12, .base8,  25)
    stringLength(.ten05, .ten12, .base4,  37)
    stringLength(.ten05, .ten12, .base2,  73)
    
    stringLength(.ten10, .ten09, .base64, 16)
    stringLength(.ten10, .ten09, .base32, 20)
    stringLength(.ten10, .ten09, .base16, 24)
    stringLength(.ten10, .ten09, .base8,  32)
    stringLength(.ten10, .ten09, .base4,  48)
    stringLength(.ten10, .ten09, .base2,  96)
  }
  
  func stringLength(_ power: Entropy.Power, _ risk: Entropy.Power, _ base: RandomString.CharBase, _ expected: UInt) {
    let bits = Entropy.bits(for: power, risk: risk)
    let len = UInt(ceil(bits / Float(base.entropyPerChar)))
    XCTAssertEqual(len,  expected)
  }

  

  func testInvalidBytes() {
    invalidBytes( 7, .base64, [1])
    invalidBytes(13, .base64, [1,2])
    invalidBytes(25, .base64, [1,2,3])
    invalidBytes(31, .base64, [1,2,3,4])
    
    invalidBytes( 6, .base32, [1])
    invalidBytes(16, .base32, [1,2])
    invalidBytes(21, .base32, [1,2,3])
    invalidBytes(31, .base32, [1,2,3,4])
    invalidBytes(41, .base32, [1,2,3,4,5])
    invalidBytes(46, .base32, [1,2,3,4,5,6])
    
    invalidBytes( 9, .base16, [1])
    invalidBytes(17, .base16, [1,2])
    
    invalidBytes( 7, .base8,  [1])
    invalidBytes(16, .base8,  [1,2])
    invalidBytes(25, .base8,  [1,2,3])
    invalidBytes(31, .base8,  [1,2,3,4])

    invalidBytes( 9, .base4,  [1])
    invalidBytes(17, .base4,  [1,2])
    
    invalidBytes( 9, .base2,  [1])
    invalidBytes(17, .base2,  [1,2])
  }
  
  func invalidBytes(_ bits: Float, _ base: RandomString.CharBase, _ bytes: RandomString.Bytes) {
    do {
      _ = try randomString.entropy(of: bits, using: base, bytes: bytes)
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
    entropy( 6, .base64, [0xdd],                                                 "3")
    entropy(12, .base64, [0x78, 0xfc],                                           "eP")
    entropy(18, .base64, [0xc5, 0x6f, 0x21],                                     "xW8")
    entropy(24, .base64, [0xc9, 0x68, 0xc7],                                     "yWjH")
    entropy(30, .base64, [0xa5, 0x62, 0x20, 0x87],                               "pWIgh")
    entropy(36, .base64, [0x39, 0x51, 0xca, 0xcc, 0x8b],                         "OVHKzI")
    entropy(42, .base64, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],                   "g4kAx_Q")
    entropy(48, .base64, [0x51, 0xbc, 0xa8, 0xc7, 0xc9, 0x17],                   "Ubyox8kX")
    entropy(54, .base64, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52],             "0uPp2hmXU")
    entropy(60, .base64, [0xd9, 0x39, 0xc1, 0xaf, 0x1e, 0x2e, 0x69, 0x48],       "2TnBrx4uaU")
    entropy(66, .base64, [0x78, 0x3f, 0xfd, 0x93, 0xd1, 0x06, 0x90, 0x4b, 0xd6], "eD_9k9EGkEv")
    entropy(72, .base64, [0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80], "nZlOpdI_jIaA")
  }
  
  func testBase32() {
    entropy( 5, .base32, [0xdd],                                     "N")
    entropy(10, .base32, [0x78, 0xfc],                               "p6")
    entropy(15, .base32, [0x78, 0xfc],                               "p6R")
    entropy(20, .base32, [0xc5, 0x6f, 0x21],                         "JFHt")
    entropy(25, .base32, [0xa5, 0x62, 0x20, 0x87],                   "DFr43")
    entropy(30, .base32, [0xa5, 0x62, 0x20, 0x87],                   "DFr433")
    entropy(35, .base32, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7")
    entropy(40, .base32, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7h")
    entropy(45, .base32, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],       "qn7q3rTD2")
    entropy(50, .base32, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQ")
    entropy(55, .base32, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQf")
  }
  
  func testBase16() {
    entropy( 4, .base16, [0x9d],             "9")
    entropy( 8, .base16, [0xae],             "ae")
    entropy(12, .base16, [0x01, 0xf2],       "01f")
    entropy(16, .base16, [0xc7, 0xc9],       "c7c9")
    entropy(20, .base16, [0xc7, 0xc9, 0x00], "c7c90")
  }
  
  func testBase8() {
    entropy( 3, .base8, [0x5a],                   "2")
    entropy( 6, .base8, [0x5a],                   "26")
    entropy( 9, .base8, [0x21, 0xa4],             "103")
    entropy(12, .base8, [0x21, 0xa4],             "1032")
    entropy(15, .base8, [0xda, 0x19],             "66414")
    entropy(18, .base8, [0xfd, 0x93, 0xd1],       "773117")
    entropy(21, .base8, [0xfd, 0x93, 0xd1],       "7731172")
    entropy(24, .base8, [0xfd, 0x93, 0xd1],       "77311721")
    entropy(27, .base8, [0xc7, 0xc9, 0x07, 0xc9], "617444076")
    entropy(30, .base8, [0xc7, 0xc9, 0x07, 0xc9], "6174440762")
  }
  
  func testBase4() {
    entropy( 2, .base4, [0x5a],       "T")
    entropy( 4, .base4, [0x5a],       "TT")
    entropy( 6, .base4, [0x93],       "CTA")
    entropy( 8, .base4, [0x93],       "CTAG")
    entropy(10, .base4, [0x20, 0xf1], "ACAAG")
    entropy(12, .base4, [0x20, 0xf1], "ACAAGG")
    entropy(14, .base4, [0x20, 0xf1], "ACAAGGA")
    entropy(16, .base4, [0x20, 0xf1], "ACAAGGAT")
  }
  
  func testBase2() {
    entropy( 1, .base2, [0x27],       "0")
    entropy( 2, .base2, [0x27],       "00")
    entropy( 3, .base2, [0x27],       "001")
    entropy( 4, .base2, [0x27],       "0010")
    entropy( 5, .base2, [0x27],       "00100")
    entropy( 6, .base2, [0x27],       "001001")
    entropy( 7, .base2, [0x27],       "0010011")
    entropy( 8, .base2, [0x27],       "00100111")
    entropy( 9, .base2, [0xe3, 0xe9], "111000111")
    entropy(16, .base2, [0xe3, 0xe9], "1110001111101001")
  }

  func entropy(_ bits: Float, _ base: RandomString.CharBase, _ bytes: [UInt8], _ expected: String) {
    do {
      var string = try RandomString.entropy(of: bits, using: base, bytes: bytes)
      XCTAssertEqual(string, expected)
      string = try randomString.entropy(of: bits, using: base, bytes: bytes)
      XCTAssertEqual(string, expected)
    }
    catch {
      XCTFail(error.localizedDescription)
    }
  }
  
  func testSecure() {
    for base in bases {
      var secure = false
      _ = RandomString.entropy(of: 36, using: base, secure: &secure)
      XCTAssertFalse(secure)
      
      secure = true
      _ = RandomString.entropy(of: 36, using: .base64, secure: &secure)
    }
  }
  
  // Adopt XCTestCaseProvider to run test on  Linux
  var allTests: [(String, () throws -> ())] {
    return [
      ("testCharBaseLengths",  testCharBaseLengths),
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
