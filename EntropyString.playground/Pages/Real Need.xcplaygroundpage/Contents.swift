//: [Previous](@previous)
//: ## Real Need
//:
//: Let's start by reflecting on a common developer statement of need:
//:
//: *I need random strings 16 characters long.*
//:
//: Okay. There are libraries available that address that exact need. But first, there are some questions that arise from the need as stated, such as:
//:
//:  1. What characters do you want to use?
//:  2. How many of these strings do you need?
//:  3. Why do you need these strings?
//:
//: The available libraries often let you specify the characters to use. So we can assume for now that question 1 is answered with:
//:
//: *Hexadecimal IDs will do fine*.
//:
//: As for question 2, the developer might respond:
//:
//: *I need 10,000 of these things*.
//:
//: Ah, now we're getting somewhere. The answer to question 3 might lead to the further qualification:
//:
//: *I need to generate 10,000 random, unique IDs*.
//:
//: And the cat's out of the bag. We're getting at the real need, and it's not the same as the original statement. The developer needs *uniqueness* across a total of some number of strings. The length of the string is a by-product of the uniqueness, not the goal.
//: 
//: As noted in the [Overview](Overview), guaranteeing uniqueness is difficult, so we'll replace that declaration with one of *probabilistic uniqueness* by asking:
//:
//:   4. What risk of a repeat are you willing to accept?
//:
//: Probabilistic uniqueness contains risk. That's the price we pay for giving up on the stronger declaration of strict uniqueness. But the developer can quantify an appropriate risk for a particular scenario with a statement like:
//:
//: *I guess I can live with a 1 in a million chance of a repeat*.
//:
//: So now we've gotten to the real need:
//:
//: *I need 10,000 random hexadecimal IDs with less than 1 in a million chance of any repeats*.
//:
//: Not only is this statement more specific, there is no mention of string length. The developer needs probabilistic uniqueness, and strings are to be used to capture randomness for this purpose. As such, the length of the string is simply a by-product of the encoding used to represent the required uniqueness as a string.
//:
//: How do you address this need using a library designed to generate strings of specified length? Well, you don't directly, because that library was designed to answer the originally stated need, not the real need we've uncovered. We need a library that deals with probabilistic uniqueness of a total number of some strings. And that's exactly what `EntropyString` does.
//:
//: Let's use `EntropyString` to help this developer:
import EntropyString

let random = Random(charSet: .charSet16)
let bits = Entropy.bits(for: 10000, risk: .ten06)
var strings = [String]()
for i in 0 ..< 5 {
  let string = random.string(bits: bits)
  strings.append(string)
}
print("Strings: \(strings)")
//: * callout(strings): ["85e442fa0e83", "a74dc126af1e", "368cd13b1f6e", "81bf94e1278d", "fe7dec099ac9"]
//:
//: To generate the IDs, we first use
//:
//: ```swift
//: let bits = Entropy.bits(total: 10000, risk: .ten06)
//: ```
//:
//: to determine the bits of entropy needed to satisfy our probabilistic uniqueness of **10,000** strings with a **1 in a million** (ten to the sixth power) risk of repeat. We didn't print the result, but if you did you'd see it's about **45.51**. Then inside a loop we used
//:
//: ```swift
//: let string = random.string(bits: bits)
//: ```
//:
//: to actually generate random strings using hexadecimal (charSet16) characters. Looking at the IDs, we can see each is 12 characters long. Again, the string length is a by-product of the characters used to represent the entropy we needed. And it seems the developer didn't really need 16 characters after all.
//:
//: Finally, given that the strings are 12 hexadecimals long, each string actually has an information carrying capacity of 12 * 4 = 48 bits of entropy (a hexadecimal character carries 4 bits). That's fine. Assuming all characters are equally probable, a string can only carry entropy equal to a multiple of the amount of entropy represented per character. `EntropyString` produces the smallest strings that *exceed* the specified entropy.
//:
//: [TOC](Table%20of%20Contents) | [Next](@next)
