import UIKit

import XCEUniFlow

//---

public
typealias AppLaunchOptions = [UIApplicationLaunchOptionsKey: Any]

//---

public
protocol AppInitializer
{
    func setup(
        with app: UIApplication,
        launchOptions: AppLaunchOptions?)
}
