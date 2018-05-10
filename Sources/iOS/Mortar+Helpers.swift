/*

 MIT License

 Copyright (c) 2016 Maxim Khatskevich (maxim@khatskevi.ch)

 Permission is hereby granted, free of charge, to any person obtaining a copy
 of this software and associated documentation files (the "Software"), to deal
 in the Software without restriction, including without limitation the rights
 to use, copy, modify, merge, publish, distribute, sublicense, and/or sell
 copies of the Software, and to permit persons to whom the Software is
 furnished to do so, subject to the following conditions:

 The above copyright notice and this permission notice shall be included in all
 copies or substantial portions of the Software.

 THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
 IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
 FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT. IN NO EVENT SHALL THE
 AUTHORS OR COPYRIGHT HOLDERS BE LIABLE FOR ANY CLAIM, DAMAGES OR OTHER
 LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE, ARISING FROM,
 OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR OTHER DEALINGS IN THE
 SOFTWARE.

 */

import UIKit

import Mortar

import XCEViewExt

//---

infix operator <</ : AddSubviewsPrecendence

/**
 Use this operator to define subviews hierarchy.
 */
@discardableResult
public
func <</ (lhs: MortarView, rhs: MortarView) -> MortarView
{
    return lhs <</ [rhs]
}

/**
 Use this operator to define subviews hierarchy.
 */
@discardableResult
public
func <</ (lhs: MortarView, rhs: [MortarView]) -> MortarView
{
    // NOTE: for better injection support,
    // we completely reset (replace) subviews, not adding!
    lhs.subviews.forEach{ $0.removeFromSuperview() }

    //---

    Utils.debug
    {
        ([lhs] + rhs).forEach{ Utils.styleForDebug($0) }
    }

    //---

    return lhs |+| rhs
}

/**
 Use this operator to define subviews hierarchy.
 */
@discardableResult
public
func <</ (toolbar: UIToolbar, items: [UIBarButtonItem]) -> UIToolbar
{
    // NOTE: for better injection support,
    // we completely reset (replace) items, not adding!
    toolbar.items = items
    
    //---
    
    return toolbar
}

/**
 Use this operator to define subviews hierarchy.
 */
@discardableResult
public
func <</ (stack: UIStackView, elements: [UIView]) -> UIStackView
{
    // NOTE: for better injection support,
    // we completely reset (replace) subviews, not adding!
    stack.arrangedSubviews.forEach{ stack.removeArrangedSubview($0) }

    //---

    Utils.debug
    {
        ([stack] + elements).forEach{ Utils.styleForDebug($0) }
    }

    //---
    
    elements.forEach{ stack.addArrangedSubview($0) }
    
    //---
    
    return stack
}

//---

public
extension UIView
{
    enum AnchorDescriptor
    {
        // potentially can be replaced by MortarLayoutAttribute if made public
        // https://github.com/jmfieldman/Mortar#attributes

        case
            left, right,
            top, bottom,
            leading, trailing,
            width, height,
            centerX, centerY,
            baseline

        #if os(iOS) || os(tvOS)

        case
            firstBaseline,
            leftMargin, rightMargin,
            topMargin, bottomMargin,
            leadingMargin, trailingMargin,
            centerXWithinMargin, centerYWithinMargin

        #endif

        case
            sides,
            caps,
            size,
            center,
            edges,
            frame
    }

    /**
     Little helper that allows to access multiple 'm_*' properties at once.
     */
    // swiftlint:disable cyclomatic_complexity
    func anchors(_ list: AnchorDescriptor...) -> [MortarAttribute]
    {
        return list.map
        {
            switch $0
            {
                case .left: return m_left
                case .right: return m_right
                case .top: return m_top
                case .bottom: return m_bottom
                case .leading: return m_leading
                case .trailing: return m_trailing
                case .width: return m_width
                case .height: return m_height
                case .centerX: return m_centerX
                case .centerY: return m_centerY
                case .baseline: return m_baseline

                case .firstBaseline: return m_firstBaseline
                case .leftMargin: return m_leftMargin
                case .rightMargin: return m_rightMargin
                case .topMargin: return m_topMargin
                case .bottomMargin: return m_bottomMargin
                case .leadingMargin: return m_leadingMargin
                case .trailingMargin: return m_trailingMargin
                case .centerXWithinMargin: return m_centerXWithinMargin
                case .centerYWithinMargin: return m_centerYWithinMargin

                case .sides: return m_sides
                case .caps: return m_caps
                case .size: return m_size
                case .center: return m_center
                case .edges: return m_edges
                case .frame: return m_frame
            }
        }
    }
    // swiftlint:enable cyclomatic_complexity
}
