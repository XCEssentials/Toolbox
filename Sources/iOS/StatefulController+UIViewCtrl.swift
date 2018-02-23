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

import UIKit

import XCEFunctionalState

//---

// MARK: - Apply

public
extension StatefulController where Self: UIViewController
{
    /**
     Schedules transition into a given state (target state).

     - Parameters:

     - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.

     - state: State that needs to be applied to `self.view` object (target state).

     - completion: Higher level completion that will be called after transition is complete and current state is set to target state.
     */
    func apply(
        via forceTransition: Transition<View>? = nil,
        state: State<View>,
        completion: UserProvidedCompletion = nil
        )
    {
        (view as! View) //swiftlint:disable:this force_cast
            .apply(
                via: forceTransition,
                state: state,
                completion: completion
            )
    }

    /**
     Schedules transition into a given state (target state).

     - Parameters:

     - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.

     - stateGetter: Closure that returns state (target state) which needs to be applied to `self.view` object.
     */
    func apply(
        via forceTransition: Transition<View>? = nil,
        state stateGetter: (View.Type) -> State<View>
        )
    {
        (view as! View) //swiftlint:disable:this force_cast
            .apply(
                via: forceTransition,
                state: stateGetter
            )
    }

    /**
     Schedules transition into a given state (target state).

     - Parameters:

     - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.

     - stateGetter: Closure that returns state (target state) which needs to be applied to `self.view` object.

     - completion: Higher level completion that will be called after transition is complete and current state is set to target state.
     */
    func apply(
        via forceTransition: Transition<View>? = nil,
        state stateGetter: (View.Type) -> State<View>,
        completion: UserProvidedCompletion
        )
    {
        (view as! View) //swiftlint:disable:this force_cast
            .apply(
                via: forceTransition,
                state: stateGetter,
                completion: completion
            )
    }
}
