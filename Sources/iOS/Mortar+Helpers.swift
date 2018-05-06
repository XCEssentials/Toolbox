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

/**
 Use this operator to define individual subview layout settings.
 */
@discardableResult
public
func <</ <T: UIView>(object: T, handler: (T) -> Void) -> T
{
    object.resetLayout()

    //---

    return object </ handler
}

/**
 Use this operator to define multiple subviews layout settings at once.
 */
@discardableResult
public
func <</ <T: UIView>(objects: [T], handler: (T) -> Void) -> [T]
{
    objects.forEach
    {
        $0.resetLayout()
        $0 </ handler
    }

    //---

    return objects
}

public
extension UIView
{
    /**
     This allows to reset all PUBLIC constraints between
     given view and any outer views,
     but retain any constraints added by the system (such as
     any intrinsic constraints), as well as internal constraints.
     See more: http://apprize.info/apple/ios_6/3.html
     */
    func resetLayout()
    {
        let allSubs = allSubviews()

        constraints
            .filter{ $0.isMember(of: NSLayoutConstraint.self) } // Public only!
            .filter
            {
                if
                    // if first item is UIView
                    let first = $0.firstItem as? UIView,
                    // we have to make sure it's not one of the subvies
                    allSubs.contains(first)
                {
                    return NO
                }
                else
                if
                    // if second item is UIView
                    let second = $0.secondItem as? UIView,
                    // we have to make sure it's not one of the subvies
                    allSubs.contains(second)
                {
                    return NO
                }
                else
                {
                    return YES // include this constraint in final set
                }
            }
            .forEach{ $0.isActive = NO }
    }
}

public
extension Array where Element: UIView
{
    func resetLayout()
    {
        self.forEach{ $0.resetLayout() }
    }
}

//---

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
