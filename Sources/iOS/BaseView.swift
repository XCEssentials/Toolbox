import UIKit

import XCEFunctionalState

//---

class BaseView: UIView
{
    // MARK: - Stateful support

    let stateDispatcher = Dispatcher()

    // MARK: - injectable support
    
    func onAfterInjected() { }
}

//---

#if DEBUG

extension BaseView: Injectable
{
    @objc
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
