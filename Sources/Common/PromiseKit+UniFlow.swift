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

import PromiseKit
import XCEUniFlow

//---

public
extension PromiseKit.Thenable where Self.T == GlobalModel
{
    /**
     Extracts given feature in form of an instance of 'SomeState'
     from the global model provided, or fails the promise chain
     if the feature is not currently presented in the model.
     */
    func mapInto<F: XCEUniFlow.Feature>(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        _ feature: F.Type
        ) -> PromiseKit.Promise<XCEUniFlow.SomeState>
    {
        return map(on: queue){ try $0.mapInto(feature) }
    }

    /**
     Extracts given state from the global model provided,
     or fails the promise chain if the feature
     is not currently presented in the model.
     */
    func mapInto<S: XCEUniFlow.State>(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        _ state: S.Type
        ) -> PromiseKit.Promise<S>
    {
        return map(on: queue){ try $0.mapInto(state) }
    }
}
