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

//---

class HandlerWrapper<Input>
{
    typealias Handler = (Input) -> Void

    //---

    private(set)
    var handler: Handler?

    /**
     Based on:
     http://blog.xebia.com/function-references-in-swift-and-retain-cycles/
     */
    func wrap<Target: AnyObject>(
        _ object: Target,
        _ functionGetter: @escaping (Target) -> (Input) -> Void
        )
    {
        handler = { [weak object] input in object.map(functionGetter)?(input) }
    }

    /**
     Special helper for direct connection with target/action sources of
     UIControlEvents-based notifications (UIButton, UITextField, etc.).
     These kind of notifications always expect to be connected to handlers
     that take no parameters or single parameter which is the sender object.
     In a special case, a 'Void' value '()' should be valid for this declaration
     as well.
     */
    @objc
    func submit(_ input: Any)
    {
        // https://developer.apple.com/documentation/uikit/uicontrol#1943645

        guard let handler = handler else { return }

        //---

        if
            let typedPayload = () as? Input // Input is Void
        {
            handler(typedPayload)
        }
        else
        if
            let typedPayload = input as? Input
        {
            handler(typedPayload)
        }
    }
}

extension HandlerWrapper where Input == Void
{
    func wrap<Target: AnyObject>(
        _ object: Target,
        _ functionGetter: @escaping (Target) -> () -> Void
        )
    {
        handler = { [weak object] input in object.map(functionGetter)?() }
    }
}
