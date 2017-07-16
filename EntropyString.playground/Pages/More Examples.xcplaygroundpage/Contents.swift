//: [Previous](@previous)
//: ## More Examples
//:
//: In [Real Need](Real%20Need) our developer used hexadecimal characters for the strings.
//: Let's look at using other characters instead.
//:
//: We'll start with using 32 characters. What 32 characters, you ask? Well, the [Character
//: Bases](Character%20Bases) section discusses the default characters available in `EntropyString`
//: and the [Custom Characters](Custom%20Characters) section describes how you can use whatever
//: characters you want. For now we'll stick to the provided defaults.
import EntropyString

var bits = Entropy.bits(for: 10000, risk: .ten06)
var string = RandomString.entropy(of: bits, using: .charSet32)
print("String: \(string)\n")
//: * callout(string): PmgMJrdp9h
//: 
//: We're using the same __bits__ calculation since we haven't changed the number of IDs or the
//: accepted risk of probabilistic uniqueness. But this time we use 32 characters and our resulting
//: ID only requires 10 characters (and can carry 50 bits of entropy).
//:
//: Now let's suppose we need to ensure the names of a handful of items are unique.  Let's say 30
//: items. And let's decide we can live with a 1 in 100,000 probability of collision (we're just
//: futzing with some code ideas). Using hex characters:
bits = Entropy.bits(for: 30, risk: .ten05)
string = RandomString.entropy(of: bits, using: .charSet16)
print("String: \(string)\n")
//: * callout(string): 766923a
//:
//: Using the CharSet 4 characters:
string = RandomString.entropy(of: bits, using: .charSet4)
print("String: \(string)\n")
//: * callout(string): GCGTCGGGTTTTA
//:
//: Okay, we probably wouldn't use 4 characters (and what's up with those characters?), but you get the
//: idea.
//:
//: Suppose we have a more extreme need. We want less than a 1 in a trillion chance that 10
//: billion strings of 32 characters repeat. Let's see, our risk (trillion) is 10 to the 12th and
//: our total (10 billion) is 10 to the 10th, so:
//:
bits = Entropy.bits(for: .ten10, risk: .ten12)
string = RandomString.entropy(of: bits, using: .charSet32)
print("String: \(string)\n")
//: * callout(string): F78PmfGRNfJrhHGTqpt6Hn
//:
//: Finally, let say we're generating session IDs. We're not interested in uniqueness per se, but in
//: ensuring our IDs aren't predicatable since we can't have the bad guys guessing a valid ID. In
//: this case, we're using entropy as a measure of unpredictability of the IDs. Rather than calculate
//: our entropy, we declare it needs to be 128 bits (since we read on some web site that session IDs
//: should be 128 bits).
string = RandomString.entropy(of: 128, using: .charSet64)
print("String: \(string)\n")
//: * callout(string): b0Gnh6H5cKCjWrCLwKoeuN
//:
//: Using 64 characters, our string length is 22 characters. That's actually 132 bits, so we've got
//: our OWASP requirement covered! 😌
//:
//: Also note that we covered our need using strings that are only 22 characters in length. So long
//: to using GUID strings which only carry 122 bits of entropy (commonly used version 4) and use string
//: representations that are 36 characters long (hex with dashes).
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
