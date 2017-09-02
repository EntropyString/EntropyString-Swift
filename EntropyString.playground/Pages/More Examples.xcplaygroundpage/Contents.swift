//: [Previous](@previous)
//: ## More Examples
//:
//: In [Real Need](Real%20Need) our developer used hexadecimal characters for the strings.
//: Let's look at using other characters instead.
//:
//: We'll start with using 32 characters. What 32 characters, you ask? The [Character Sets](Character%20Sets) section discusses the default characters available in `EntropyString` and the [Custom Characters](Custom%20Characters) section describes how you can use whatever characters you want. By default, `EntropyString` uses `charSet32` characters, so we don't need to pass that parameter into `Random()`.
import EntropyString

var random = Random()
var bits = Entropy.bits(for: 1.0e5, risk: 1.0e6)
var string = random.string(bits: bits)

var descr = "Ten thousand base 32 strings with 1 in a million risk of repeat"
print("\n  \(descr): \(string)\n")
//: * callout(string): pPp2F6RhHJ
//: 
//: We're using the same __bits__ calculation since we haven't changed the number of IDs or the accepted risk of probabilistic uniqueness. But this time we use 32 characters and our resulting ID only requires 10 characters (and can carry 50 bits of entropy).
//:
//: As another example, let's assume we need to ensure the names of a handful of items are unique. `EntropyString.smallID` yields strings that have a 1 in a million chance of repeat in 30 strings.
string = random.smallID()

descr = "Small ID with a 1 in a million chance of repeat in 30 strings:"
print("\n  \(descr): \(string)\n")
//: * callout(string): ThfLbm
//:
//: Using the same `Random` instance, we can switch to the predefined `charSet4` characters:
string = random.smallID(.charSet4)

random.smallID(.charSet4)

descr = "Base 4 small ID"
print("\n  \(descr): \(string)\n")
//: * callout(string): CCCCTCAGGCATAGG
//:
//: Okay, we probably wouldn't use 4 characters (and what's up with those characters?), but you get the idea.
//:
//: Suppose we have a more extreme need. We want less than a 1 in a trillion chance that 10 billion strings repeat. Let's see, our risk (trillion) is 10 to the 12th and our total (10 billion) is 10 to the 10th, so:
random.use(.charSet32)
bits = Entropy.bits(for: 1.0e10, risk: 1.0e12)
string = random.string(bits: bits)

descr = "String with 1 in a trillion chance of repeat in 10 billion strings"
print("\n  \(descr): \(string)\n")
//: * callout(string): frN7L8b9bHrpnBHPmR9RnM
//:
//: Finally, let say we're generating session IDs. Since session IDs are ephemeral, we aren't interested in uniqueness per se, but in ensuring our IDs aren't predict0able since we can't have the bad guys guessing a valid session ID. In this case, we're using entropy as a measure of unpredictability of the IDs. Rather than calculate our entropy, we declare it as 128 bits (since we read on the OWASP web site that session IDs should be 128 bits).
string = random.sessionID(.charSet64)

descr = "OWASP URL and file system safe session ID"
print("\n  \(descr): \(string)\n")
//: * callout(string): p-own2zCpNx1Y4TdfyuDsI
//:
//: Using 64 characters, our string length is 22 characters. That's actually `22*6 = 132` bits, so we've got our OWASP requirement covered! 😌
//:
//: Also note that we covered our need using strings that are only 22 characters in length. So long to using GUID strings which only carry 122 bits of entropy (commonly used version 4) and use string representations that are 36 characters long (hex with dashes).
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
