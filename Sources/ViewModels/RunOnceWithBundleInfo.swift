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

import Foundation

import XCEUniFlow

//===

/**
 Special feature that implements initial app setup in its bindings.
 */
public
protocol RunOnceWithBundleInfo: ViewModel { }

//===

public
struct RunningOnce<T: RunOnceWithBundleInfo>: State
{
    public
    typealias Parent = T

    public
    let bundleInfo: M.BundleInfo.Storage
}

// MARK: - Actions

public
extension RunOnceWithBundleInfo
{
    /**
     This action initiates the app initialization and schedules its own deinitialization right away. If the app initialization will go well (that supposed to happen exactly once per app launch), then it will triggers all the necessary initializations that supposed to be declared in bindings of this view model.
     */
    static
    func run(with bundle: Bundle, appSetup: Action) -> Action
    {
        return initialize.Into<RunningOnce<Self>>.via { become, submit in

            become << RunningOnce(
                // swiftlint:disable:next force_try
                bundleInfo: try! M.BundleInfo.of(bundle)
            )

            //---

            submit << [

                appSetup,
                self.deinitialize.automatically()
            ]
        }
    }
}
