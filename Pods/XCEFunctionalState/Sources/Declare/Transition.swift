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

/**
 Closure/function that implements transition into a new state.

 - Parameters:

 - stateOwner: Object-owner of the state.

 - mutations: Mutations/statements that must be performed exactly once in order to complete transition into the new state; must be called on MAIN trhead/queue.

 - completion: Completion closure; must be called on MAIN trhead/queue after `mutations` closure has been executed.
 */
public
typealias Transition<Subject: AnyObject> = (
    Subject,
    @escaping BasicClosure,
    @escaping Completion
    ) -> Void

//---

public
enum DefaultTransitions // scope
{
    /**
     Helper constructor of transition that applies mutations instantly and calls completion right away.
     */
    static
    func instant<T: AnyObject>() -> Transition<T>
    {
        return { $1(); $2(true) }
    }
}
