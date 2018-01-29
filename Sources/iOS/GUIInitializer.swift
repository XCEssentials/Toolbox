import UIKit

import XCEUniFlow

//---

public
protocol GUIInitializer
{
    /**
     Returns app root view controller.
     */
    static
    func setup(with proxy: Dispatcher.Proxy) -> UIViewController
}
