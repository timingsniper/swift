//===----------------------------------------------------------------------===//
//
// This source file is part of the Swift.org open source project
//
// Copyright (c) 2014 - 2017 Apple Inc. and the Swift project authors
// Licensed under Apache License v2.0 with Runtime Library Exception
//
// See https://swift.org/LICENSE.txt for license information
// See https://swift.org/CONTRIBUTORS.txt for the list of Swift project authors
//
//===----------------------------------------------------------------------===//

extension String.Index {
  /// Creates an index in the given string that corresponds exactly to the
  /// specified `UnicodeScalarView` position.
  ///
  /// The following example converts the position of the Unicode scalar `"e"`
  /// into its corresponding position in the string. The character at that
  /// position is the composed `"é"` character.
  ///
  ///     let cafe = "Cafe\u{0301}"
  ///     print(cafe)
  ///     // Prints "Café"
  ///
  ///     let scalarsIndex = cafe.unicodeScalars.index(of: "e")!
  ///     let stringIndex = String.Index(scalarsIndex, within: cafe)!
  ///
  ///     print(cafe[...stringIndex])
  ///     // Prints "Café"
  ///
  /// If the position passed in `unicodeScalarIndex` doesn't have an exact
  /// corresponding position in `other`, the result of the initializer is
  /// `nil`. For example, an attempt to convert the position of the combining
  /// acute accent (`"\u{0301}"`) fails. Combining Unicode scalars do not have
  /// their own position in a string.
  ///
  ///     let nextIndex = String.Index(cafe.unicodeScalars.index(after: scalarsIndex),
  ///                                  within: cafe)
  ///     print(nextIndex)
  ///     // Prints "nil"
  ///
  /// - Parameters:
  ///   - sourcePosition: A position in (a view of) the `other` parameter.
  ///   - target: The string referenced by both `unicodeScalarIndex` and the
  ///     resulting index.
  public init?(
    _ sourcePosition: String.Index,
    within target: String
  ) {
    guard target.unicodeScalars._isOnGraphemeClusterBoundary(sourcePosition)
    else { return nil }

    self = target.characters._index(
      atEncodedOffset: sourcePosition.encodedOffset)
  }

  /// Returns the position in the given UTF-8 view that corresponds exactly to
  /// this index.
  ///
  /// The index must be a valid index of `String(utf8)`.
  ///
  /// This example first finds the position of the character `"é"` and then uses
  /// this method find the same position in the string's `utf8` view.
  ///
  ///     let cafe = "Café"
  ///     if let i = cafe.index(of: "é") {
  ///         let j = i.samePosition(in: cafe.utf8)
  ///         print(Array(cafe.utf8[j...]))
  ///     }
  ///     // Prints "[195, 169]"
  ///
  /// - Parameter utf8: The view to use for the index conversion.
  /// - Returns: The position in `utf8` that corresponds exactly to this index.
  public func samePosition(
    in utf8: String.UTF8View
  ) -> String.UTF8View.Index? {
    return String.UTF8View.Index(self, within: utf8)
  }

  /// Returns the position in the given UTF-16 view that corresponds exactly to
  /// this index.
  ///
  /// The index must be a valid index of `String(utf16)`.
  ///
  /// This example first finds the position of the character `"é"` and then uses
  /// this method find the same position in the string's `utf16` view.
  ///
  ///     let cafe = "Café"
  ///     if let i = cafe.index(of: "é") {
  ///         let j = i.samePosition(in: cafe.utf16)
  ///         print(cafe.utf16[j])
  ///     }
  ///     // Prints "233"
  ///
  /// - Parameter utf16: The view to use for the index conversion.
  /// - Returns: The position in `utf16` that corresponds exactly to this index.
  public func samePosition(
    in utf16: String.UTF16View
  ) -> String.UTF16View.Index? {
    return String.UTF16View.Index(self, within: utf16)
  }
}

