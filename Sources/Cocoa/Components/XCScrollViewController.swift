//
// XCScrollViewController.swift
//
// Copyright © 2015 Zeeshan Mian
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

open class XCScrollViewController: UIViewController {
    public let scrollView = UIScrollView()

    open override func viewDidLoad() {
        super.viewDidLoad()
        setupContentView()
    }

    /// An option to determine whether the scroll view top and bottom
    /// is constrained to top and bottom safe areas.
    ///
    /// The default value is `[]`.
    open var pinnedToSafeAreaLayoutGuides: SafeAreaLayoutGuideOptions {
        return []
    }

    private func setupContentView() {
        view.addSubview(scrollView)
        constraintsForViewToFillSuperview(
            scrollView,
            constraintToLayoutGuideOptions: pinnedToSafeAreaLayoutGuides
        ).activate()
        resolveContentSize()
    }

    private func resolveContentSize() {
        let scrollViewWidthResolver = UIView()
        scrollViewWidthResolver.isHidden = true
        scrollView.addSubview(scrollViewWidthResolver)
        NSLayoutConstraint.constraintsForViewToFillSuperviewHorizontal(scrollViewWidthResolver).activate()
        NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .top, toItem: scrollView).activate()
        NSLayoutConstraint(item: scrollViewWidthResolver, height: 1).activate()

        // Now the important part
        // Setting the `scrollViewWidthResolver` width to `self.view` width correctly defines the content width of the scroll view
        NSLayoutConstraint(item: scrollViewWidthResolver, attribute: .width, toItem: view).activate()
    }
}
