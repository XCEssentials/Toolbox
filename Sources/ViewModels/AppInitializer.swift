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

public
extension VM
{
    /**
     Special feature that implements initial app setup in its bindings.
     */
    public
    enum AppInitializer: ViewModel, NoBindings
    {
        public
        struct Running: State
        {
            public
            typealias Parent = AppInitializer

            public
            let bundleInfo: M.BundleInfo.Storage
        }
    }
}

// MARK: - Actions

public
extension VM.AppInitializer
{
    /**
     This action initiates the app initialization and schedules its own deinitialization right away. If the app initialization will go well (that supposed to happen exactly once per app launch), then it will triggers all the necessary initializations that supposed to be declared in bindings of this view model.
     */
    static
    func run(with bundle: Bundle, appSetup: Action) -> Action
    {
        return initialize.Into<Running>.via { become, submit in

            become << Running(
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
