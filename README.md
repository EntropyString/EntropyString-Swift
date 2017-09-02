## EntropyString for Swift 

Efficiently generate cryptographically strong random strings of specified entropy from various character sets.

[![Build Status](https://travis-ci.org/EntropyString/EntropyString-Swift.svg?branch=master)](https://travis-ci.org/EntropyString/EntropyString-Swift) &nbsp; <a href="https://github.com/Carthage/Carthage"><img src="https://img.shields.io/badge/Carthage-compatible-4BC51D.svg?style=flat" alt="Carthage"></a> &nbsp; <a href="https://cocoapods.org/pods/EntropyString"><img src="https://img.shields.io/cocoapods/v/EntropyString.svg" alt="CocoaPods - EntropyString"></a> &nbsp; [![License: MIT](https://img.shields.io/npm/l/express.svg)](https://cdn.rawgit.com/EntropyString/EntropyString-Swift/3f417062/LICENSE)

## <a name="TOC"></a>
 - [Installation](#Installation)
 - [TL;DR](#TLDR)
 - [Overview](#Overview)
 - [Real Need](#RealNeed)
 - [More Examples](#MoreExamples)
 - [Character Sets](#CharacterSets)
 - [Custom Characters](#CustomCharacters)
 - [Efficiency](#Efficiency)
 - [Secure Bytes](#SecureBytes)
 - [Custom Bytes](#CustomBytes)
 - [TL;DR 2](#TLDR2)

[TOC](#TOC)

### <a name="Installation"></a>Installation

#### Carthage

[Carthage](https://github.com/Carthage/Carthage) is a decentralized dependency manager for Objective-C and Swift.

1. Add the project to your [Cartfile](https://github.com/Carthage/Carthage/blob/master/Documentation/Artifacts.md#cartfile).

    ```
    github "EntropyString/EntropyString-Swift.git"
    ```

2. Run `carthage update` and follow the [Carthage getting started steps](https://github.com/Carthage/Carthage#getting-started).

3. Import module EntropyString

    ```swift
    import EntropyString
    ```

#### CocoaPods

[CocoaPods](https://cocoapods.org/) is a centralized dependency manager for Objective-C and Swift.

1. Add the project to your [Podfile](https://guides.cocoapods.org/using/the-podfile.html).

    ```ruby
    use_frameworks!
    pod 'EntropyString', '~> 1.0.0'
    ```

2. Run `pod install` and open the `.xcworkspace` file to launch Xcode.

3. Import module EntropyString 

    ```swift
    import EntropyString
    ```

#### Swift Package Manager

The [Swift Package Manager](https://swift.org/package-manager/) is a decentralized dependency manager for Swift.

1. Add the project to your `Package.swift`.

    ```swift
    import PackageDescription

    let package = Package(
        name: "YourProject",
        dependencies: [
            .Package(url: "https://github.com/EntropyString/EntropyString-Swift.git",
                     majorVersion: 1)
        ]
    )
    ```

2. Import module EntropyString 

    ```swift
    import EntropyString
    ```

[TOC](#TOC)

----

The remainer of this README is included in the project as a Swift playground for interactive exploration XCode.

----

### <a name="TLDR"></a>TL;DR

  ```swift
  import EntropyString
  ```

A _1 million_ random strings with _1 in a billion_ chance of repeat:

  ```swift
  var random = Random()
  var bits = Entropy.bits(for: 1.0e6, risk: 1.0e9)
  var string = random.string(bits: bits)
  ```

  > 2tF6bMNPqQ82Qj

`EntropyString` uses predefined `charset32` characters by default (reference [Character Sets](#CharacterSets)). To get a random hexadecimal string with the same entropy bits as above (see [Real Need](#RealNeed) for description of what entropy bits represents):

  ```swift
  random.use(.charset16)
  string = random.string(bits: bits)
  ```

  > a946ff97a1c4e64e79

Custom characters may be specified. Using uppercase hexadecimal characters:

  ```swift
  try! random.use("0123456789ABCDEF")
  string = random.string(bits: bits)
  ```

  > 78E3ACABE544EBA7DF

Convenience functions exists for a variety of random string needs. For example, to create OWASP session ID:

  ```swift
  string = random.sessionID()
  ```

  > CC287C99158BF152DF98AF36D5E92AE3

Or a 256 bit token using [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5) file system and URL safe characters:
  ```swift
  string = random.token(.charSet64)
  ```

  > X2AZRHuNN3mFUhsYzHSE_r2SeZJ_9uqdw-j9zvPqU2O

[TOC](#TOC)

### <a name="Overview"></a>Overview

`EntropyString` provides easy creation of randomly generated strings of specific entropy using various character sets. Such strings are needed when generating, for example, random IDs and you don't want the overkill of a GUID, or for ensuring that some number of items have unique identifiers.

A key concern when generating such strings is that they be unique. To truly guarantee uniqueness requires either deterministic generation (e.g., a counter) that is not random, or that each newly created random string be compared against all existing strings. When ramdoness is required, the overhead of storing and comparing all strings is often too onerous and a different tack is needed.

A common strategy is to replace the *guarantee of uniqueness* with a weaker but often sufficient *probabilistic uniqueness*. Specifically, rather than being absolutely sure of uniqueness, we settle for a statement such as *"there is less than a 1 in a billion chance that two of my strings are the same"*. This strategy requires much less overhead, but does require we have some manner of qualifying what we mean by, for example, *"there is less than a 1 in a billion chance that 1 million strings of this form will have a repeat"*.

Understanding probabilistic uniqueness requires some understanding of [*entropy*](https://en.wikipedia.org/wiki/Entropy_(information_theory)) and of estimating the probability of a [*collision*](https://en.wikipedia.org/wiki/Birthday_problem#Cast_as_a_collision_problem) (i.e., the probability that two strings in a set of randomly generated strings might be the same).  Happily, you can use `EntropyString` without a deep understanding of these topics.

We'll begin investigating `EntropyString` by considering our [Real Need](Read%20Need) when generating random strings.

[TOC](#TOC)

### <a name="RealNeed"></a>Real Need

Let's start by reflecting on a common statement of need for developers, who might say:

*I need random strings 16 characters long.*

Okay. There are libraries available that address that exact need. But first, there are some questions that arise from the need as stated, such as:

  1. What characters do you want to use?
  2. How many of these strings do you need?
  3. Why do you need these strings?

The available libraries often let you specify the characters to use. So we can assume for now that question 1 is answered with:

*Hexadecimal will do fine*.

As for question 2, the developer might respond:

*I need 10,000 of these things*.

Ah, now we're getting somewhere. The answer to question 3 might lead to the further qualification:

*I need to generate 10,000 random, unique IDs*.

And the cat's out of the bag. We're getting at the real need, and it's not the same as the original statement. The developer needs *uniqueness* across a potential total of some number of strings. The length of the string is a by-product of the uniqueness, not the goal.

As noted in the [Overview](Overview), guaranteeing uniqueness is difficult, so we'll replace that declaration with one of *probabilistic uniqueness* by asking:

  - What risk of a repeat are you willing to accept?

Probabilistic uniqueness contains risk. That's the price we pay for giving up on the stronger declaration of strict uniqueness. But the developer can quantify an appropriate risk for a particular scenario with a statement like:

*I guess I can live with a 1 in a million chance of a repeat*.

So now we've gotten to the developer's real need:

*I need 10,000 random hexadecimal IDs with less than 1 in a million chance of any repeats*.

Not only is this statement more specific, there is no mention of string length. The developer needs probabilistic uniqueness, and strings are to be used to capture randomness for this purpose. As such, the length of the string is simply a by-product of the encoding used to represent the required uniqueness as a string.

How do you address this need using a library designed to generate strings of specified length?  Well, you don't directly, because that library was designed to answer the originally stated need, not the real need we've uncovered. We need a library that deals with probabilistic uniqueness of a total number of some strings. And that's exactly what `EntropyString` does.

Let's use `EntropyString` to help this developer by generating 5 IDs:

  ```swift
  import EntropyString

  let random = Random(.charSet16)
  let bits = Entropy.bits(for: 10000, risk: 1.0e6)
  var strings = [String]()
  for i in 0 ..< 5 {
    let string = random.string(bits: bits)
    strings.append(string)
  }
  print("Strings: \(strings)")
  ```

  > Strings: ["85e442fa0e83", "a74dc126af1e", "368cd13b1f6e", "81bf94e1278d", "fe7dec099ac9"]

To generate the IDs, we first use

  ```swift
  let bits = Entropy.bits(for: 10000, risk: 1.0e6)
  ```

to determine how much entropy  is needed to satisfy the probabilistic uniqueness of a **1 in a million** (ten to the sixth power) risk of repeat in a total of **10,000** strings. We didn't print the result, but if you did you'd see it's about **45.51** bits. Then inside a loop we used

  ```swift
  let string = random.string(bits: bits)
  ```

to actually generate the random strings of the specified entropy using hexadecimal (charSet16) characters. Looking at the IDs, we can see each is 12 characters long. Again, the string length is a by-product of the characters used to represent the entropy we needed. And it seems the developer didn't really need 16 characters after all.

Finally, given that the strings are 12 hexadecimals long, each string actually has an information carrying capacity of 12 * 4 = 48 bits of entropy (a hexadecimal character carries 4 bits). That's fine. Assuming all characters are equally probable, a string can only carry entropy equal to a multiple of the amount of entropy represented per character. `EntropyString` produces the smallest strings that *exceed* the specified entropy.

[TOC](#TOC)

### <a name="MoreExamples"></a>More Examples

In [Real Need](#RealNeed) our developer used hexadecimal characters for the strings.  Let's look at using other characters instead.

We'll start with using 32 characters. What 32 characters, you ask? The [Character Sets](#CharacterSets) section discusses the predefined characters available in `EntropyString` and the [Custom Characters](#CustomCharacters) section describes how you can use whatever characters you want. By default, `EntropyString` uses `charSet32` characters, so we don't need to pass that parameter into `Random()`.
  ```swift
  import EntropyString

  let random = Random()
  var bits = Entropy.bits(for: 10000, risk: 1.0e6)
  var string = random.string(bits: bits, using: .charSet32)

  print("String: \(string)\n")
  ```

  > String: PmgMJrdp9h

We're using the same __bits__ calculation since we haven't changed the number of IDs or the accepted risk of probabilistic uniqueness. But this time we use 32 characters and our resulting ID only requires 10 characters (and can carry 50 bits of entropy).

As another example, let's assume we need to ensure the names of a handful of items are unique. `EntropyString.smallID` yields strings that have a 1 in a million chance of repeat in 30 strings.

  ```swift
  string = random.smallID()

  print("String: \(string)\n")
  ```

  > String: ThfLbm

Using the same `Random` instance, we can switch to the default `charSet4` characters:

  ```swift
  random.use(charSet: .charSet64)
  string = random.smallID()
  print("String: \(string)\n")
  ```

  > String: CCCCTCAGGCATAGG

Okay, we probably wouldn't use 4 characters (and what's up with those characters?), but you get the idea.

Suppose we have a more extreme need. We want less than a 1 in a trillion chance that 10 billion strings repeat. Let's see, our risk (trillion) is 10 to the 12th and our total (10 billion) is 10 to the 10th, so:

  ```swift
  random.use(.charSet32)
  bits = Entropy.bits(for: 1.0e10, risk: 1.0e12)
  string = random.string(bits: bits)
  ```

   > String: F78PmfGRNfJrhHGTqpt6Hn

Finally, let say we're generating session IDs. We're not interested in uniqueness per se, but in ensuring our IDs aren't predicatable since we can't have the bad guys guessing a valid session ID. In this case, we're using entropy as a measure of unpredictability of the IDs. Rather than calculate our entropy, we declare it needs to be 128 bits (since we read on the OWASP web site that session IDs should be 128 bits).

  ```swift
  string = random.sessionID(.charSet64)
  ```

  > String: b0Gnh6H5cKCjWrCLwKoeuN

Using 64 characters, our string length is 22 characters. That's actually `22*6 = 132` bits, so we've got our OWASP requirement covered! 😌

Also note that we covered our need using strings that are only 22 characters in length. So long to using GUID strings which only carry 122 bits of entropy (commonly used version 4) and use string representations that are 36 characters long (hex with dashes).

[TOC](#TOC)

### <a name="CharacterSets"></a>Character Sets

As we\'ve seen in the previous sections, `EntropyString` provides predefined characters for each of the supported character sets. Let\'s see what\'s under the hood. The available `CharSet`s are *.charSet64*, *.charSet32*, *.charSet16*, *.charSet8*, *.charSet4* and *.charSet2*.

  ```swift
  import EntropyString

  print("CharSet 64: \(RandomString.characters(for: .charSet64))\n")
  print("CharSet 32: \(RandomString.characters(for: .charSet32))\n")
  print("CharSet 16: \(RandomString.characters(for: .charSet16))\n")
  print("CharSet  8: \(RandomString.characters(for: .charSet8))\n")
  print("CharSet  4: \(RandomString.characters(for: .charSet4))\n")
  print("CharSet  2: \(RandomString.characters(for: .charSet2))\n")
  ```

The characters for each were chosen as follows:

  - CharSet 64: **ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz0123456789-_**
      * The file system and URL safe char set from [RFC 4648](https://tools.ietf.org/html/rfc4648#section-5).
  - CharSet 32: **2346789bdfghjmnpqrtBDFGHJLMNPQRT**
      * Remove all upper and lower case vowels (including y)
      * Remove all numbers that look like letters
      * Remove all letters that look like numbers
      * Remove all letters that have poor distinction between upper and lower case values.
      The resulting strings don't look like English words and are easy to parse visually.

  - CharSet 16: **0123456789abcdef**
      * Hexadecimal
  - CharSet  8: **01234567**
      * Octal
  - CharSet  4: **ATCG**
      * DNA alphabet. No good reason; just wanted to get away from the obvious.
  - CharSet  2: **01**
      * Binary

You may, of course, want to choose the characters used, which is covered next in [Custom Characters](#CustomCharacters).

[TOC](#TOC)

### <a name="CustomCharacters"></a>Custom Characters

Being able to easily generate random strings is great, but what if you want to specify your own characters? For example, suppose you want to visualize flipping a coin to produce 10 bits of entropy.

  ```swift
  import EntropyString

  let randomString = RandomString()
  var flips = randomString.entropy(of: 10, using: .charSet2)
  print("flips: \(flips)\n")
  ```

  > flips: 0101001110

The resulting string of __0__'s and __1__'s doesn't look quite right. Perhaps you want to use the characters __H__ and __T__ instead.

  ```swift
  try! randomString.use("HT", for: .charSet2)
  flips = randomString.entropy(of: 10, using: .charSet2)
  print("flips: \(flips)\n")
  ```

  > flips: HTTTHHTTHH

As another example, we saw in [Character Sets](#CharacterSets) the predefined characters for `charSet16` are **0123456789abcdef**. Suppose you like uppercase hexadecimal letters instead.

  ```swift
  try! randomString.use("0123456789ABCDEF", for: .charSet16)
  let hex = randomString.entropy(of: 48, using: .charSet16)
  print("hex: \(hex)\n")
  ```

  > hex: 4D20D9AA862C

The `Random` constructor allows for three separate cases:

  - No argument defauls to the `charSet32` characters.
  - One of six default `CharSet`s can be specified.
  - A string representing the characters to use can be specified.
    
The 3rd option above will throw an `EntropyStringError` if the characters string isn't appropriate for creating a `CharSet`.
  ```swift
  do {
    try random.use("abcdefg")
  }
  catch {
    print(error)
  }
  ```
  > invalidCharCount

  ```swift
  do {
    try random.use("01233210")
  }
  catch {
    print(error)
  }
  ```
  
  > charsNotUnique

[TOC](#TOC)

### <a name="Efficiency"></a>Efficiency

To efficiently create random strings, `EntropyString` generates the necessary number of random bytes needed for each string and uses those bytes in a bit shifting scheme to index into a character set. For example, to generate strings from the __32__ characters in the *charSet32* character set, each index needs to be in the range `[0,31]`. Generating a random string of *charSet32* characters is thus reduced to generating a random sequence of indices in the range `[0,31]`.

To generate the indices, `EntropyString` slices just enough bits from the random bytes to create each index. In the example at hand, 5 bits are needed to create an index in the range `[0,31]`. `EntropyString` processes the bytes 5 bits at a time to create the indices. The first index comes from the first 5 bits of the first byte, the second index comes from the last 3 bits of the first byte combined with the first 2 bits of the second byte, and so on as the bytes are systematically sliced to form indices into the character set. And since bit shifting and addition of byte values is really efficient, this scheme is quite fast.

The `EntropyString` scheme is also efficient with regard to the amount of randomness used. Consider the following common Swift solution to generating random strings. To generated a character, an index into the available characters is create using `arc4random_uniform`. The code looks something like:

  ```swift
  for _ in 0 ..< len {
    let offset = Int(arc4random_uniform(charCount))
    let index = chars.index(chars.startIndex, offsetBy: offset)
    let char = chars[index]
    string += String(char)
  }
  ```

In the code above, `arc4random_uniform` generates 32 bits of randomness per call, returned as an `UInt32`. The returned value is used to create **index**. Suppose we're creating strings with **len=16** and **charCount=32**. Each **char** consumes 32 bits of randomness (`UInt32`) while only injecting 5 bits (`log2(32)`) of entropy into **string**. The resulting string has an information carrying capacity of 80 bits. So creating each **string** requires a *total* of 512 bits of randomness while only actually *carrying* 80 bits of that entropy forward in the string itself. That means 432 bits (84% of the total) of the generated randomness is simply wasted.

Compare that to the `EntropyString` scheme. For the example above, slicing off 5 bits at a time requires a total of 80 bits (10 bytes). Creating the same strings as above, `EntropyString` uses 80 bits of randomness per string with no wasted bits. In general, the `EntropyString` scheme can waste up to 7 bits per string, but that's the worst case scenario and that's *per string*, not *per character*!

Fortunately you don't need to really understand how the bytes are efficiently sliced and diced to get the string. But you may want to know that [Secure Bytes](#SecureBytes) are used, and that's the next topic.

[TOC](#TOC)

### <a name="SecureBytes"></a>Secure Bytes

As described in [Efficiency](#Efficiency), `EntropyString` uses an underlying array of bytes to generate strings. The entropy of the resulting strings is, of course, directly related to the randomness of the bytes used. That's an important point. Strings are only capable of carrying information (entropy); random bytes actually provide the entropy itself.

`EntropyString` automatically generates the necessary number of bytes needed to create a random string. On Apple OSes, `EntropyString` uses either `SecRandomCopyBytes` or `arc4random_buf`, both of which are cryptographically secure random number generators. `SecRandomCopyBytes` is the stronger of the two, but can fail if the system entropy pool lacks sufficient randomness. Rather than propagate that failure, if `SecRandomCopyBytes` fails `EntropyString` falls back and uses `arc4random_buf` to generate the bytes. Though not as strong, `arc4random_buf` does not fail.

You may, of course, want feedback as to when or if `SecRandomCopyBytes` fails. `RandomString.entropy(of:using:secRand)` provides an additional `inout` parameter that acts as a flag should a `SecRandomCopyBytes` call fail.

On Linux OSes, `EntropyString` always uses `arc4random_buf`. The `secRand` parameter is ignored.


  ```swift
  import EntropyString

  let random = Random()
  var secRand = true
  random.string(bits: 20, secRand: &secRand)
  ```

  > secRand: true

If `SecRandomCopyBytes` is used, the __secRand__ parameter will remain `true`; otherwise it will be set to `false`.

You can also pass in __secRand__ as `false`, in which case the `entropy` call will not attempt to use `SecRandomCopyBytes` and will use `arc4random_buf` instead.

  ```swift
  secRand = false
  RandomString.entropy(of: 20, using: .charSet32, secRand: &secRand)
  ```

Rather than have `EntropyString` generate bytes automatically, you can provide your own [Custom Bytes](#CustomBytes) to create a string, which is the next topic.

[TOC](#TOC)

### <a name="CustomBytes"></a>Custom Bytes

As described in [Secure Bytes](#SecureBytes), `EntropyString` automatically generates random bytes using either `SecRandomCopyBuf` or `arc4random_buf`. These functions are fine, but you may have a need to provide your own btyes for deterministic testing or to use a specialized byte generator. The function `random.string(bits:using)` allows specifying your own bytes to create a string.

Suppose we want a string capable of 30 bits of entropy using 32 characters. We pass in 4 bytes (to cover the 30 bits):

  ```swift
  import EntropyString

  let bytes: RandomString.Bytes = [250, 200, 150, 100]
  let string = try! RandomString.entropy(of: 30, using: .charSet32, bytes: bytes)
  print("String: \(string)\n")
  ```

  > string: Th7fjL
 
The __bytes__ provided can come from any source. However, if the number of bytes is insufficient to generate the string as described in the [Efficiency](#Efficiency) section, an `EntropyStringError.tooFewBytes` is thrown.

  ```swift
  do {
    let random = Random()
    try random.string(bits: 32, using: bytes)
  }
  catch {
    print(error)
  }
  ```

  > error: tooFewBytes

Note the number of bytes needed is dependent on the number of characters in our set. In using a string to represent entropy, we can only have multiples of the bits of entropy per character used. So in the example above, to get at least 32 bits of entropy using a character set of 32 characters (5 bits per char), we'll need enough bytes to cover 35 bits, not 32, so a `tooFewBytes` error is thrown.

[TOC](#TOC)

### <a name="TLDR2"></a>TL;DR 2

#### Take Away

  - You don't need random strings of length L.
    - String length is a by-product, not a goal.
  - You don't need truly unique strings.
    - Uniqueness is too onerous. You'll do fine with probabilistically unique strings.
  - Probabilistic uniqueness involves measured risk.
    - Risk is measured as *"1 in __n__ chance of generating a repeat"*
    - Bits of entropy gives you that measure.
  - You need to a total of **_N_** strings with a risk **_1/n_** of repeat.
    - The characters are arbitrary.
  - You need `EntropyString`.
  
##### Base 32 character string with a 1 in a million chance of a repeat a billion strings:
```swift
  import EntropyString

  let random = Random()
  let bits = Entropy.bits(for: 1.0e6, risk: 1.0e9)
  let string = random.string(bits: bits)
```

  > DdHrT2NdrHf8tM
  
[TOC](#TOC)
