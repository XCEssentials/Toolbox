import UIKit

import XCEFunctionalState

//---

public
class BaseView: UIView
{
    // MARK: - Stateful support

    public
    let stateDispatcher = Dispatcher()

    // MARK: - injectable support

    public
    func onAfterInjected() { }
}

//---

#if DEBUG

extension BaseView: Injectable
{
    @objc
    public
    func injected()
    {
        for subview in subviews
        {
            subview.removeFromSuperview()
        }

        //---

        onAfterInjected()
    }
}

#endif
