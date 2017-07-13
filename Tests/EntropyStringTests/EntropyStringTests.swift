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
  
  func testZeroEntropy() {
    for power in powers {
      entropyBits(0, power, 0)
    }
    
    for charSet in charSets {
      XCTAssertEqual(RandomString.entropy(of: 0, using: charSet), "")
    }
  }
  
  func testCharSet64() {
    entropyString( 6, .charSet64, [0xdd],                                                 "3")
    entropyString(12, .charSet64, [0x78, 0xfc],                                           "eP")
    entropyString(18, .charSet64, [0xc5, 0x6f, 0x21],                                     "xW8")
    entropyString(24, .charSet64, [0xc9, 0x68, 0xc7],                                     "yWjH")
    entropyString(30, .charSet64, [0xa5, 0x62, 0x20, 0x87],                               "pWIgh")
    entropyString(36, .charSet64, [0x39, 0x51, 0xca, 0xcc, 0x8b],                         "OVHKzI")
    entropyString(42, .charSet64, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],                   "g4kAx_Q")
    entropyString(48, .charSet64, [0x51, 0xbc, 0xa8, 0xc7, 0xc9, 0x17],                   "Ubyox8kX")
    entropyString(54, .charSet64, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52],             "0uPp2hmXU")
    entropyString(60, .charSet64, [0xd9, 0x39, 0xc1, 0xaf, 0x1e, 0x2e, 0x69, 0x48],       "2TnBrx4uaU")
    entropyString(66, .charSet64, [0x78, 0x3f, 0xfd, 0x93, 0xd1, 0x06, 0x90, 0x4b, 0xd6], "eD_9k9EGkEv")
    entropyString(72, .charSet64, [0x9d, 0x99, 0x4e, 0xa5, 0xd2, 0x3f, 0x8c, 0x86, 0x80], "nZlOpdI_jIaA")
  }
  
  func testCharSet32() {
    entropyString( 5, .charSet32, [0xdd],                                     "N")
    entropyString(10, .charSet32, [0x78, 0xfc],                               "p6")
    entropyString(15, .charSet32, [0x78, 0xfc],                               "p6R")
    entropyString(20, .charSet32, [0xc5, 0x6f, 0x21],                         "JFHt")
    entropyString(25, .charSet32, [0xa5, 0x62, 0x20, 0x87],                   "DFr43")
    entropyString(30, .charSet32, [0xa5, 0x62, 0x20, 0x87],                   "DFr433")
    entropyString(35, .charSet32, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7")
    entropyString(40, .charSet32, [0x39, 0x51, 0xca, 0xcc, 0x8b],             "b8dPFB7h")
    entropyString(45, .charSet32, [0x83, 0x89, 0x00, 0xc7, 0xf4, 0x02],       "qn7q3rTD2")
    entropyString(50, .charSet32, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQ")
    entropyString(55, .charSet32, [0xd2, 0xe3, 0xe9, 0xda, 0x19, 0x97, 0x52], "MhrRBGqLtQf")
  }
  
  func testCharSet16() {
    entropyString( 4, .charSet16, [0x9d],             "9")
    entropyString( 8, .charSet16, [0xae],             "ae")
    entropyString(12, .charSet16, [0x01, 0xf2],       "01f")
    entropyString(16, .charSet16, [0xc7, 0xc9],       "c7c9")
    entropyString(20, .charSet16, [0xc7, 0xc9, 0x00], "c7c90")
  }
  
  func testCharSet8() {
    entropyString( 3, .charSet8, [0x5a],                   "2")
    entropyString( 6, .charSet8, [0x5a],                   "26")
    entropyString( 9, .charSet8, [0x21, 0xa4],             "103")
    entropyString(12, .charSet8, [0x21, 0xa4],             "1032")
    entropyString(15, .charSet8, [0xda, 0x19],             "66414")
    entropyString(18, .charSet8, [0xfd, 0x93, 0xd1],       "773117")
    entropyString(21, .charSet8, [0xfd, 0x93, 0xd1],       "7731172")
    entropyString(24, .charSet8, [0xfd, 0x93, 0xd1],       "77311721")
    entropyString(27, .charSet8, [0xc7, 0xc9, 0x07, 0xc9], "617444076")
    entropyString(30, .charSet8, [0xc7, 0xc9, 0x07, 0xc9], "6174440762")
  }
  
  func testCharSet4() {
    entropyString( 2, .charSet4, [0x5a],       "T")
    entropyString( 4, .charSet4, [0x5a],       "TT")
    entropyString( 6, .charSet4, [0x93],       "CTA")
    entropyString( 8, .charSet4, [0x93],       "CTAG")
    entropyString(10, .charSet4, [0x20, 0xf1], "ACAAG")
    entropyString(12, .charSet4, [0x20, 0xf1], "ACAAGG")
    entropyString(14, .charSet4, [0x20, 0xf1], "ACAAGGA")
    entropyString(16, .charSet4, [0x20, 0xf1], "ACAAGGAT")
  }
  
  func testCharSet2() {
    entropyString( 1, .charSet2, [0x27],       "0")
    entropyString( 2, .charSet2, [0x27],       "00")
    entropyString( 3, .charSet2, [0x27],       "001")
    entropyString( 4, .charSet2, [0x27],       "0010")
    entropyString( 5, .charSet2, [0x27],       "00100")
    entropyString( 6, .charSet2, [0x27],       "001001")
    entropyString( 7, .charSet2, [0x27],       "0010011")
    entropyString( 8, .charSet2, [0x27],       "00100111")
    entropyString( 9, .charSet2, [0xe3, 0xe9], "111000111")
    entropyString(16, .charSet2, [0xe3, 0xe9], "1110001111101001")
  }
  
  func testCharSet64StringLens() {
    entropyStringLen(   5, .charSet64,  1)
    entropyStringLen(   6, .charSet64,  1)
    entropyStringLen(   7, .charSet64,  2)
    entropyStringLen(  18, .charSet64,  3)
    entropyStringLen(  50, .charSet64,  9)
    entropyStringLen( 122, .charSet64, 21)
    entropyStringLen( 128, .charSet64, 22)
    entropyStringLen( 132, .charSet64, 22)
  }
  
  func testCharSet32StringLens() {
    entropyStringLen(   4, .charSet32,  1)
    entropyStringLen(   5, .charSet32,  1)
    entropyStringLen(   6, .charSet32,  2)
    entropyStringLen(  20, .charSet32,  4)
    entropyStringLen(  32, .charSet32,  7)
    entropyStringLen( 122, .charSet32, 25)
    entropyStringLen( 128, .charSet32, 26)
    entropyStringLen( 130, .charSet32, 26)
  }
  
  func testCharSet16StringLens() {
    entropyStringLen(   3, .charSet16,  1)
    entropyStringLen(   4, .charSet16,  1)
    entropyStringLen(   5, .charSet16,  2)
    entropyStringLen(  14, .charSet16,  4)
    entropyStringLen(  40, .charSet16, 10)
    entropyStringLen( 122, .charSet16, 31)
    entropyStringLen( 128, .charSet16, 32)
  }
  
  func testCharSet8StringLens() {
    entropyStringLen(   2, .charSet8,  1)
    entropyStringLen(   3, .charSet8,  1)
    entropyStringLen(   4, .charSet8,  2)
    entropyStringLen(  32, .charSet8, 11)
    entropyStringLen(  48, .charSet8, 16)
    entropyStringLen( 120, .charSet8, 40)
    entropyStringLen( 122, .charSet8, 41)
    entropyStringLen( 128, .charSet8, 43)
  }
  
  func testCharSet4StringLens() {
    entropyStringLen(   1, .charSet4,  1)
    entropyStringLen(   2, .charSet4,  1)
    entropyStringLen(   3, .charSet4,  2)
    entropyStringLen(  32, .charSet4, 16)
    entropyStringLen(  48, .charSet4, 24)
    entropyStringLen( 122, .charSet4, 61)
    entropyStringLen( 128, .charSet4, 64)
  }
  
  func testCharSet2StringLens() {
    entropyStringLen(   1, .charSet2,   1)
    entropyStringLen(   2, .charSet2,   2)
    entropyStringLen(   3, .charSet2,   3)
    entropyStringLen(  32, .charSet2,  32)
    entropyStringLen(  48, .charSet2,  48)
    entropyStringLen( 122, .charSet2, 122)
    entropyStringLen( 128, .charSet2, 128)
  }
  
  func testTotalEntropy() {
    entropyBits(    10,   1000,   15)
    entropyBits(    10,  10000,   19)
    entropyBits(    10, 100000,   22)
    
    entropyBits(   100,   1000,   22)
    entropyBits(   100,  10000,   26)
    entropyBits(   100, 100000,   29)
    
    entropyBits(  1000,   1000,   29)
    entropyBits(  1000,  10000,   32)
    entropyBits(  1000, 100000,   36)
    
    entropyBits( 10000,   1000,   36)
    entropyBits( 10000,  10000,   39)
    entropyBits( 10000, 100000,   42)
    
    entropyBits(100000,   1000,   42)
    entropyBits(100000,  10000,   46)
    entropyBits(100000, 100000,   49)
    
    entropyBits(    10, .ten03,   15)
    entropyBits(    10, .ten04,   19)
    entropyBits(    10, .ten05,   22)
    
    entropyBits(   100, .ten03,   22)
    entropyBits(   100, .ten04,   26)
    entropyBits(   100, .ten05,   29)
    
    entropyBits(  1000, .ten03,   29)
    entropyBits(  1000, .ten04,   32)
    entropyBits(  1000, .ten05,   36)
    
    entropyBits( 10000, .ten03,   36)
    entropyBits( 10000, .ten04,   39)
    entropyBits( 10000, .ten05,   42)
    
    entropyBits(100000, .ten03,   42)
    entropyBits(100000, .ten04,   46)
    entropyBits(100000, .ten05,   49)
    
    entropyBits(.ten01, .ten03,   15)
    entropyBits(.ten01, .ten04,   19)
    entropyBits(.ten01, .ten05,   22)
    
    entropyBits(.ten02, .ten03,   22)
    entropyBits(.ten02, .ten04,   26)
    entropyBits(.ten02, .ten05,   29)
    
    entropyBits(.ten03, .ten03,   29)
    entropyBits(.ten03, .ten04,   32)
    entropyBits(.ten03, .ten05,   36)
    
    entropyBits(.ten04, .ten03,   36)
    entropyBits(.ten04, .ten04,   39)
    entropyBits(.ten04, .ten05,   42)
    
    entropyBits(.ten05, .ten03,   42)
    entropyBits(.ten05, .ten04,   46)
    entropyBits(.ten05, .ten05,   49)
    
    for total in powers {
      for risk in powers {
        _ = Entropy.bits(for: total, risk: risk)
      }
    }
    
    entropyBits(UInt.max, .ten15,  177)
  }

  func testStringLens() {
    stringLength(30, .ten06, .charSet64,  5)
    stringLength(30, .ten06, .charSet32,  6)
    stringLength(30, .ten06, .charSet16,  8)
    stringLength(30, .ten06, .charSet8,  10)
    stringLength(30, .ten06, .charSet4,  15)
    stringLength(30, .ten06, .charSet2,  29)
    
    stringLength(1000,   .ten10, .charSet64,  9)
    stringLength(1000,   .ten10, .charSet32, 11)
    stringLength(1000,   .ten10, .charSet16, 14)
    stringLength(1000,   .ten10, .charSet8,  18)
    stringLength(1000,   .ten10, .charSet4,  27)
    stringLength(1000,   .ten10, .charSet2,  53)
    
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
  
  func testPreshingTable() {
    // From table at http://preshing.com/20110504/hash-collision-probabilities/
    // 32-bit column
    entropyBits(30084, .ten01, 32)
    entropyBits( 9292, .ten02, 32)
    entropyBits( 2932, .ten03, 32)
    entropyBits(  927, .ten04, 32)
    entropyBits(  294, .ten05, 32)
    entropyBits(   93, .ten06, 32)
    entropyBits(   30, .ten07, 32)
    entropyBits(   10, .ten08, 32)
    
    // 64-bit column
    entropyBits(1970000000, .ten01, 64)
    entropyBits( 609000000, .ten02, 64)
    entropyBits( 192000000, .ten03, 64)
    entropyBits(  60700000, .ten04, 64)
    entropyBits(  19200000, .ten05, 64)
    entropyBits(   6070000, .ten06, 64)
    entropyBits(   1920000, .ten07, 64)
    entropyBits(    607401, .ten08, 64)
    entropyBits(    192077, .ten09, 64)
    entropyBits(     60704, .ten10, 64)
    entropyBits(     19208, .ten11, 64)
    entropyBits(      6074, .ten12, 64)
    entropyBits(      1921, .ten13, 64)
    entropyBits(       608, .ten14, 64)
    entropyBits(       193, .ten15, 64)
    entropyBits(        61, .ten16, 64)
    entropyBits(        20, .ten17, 64)
    entropyBits(         7, .ten18, 64)
    
    // 160-bit column, modified (over/under) and extended
    entropyBits(.ten24, .ten01, 162)
    entropyBits(.ten23, .ten01, 155)
    entropyBits(.ten24, .ten02, 165)
    entropyBits(.ten23, .ten02, 158)
    entropyBits(.ten23, .ten03, 162)
    entropyBits(.ten22, .ten03, 155)
    entropyBits(.ten23, .ten04, 165)
    entropyBits(.ten22, .ten04, 158)
    entropyBits(.ten22, .ten05, 162)
    entropyBits(.ten21, .ten05, 155)
    entropyBits(.ten22, .ten06, 165)
    entropyBits(.ten21, .ten06, 158)
    entropyBits(.ten21, .ten07, 162)
    entropyBits(.ten20, .ten07, 155)
    entropyBits(.ten21, .ten08, 165)
    entropyBits(.ten20, .ten08, 158)
    entropyBits(.ten20, .ten09, 162)
    entropyBits(.ten19, .ten09, 155)
    entropyBits(.ten20, .ten10, 165)
    entropyBits(.ten19, .ten10, 158)
    entropyBits(.ten19, .ten11, 162)
    entropyBits(.ten18, .ten11, 155)
    entropyBits(.ten19, .ten12, 165)
    entropyBits(.ten18, .ten12, 158)
    entropyBits(.ten18, .ten13, 162)
    entropyBits(.ten17, .ten13, 155)
    entropyBits(.ten18, .ten14, 165)
    entropyBits(.ten17, .ten14, 158)
    entropyBits(.ten17, .ten15, 162)
    entropyBits(.ten16, .ten15, 155)
    entropyBits(.ten17, .ten16, 165)
    entropyBits(.ten16, .ten16, 158)
    entropyBits(.ten16, .ten17, 162)
    entropyBits(.ten15, .ten17, 155)
    entropyBits(.ten16, .ten18, 165)
    entropyBits(.ten15, .ten18, 158)
    entropyBits(.ten15, .ten19, 162)
    entropyBits(.ten14, .ten19, 155)
    entropyBits(.ten15, .ten20, 165)
    entropyBits(.ten14, .ten20, 158)
    entropyBits(.ten14, .ten21, 162)
    entropyBits(.ten13, .ten21, 155)
    entropyBits(.ten14, .ten22, 165)
    entropyBits(.ten13, .ten22, 158)
    entropyBits(.ten13, .ten23, 162)
    entropyBits(.ten12, .ten23, 155)
    entropyBits(.ten13, .ten24, 165)
    entropyBits(.ten12, .ten24, 158)
    entropyBits(.ten12, .ten25, 162)
    entropyBits(.ten11, .ten25, 155)
    entropyBits(.ten12, .ten26, 165)
    entropyBits(.ten11, .ten26, 158)
    entropyBits(.ten11, .ten27, 162)
    entropyBits(.ten10, .ten27, 155)
    entropyBits(.ten11, .ten28, 165)
    entropyBits(.ten10, .ten28, 158)
    entropyBits(.ten10, .ten29, 162)
    entropyBits(.ten09, .ten29, 155)
    entropyBits(.ten10, .ten30, 165)
    entropyBits(.ten09, .ten30, 158)
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

  func testSecure() {
    for charSet in charSets {
      var secure = false
      _ = RandomString.entropy(of: 36, using: charSet, secure: &secure)
      XCTAssertFalse(secure)
      
      secure = true
      _ = RandomString.entropy(of: 36, using: .charSet64, secure: &secure)
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
  
  func testCharSetLengths() {
    for charSet in charSets {
      var count = RandomString.characters(for: charSet).characters.count
      XCTAssertEqual(count, String.CharacterView.IndexDistance(charSet.rawValue))
      
      count = randomString.characters(for: charSet).characters.count
      XCTAssertEqual(count, String.CharacterView.IndexDistance(charSet.rawValue))
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
  
  // MARK: - Helper functions -
  
  func entropyString(_ bits: Float, _ charSet: CharSet, _ bytes: [UInt8], _ expected: String) {
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

  func entropyStringLen(_ bits: Float, _ charSet: CharSet, _ expected: Int) {
    var string = RandomString.entropy(of: bits, using: charSet)
    XCTAssertEqual(string.characters.count, expected)
  }
  
  func entropyBits(_ total: UInt, _ risk: UInt, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    XCTAssertEqual(UInt(round(bits)), expected)
  }
  
  func entropyBits(_ total: UInt, _ risk: Entropy.Power, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    XCTAssertEqual(UInt(round(bits)), expected)
  }
  
  func entropyBits(_ total: Entropy.Power, _ risk: Entropy.Power, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    XCTAssertEqual(UInt(round(bits)), expected)
  }

  func stringLength(_ total: UInt, _ risk: Entropy.Power, _ charSet: CharSet, _ expected: UInt) {
    let bits = Entropy.bits(for: total, risk: risk)
    let len = UInt(ceil(bits / Float(charSet.entropyPerChar)))
    XCTAssertEqual(len,  expected)
  }
  
  func stringLength(_ power: Entropy.Power, _ risk: Entropy.Power, _ charSet: CharSet, _ expected: UInt) {
    let bits = Entropy.bits(for: power, risk: risk)
    let len = UInt(ceil(bits / Float(charSet.entropyPerChar)))
    XCTAssertEqual(len,  expected)
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
  
  // Adopt XCTestCaseProvider to run test on  Linux
  var allTests: [(String, () throws -> ())] {
    return [
      ("testZeroEntropy",         testZeroEntropy),
      ("testCharSet64",           testCharSet64),
      ("testCharSet32",           testCharSet32),
      ("testCharSet16",           testCharSet16),
      ("testCharSet8",            testCharSet8),
      ("testCharSet4",            testCharSet4),
      ("testCharSet2",            testCharSet2),
      ("testCharSet64StringLens", testCharSet64StringLens),
      ("testCharSet32StringLens", testCharSet32StringLens),
      ("testCharSet16StringLens", testCharSet16StringLens),
      ("testCharSet8StringLens",  testCharSet8StringLens),
      ("testCharSet4StringLens",  testCharSet4StringLens),
      ("testCharSet2StringLens",  testCharSet2StringLens),
      ("testTotalEntropy",        testTotalEntropy),
      ("testStringLens",          testStringLens),
      ("testPreshingTable",       testPreshingTable),
      ("testInvalidBytes",        testInvalidBytes),
      ("testSecure",              testSecure),
      ("testEntropyLengths",      testEntropyLengths),
      ("testCharSetLengths",      testCharSetLengths),
      ("testCustom64Chars",       testCustom64Chars),
      ("testCustom32Chars",       testCustom32Chars),
      ("testCustom16Chars",       testCustom16Chars),
      ("testCustom8Chars",        testCustom8Chars),
      ("testCustom4Chars",        testCustom4Chars),
      ("testCustom2Chars",        testCustom2Chars)
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
