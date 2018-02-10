//
// String+Extensions.swift
//
// Copyright © 2014 Zeeshan Mian
//
// Permission is hereby granted, free of charge, to any person obtaining a copy
// of this software and associated documentation files (the "Software"), to deal
// in the Software without restriction, including without limitation the rights
// to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
// copies of the Software, and to permit persons to whom the Software is
// furnished to do so, subject to the following conditions:
//
// The above copyright notice and this permission notice shall be included in
// all copies or substantial portions of the Software.
//
// THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
// IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
// FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
// AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
// LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
// OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN
// THE SOFTWARE.
//

import Foundation

extension String {
    /// var string = "abcde"[r: 0...2] // string equals "abc"
    /// var string2 = "fghij"[r: 2..<4] // string2 equals "hi"
    public subscript(r: Range<Int>) -> String {
        let start = index(startIndex, offsetBy: r.lowerBound)
        let end = index(startIndex, offsetBy: r.upperBound)
        return substring(with: Range(start..<end))
    }

    public var capitalizeFirstCharacter: String {
        return String(prefix(1).capitalized + dropFirst())
    }

    public var urlEscaped: String? {
        return addingPercentEncoding(withAllowedCharacters: .urlHostAllowed)
    }

    /// Returns an array of strings at new lines.
    public var lines: [String] {
        return components(separatedBy: .newlines)
    }

    /// Normalize multiple whitespaces and trim whitespaces and new line characters in `self`.
    public func trimmed() -> String {
        return replace("[ ]+", with: " ").trimmingCharacters(in: .whitespacesAndNewlines)
    }

    /// Searches for pattern matches in the string and replaces them with replacement.
    public func replace(_ pattern: String, with: String, options: NSString.CompareOptions = .regularExpression) -> String {
        return replacingOccurrences(of: pattern, with: with, options: options, range: nil)
    }

    /// Trim whitespaces from start and end and normalize multiple whitespaces into one and then replace them with the given string.
    public func replaceWhitespaces(with string: String) -> String {
        return trimmingCharacters(in: .whitespaces).replace("[ ]+", with: string)
    }

    /// Returns `true` iff `value` is in `self`.
    public func contains(_ value: String, options: NSString.CompareOptions = []) -> Bool {
        return range(of: value, options: options) != nil
    }

    /// Determine whether the string is a valid url.
    public var isValidUrl: Bool {
        if let url = URL(string: self), url.host != nil {
            return true
        }

        return false
    }

    /// `true` iff `self` contains no characters and blank spaces (e.g., \n, " ").
    public var isBlank: Bool {
        return trimmingCharacters(in: .whitespacesAndNewlines).isEmpty
    }

    /// Drops the given `prefix` from `self`.
    ///
    /// - returns: String without the specified `prefix` or nil if `prefix` doesn't exists.
    public func stripPrefix(_ prefix: String) -> String? {
        guard let prefixRange = range(of: prefix) else { return nil }
        let attributeRange = Range(prefixRange.upperBound..<endIndex)
        let attributeString = substring(with: attributeRange)
        return attributeString
    }

    /// Take last `x` characters from `self`.
    public func take(last: Int) -> String {
        guard count >= last else {
            return self
        }

        return String(dropFirst(count - last))
    }
}

// MARK: NSString

extension String {
    private var nsString: NSString {
        return self as NSString
    }

    public var lastPathComponent: String {
        return nsString.lastPathComponent
    }

    public var stringByDeletingLastPathComponent: String {
        return nsString.deletingLastPathComponent
    }

    public var stringByDeletingPathExtension: String {
        return nsString.deletingPathExtension
    }

    public var pathExtension: String {
        return nsString.pathExtension
    }
}

extension String {
    // Credit: https://stackoverflow.com/a/27880748

    /// Returns an array of strings matching the given regular expression.
    public func regex(_ pattern: String) -> [String] {
        do {
            let regex = try NSRegularExpression(pattern: pattern, options: [])
            let results = regex.matches(in: self, range: NSRange(startIndex..., in: self))
            let nsString = self as NSString
            return results.map {
                nsString.substring(with: $0.range)
            }
        } catch let error {
            #if DEBUG
            print("Invalid regex: \(error.localizedDescription)")
            #endif
            return []
        }
    }

    public func isMatch(_ pattern: String) -> Bool {
        return !regex(pattern).isEmpty
    }
}

// MARK: Localization

extension String {
    // TODO: Add more customization to use these methods instead of secondary library
    fileprivate var localized: String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: "")
    }

    fileprivate func localized(_ comment: String) -> String {
        return NSLocalizedString(self, tableName: nil, bundle: .main, value: "", comment: comment)
    }
}

// MARK: Base64 Support

extension String {
    /// Decode specified `Base64` string
    public init?(base64: String) {
        guard
            let decodedData = Data(base64Encoded: base64),
            let decodedString = String(data: decodedData, encoding: .utf8)
        else { return nil }
        self = decodedString
    }

    /// Returns `Base64` representation of `self`.
    public var base64: String? {
        return data(using: .utf8)?.base64EncodedString()
    }
}

extension String {
    public func size(withFont font: UIFont) -> CGSize {
        return (self as NSString).size(withAttributes: [.font: font])
    }

    public func size(withFont font: UIFont, constrainedToSize: CGSize) -> CGSize {
        let expectedRect = (self as NSString).boundingRect(
            with: constrainedToSize,
            options: .usesLineFragmentOrigin,
            attributes: [.font: font],
            context: nil
        )

        return expectedRect.size
    }

    /// - seealso: http://stackoverflow.com/a/30040937
    public func numberOfLines(_ font: UIFont, constrainedToSize: CGSize) -> (size: CGSize, numberOfLines: Int) {
        let textStorage = NSTextStorage(string: self, attributes: [.font: font])

        let textContainer = NSTextContainer(size: constrainedToSize)
        textContainer.lineBreakMode = .byWordWrapping
        textContainer.maximumNumberOfLines = 0
        textContainer.lineFragmentPadding = 0

        let layoutManager = NSLayoutManager()
        layoutManager.textStorage = textStorage
        layoutManager.addTextContainer(textContainer)

        var numberOfLines = 0
        var index = 0
        var lineRange = NSRange(location: 0, length: 0)
        var size = CGSize.zero

        while index < layoutManager.numberOfGlyphs {
            numberOfLines += 1
            size += layoutManager.lineFragmentRect(forGlyphAt: index, effectiveRange: &lineRange).size
            index = NSMaxRange(lineRange)
        }

        return (size, numberOfLines)
    }
}
