import UIKit

import XCEArrayExt

//---

public
enum LayoutConstraintKind: Int
{
    case outer      // constraints with outer items
    case nested     // constraints with nested items
    case itself     // constraints with itself
    case unknown    // reserved for unexpected combination of inputs
}

private
extension LayoutConstraintKind
{
    static
    func detect(
        for constraint: NSLayoutConstraint,
        currentView: UIView,
        nestedViews: [UIView]
        ) -> LayoutConstraintKind
    {
        guard
            constraint.isMember(of: NSLayoutConstraint.self), // only PUBLIC constraints!
            let first = constraint.firstItem as? UIView,
            let second = constraint.secondItem as? UIView
        else
        {
            return unknown
        }

        //---

        if
            (first != currentView) && !nestedViews.contains(first), // first is an OUTER view
            second == currentView
        {
            return outer
        }
        else
        if
            first == currentView,
            (second != currentView) && !nestedViews.contains(second) // second is an OUTER view
        {
            return outer
        }
        else
        if
            currentView == first, first == second
        {
            return itself
        }
        else
        if
            nestedViews.contains(first), // first is a NESTED view
            second == currentView
        {
            return nested
        }
        else
        if
            first == currentView,
            nestedViews.contains(second) // second is a NESTED view
        {
            return nested
        }

        //---

        return unknown
    }
}

//---

public
protocol WithCustomResetLayoutPolicy: AnyObject
{
    var resetLayoutPolicy: Set<LayoutConstraintKind> { get }
    var keepConstraintsOnReset: [NSLayoutConstraint] { get }
}

public
extension WithCustomResetLayoutPolicy
{
    static
    var defaultResetLayoutPolicy: Set<LayoutConstraintKind>
    {
        return [.outer, .itself]
    }
}

//---

public
protocol LayoutResettable { }

//---

extension UIView: LayoutResettable { }

//---

public
extension LayoutResettable where Self: UIView
{
    /**
     This allows to reset all PUBLIC constraints between
     given view and any outer views,
     but retain any constraints added by the system (such as
     any intrinsic constraints), as well as internal constraints.
     See more: http://apprize.info/apple/ios_6/3.html
     */
    func resetLayout(_ defaultPolicy: Set<LayoutConstraintKind> = [.outer, .itself])
    {
        let nestedViews = allSubviews()

        let policy: Set<LayoutConstraintKind>
        let excludedConstraints: [NSLayoutConstraint]

        if
            let custom = self as? WithCustomResetLayoutPolicy
        {
            policy = custom.resetLayoutPolicy
            excludedConstraints = custom.keepConstraintsOnReset
        }
        else
        {
            policy = defaultPolicy
            excludedConstraints = []
        }

        //---

        constraints
            .xce.excludeIf{ excludedConstraints.contains($0) }
            .xce.includeIf
            {
                let kind = LayoutConstraintKind.detect(
                    for: $0,
                    currentView: self,
                    nestedViews: nestedViews
                )

                return policy.contains(kind)
            }
            .forEach
            {
                $0.isActive = NO // deactivate/remove constraints that made it to the final set
            }
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
