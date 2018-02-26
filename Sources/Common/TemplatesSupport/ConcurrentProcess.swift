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

//---

public
class CancelToken
{
    private
    let lock = NSLock()

    //---

    public private(set)
    var isCancelled = false

    //---

    /**
     Returns 'true' if cancellation happened jsut now,
     i.e. token was in 'pending' state. Returns 'true' only once,
     subsequent calls of 'cancel()' will always return 'false'.
     */
    @discardableResult
    public
    func cancel() -> Bool
    {
        lock.lock(); defer{ lock.unlock() }

        //---

        let wasCancelled = isCancelled

        //---

        isCancelled = true

        //---

        return !wasCancelled
    }
}

//---

public
protocol ConcurrentProcess: Feature, NoBindings
{
    associatedtype Input
    associatedtype Output

    //---

    typealias Implementation =
        (Input, UUID, @escaping SubmitAction) -> CancelToken

    //---

    static
    var run: Implementation { get }

    static
    var minDelay: TimeInterval { get }
}
