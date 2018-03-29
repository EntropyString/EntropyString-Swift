//: [Previous](@previous)
//:## TL;DR
//: ##### One million random strings with one in a billion risk of repeat
//: Generate up to a _1 million_ random strings with _1 in a billion_ chance of repeat:
import EntropyString

var bits = Entropy.bits(for: 1.0e6, risk: 1.0e9)
var entropy = Entropy()
var string = entropy.string(bits: bits)

descr = "A million random strings with one in a billion risk of repeat"
print("\n  \(descr): \(string)")
//: * callout(string): 2tF6bMNPqQ82Qj
//:
//: See [Real Need](Real%20Need) for description of what entropy bits represents.
//:
//: ##### One million hex random strings with one in a billion risk of repeat
//: `EntropyString` uses predefined `charset32` characters by default (reference [Character Sets](Character%20Sets)). To get a random hexadecimal string with the same entropy bits as above:
entropy.use(.charset16)
string = entropy.string(bits: bits)

descr = "A million hex random strings with one in a billion risk of repeat"
print("\n  \(descr): \(string)")
//: * callout(string): a946ff97a1c4e64e79
//:
//: ##### Custom characters
//: Custom characters may be specified. Using uppercase hexadecimal characters:
try! entropy.use("0123456789ABCDEF")
string = entropy.string(bits: bits)

descr = "A million uppercase hex random strings with one in a billion risk of repeat"
print("\n  \(descr): \(string)")
//: * callout(string): 78E3ACABE544EBA7DF
//:
//: ##### Convenience functions
//: Functions `smallID`, `mediumID`, `largeID`, `sessionID` and `token` provide random strings for various predefined bits of entropy. For example, a small id represents a potential of 30 strings with a 1 in a million chance of repeat:
string = entropy.smallID()

descr = "Small ID represents 1 in a million chance of repeat in 30 strings"
print("\n  \(descr): \(string)")
//: * callout(Small ID): fn7H3N
//:
//: Or, to generate an OWASP session ID
string = entropy.sessionID()

var descr = "Or, an OWASP session ID"
print("\n  \(descr): \(string)")
//: * callout(string): CC287C99158BF152DF98AF36D5E92AE3
//:
//: Or perhaps you need a 256 bit token using [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe characters:
string = entropy.token(.charset64)

descr = "256 bit token using RFC 4648 file system and URL safe characters"
print("\n  \(descr): \(string)")
//: * callout(string): X2AZRHuNN3mFUhsYzHSE_r2SeZJ_9uqdw-j9zvPqU2O
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
