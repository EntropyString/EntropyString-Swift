//: [Previous](@previous)
//:## TL;DR
  import EntropyString

//: ###### OWASP session ID using base 32 characters:
  var random = Random()
  var string = random.sessionID()

  var descr = "OWASP session ID using base 32 characters"
  print("\n  \(descr): \(string)")
//: * callout(string): NPgHpr37TNPL7DpgDh3q6T4h2B
//:
//:
//: ##### OWASP session ID using [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe characters:
  random.use(CharSet.charSet64)
  string = random.sessionID()

  descr = "OWASP session ID using RFC 4648 file system and URL safe characters"
  print("\n  \(descr): \(string)")
//: * callout(string): 9gTtKf_LGD19GCt26LEo1d
//:
//: ##### 48-bit string using hex characters:
  random.use(CharSet.charSet16)
  string = random.string(bits: 48)

  descr = "48-bit string using hex characters"
  print("\n  \(descr): \(string)")
//: * callout(string): b16851e3ac98
//:
//: ##### 96-bit string using uppercase hex characters:
  try! random.use("0123456789ABCDEF")
  string = random.string(bits: 96)

  descr = "96-bit string using uppercase hex characters"
  print("\n  \(descr): \(string)")
//: * callout(string): 134BBC6465B0DF101BFBC44B
//:
//: ##### Base 32 character string with a 1 in a million chance of a repeat in 30 strings:
  var bits = Entropy.bits(for: 30, risk: 1000000)
  random.use(.charSet32)
  string = random.string(bits: bits)

  descr = "Base 32 character string with a 1 in a million chance of a repeat in 30 strings"
  print("\n  \(descr): \(string)")
//: * callout(string): QmtGhb
//:
//: ##### Base 64 character string with a 1 in a trillion chance of a repeat in 100 million strings:
  bits = Entropy.bits(for: .ten07, risk: .ten12)
  random = Random(.charSet64)
  string = random.string(bits: bits)

  descr = "Base 64 character string with a 1 in a trillion chance of a repeat in 100 million strings"
  print("\n  \(descr): \(string)")
//: * callout(string): Datt9RQXWXm5Etj
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
