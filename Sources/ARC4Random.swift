//
//  ARC4Random.swift
//  RandomKit
//
//  The MIT License (MIT)
//
//  Copyright (c) 2015-2017 Nikolai Vazquez
//
//  Permission is hereby granted, free of charge, to any person obtaining a copy
//  of this software and associated documentation files (the "Software"), to deal
//  in the Software without restriction, including without limitation the rights
//  to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
//  copies of the Software, and to permit persons to whom the Software is
//  furnished to do so, subject to the following conditions:
//
//  The above copyright notice and this permission notice shall be included in
//  all copies or substantial portions of the Software.
//
//  THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
//  IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
//  FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
//  AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
//  LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
//  OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
//  THE SOFTWARE.
//

import Foundation

/// A generator that uses `arc4random()` and friends.
///
/// If the OS is Linux, Android, or Windows, the relevant functions will be attempted to be dynamically loaded.
public final class ARC4Random {

  /// A default global instance.
  public static var `default` = ARC4Random()
  
  private init() {}
  
  /// Randomizes the contents of `buffer` up to `size`.
  public func randomize(buffer: UnsafeMutableRawPointer, size: Int) {
    _arc4random_buf(buffer, size)
  }
}

#if os(Linux) || os(Android) || os(Windows)

private func _load<T>(symbol: String) -> T? {
  guard let handle = dlopen(nil, RTLD_NOW) else { return nil }
  defer { dlclose(handle) }
  guard let result = dlsym(handle, symbol) else { return nil }
  return unsafeBitCast(result, to: T.self)
}

private typealias _Arc4random_buf = @convention(c) (ImplicitlyUnwrappedOptional<UnsafeMutableRawPointer>, Int) -> ()

private let _a4r_buf: _Arc4random_buf? = _load(symbol: "arc4random_buf")

#endif

/// Performs `arc4random_buf` if OS is not Linux, Android, or Windows. Otherwise it'll try
/// getting the handle for `arc4random_buf` and use the result if successful.
private func _arc4random_buf(_ buffer: UnsafeMutableRawPointer!, _ size: Int) {
    #if !os(Linux) && !os(Android) && !os(Windows)
        arc4random_buf(buffer, size)
    #else
        _a4r_buf?(buffer, size)
    #endif
}
