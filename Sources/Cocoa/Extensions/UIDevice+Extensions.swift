//
// UIDevice+Extensions.swift
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

import UIKit
import LocalAuthentication

extension UIDevice {
    public struct SystemVersion {
        public static let iOS8OrGreater = floor(NSFoundationVersionNumber) > floor(NSFoundationVersionNumber_iOS_7_0)
        public static let iOS7OrLess = floor(NSFoundationVersionNumber) <= floor(NSFoundationVersionNumber_iOS_7_0)

        public static func lessThanOrEqual(_ string: String) -> Bool {
            return UIDevice.current.systemVersion.compare(string, options: .numeric) == .orderedAscending
        }

        public static func greaterThanOrEqual(_ string: String) -> Bool {
            return !lessThanOrEqual(string)
        }

        public static func equal(_ string: String) -> Bool {
            return UIDevice.current.systemVersion.compare(string, options: .numeric) == .orderedSame
        }
    }
}
