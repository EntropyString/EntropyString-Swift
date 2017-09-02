//: [Previous](@previous)
//:## TL;DR
//: ##### One million random strings with one in a billion risk of repeat
//: Generate up to a _1 million_ random strings with _1 in a billion_ chance of repeat:
import EntropyString

var random = Random()
var bits = Entropy.bits(for: 1.0e6, risk: 1.0e9)
var string = random.string(bits: bits)

descr = "A million random strings with one in a billion risk of repeat:"
print("\n  \(descr): \(string)")
//: * callout(string): 2tF6bMNPqQ82Qj
//:
//: ##### One million hex random strings with one in a billion risk of repeat
//: `EntropyString` uses predefined `charset32` characters by default (reference [Character Sets](Character%20Sets)). To get a random hexadecimal string with the same entropy bits as above (see [Real Need](Real%20Need) for description of what entropy bits represents):
random.use(.charSet16)
string = random.string(bits: bits)

descr = "A million hex random strings with one in a billion risk of repeat:"
print("\n  \(descr): \(string)")
//: * callout(string): a946ff97a1c4e64e79
//:
//: ##### Custom characters
//: Custom characters may be specified. Using uppercase hexadecimal characters:
try! random.use("0123456789ABCDEF")
string = random.string(bits: bits)

descr = "A million uppercase hex random strings with one in a billion risk of repeat:"
print("\n  \(descr): \(string)")
//: * callout(string): 78E3ACABE544EBA7DF
//:
//: ##### Convenience functions
//: Convenience functions exists for a variety of scenarios. For example, to create OWASP session ID:
string = random.sessionID()

var descr = "OWASP session ID using custom hex characters"
print("\n  \(descr): \(string)")
//: * callout(string): CC287C99158BF152DF98AF36D5E92AE3
//:
//: Or a 256 bit token using [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe characters:
string = random.token(.charSet64)

descr = "256 bit token using RFC 4648 file system and URL safe characters"
print("\n  \(descr): \(string)")
//: * callout(string): X2AZRHuNN3mFUhsYzHSE_r2SeZJ_9uqdw-j9zvPqU2O
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
