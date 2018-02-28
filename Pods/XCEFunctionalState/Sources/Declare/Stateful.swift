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
 Turns any class into [discrete system](https://en.wikipedia.org/wiki/Discrete_system).
 */
public
protocol Stateful: class
{
    var dispatcher: Dispatcher { get }
}

// MARK: - State constructors

public
extension Stateful
{
    /**
     One of the designated functions to define a state.

     - Parameters:

     - stateId: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type and it's very convenient for debugging.

     - transition: Transition that will be used to apply `setBody` mutations.

     - onSetMutations: Closure that must be called to apply this state (to make it current when this state is NOT current yet, or current state is undefined yet).
     */
    func setStateOnly(
        stateId: StateIdentifier = #function,
        via transition: Transition<Self>? = nil,
        _ onSetMutations: @escaping BasicClosure
        )
    {
        let state = State<Self>(
            identifier: stateId,
            onSet: (onSetMutations, transition ?? DefaultTransitions.instant()),
            onUpdate: nil
        )

        dispatcher.queue.enqueue(state.toSomeState(with: self))

        dispatcher.processNext()
    }

    func setOrUpdateState(
        stateId: StateIdentifier = #function,
        via sameTransition: Transition<Self>? = nil,
        _ commonMutations: @escaping BasicClosure
        )
    {
        let state = State<Self>(
            identifier: stateId,
            onSet: (commonMutations, sameTransition ?? DefaultTransitions.instant()),
            onUpdate: (commonMutations, sameTransition ?? DefaultTransitions.instant())
        )

        dispatcher.queue.enqueue(state.toSomeState(with: self))

        dispatcher.processNext()
    }

    func setOrUpdateState(
        stateId: StateIdentifier = #function,
        setVia onSetTransition: Transition<Self>? = nil,
        updateVia onUpdateTransition: Transition<Self>? = nil,
        _ commonMutations: @escaping BasicClosure
        )
    {
        let state = State<Self>(
            identifier: stateId,
            onSet: (commonMutations, onSetTransition ?? DefaultTransitions.instant()),
            onUpdate: (commonMutations, onUpdateTransition ?? DefaultTransitions.instant())
        )

        dispatcher.queue.enqueue(state.toSomeState(with: self))

        dispatcher.processNext()
    }
}

//---

public
extension Stateful
{
    /**
     One of the designated functions to define a state.

     - Parameters:

     - stateId: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type and it's very convenient for debugging.

     - transition: Transition that will be used to apply `onSet` mutations.

     - onSet: Closure that must be called to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).

     - Returns: An intermediate data structure that is used as syntax suger to define a state with both 'onSet' and 'onUpdate' mutations via chainable API. It will keep inside a state value made of all provided parameters (with empty 'onUpdate').
     */
    func setState(
        stateId: StateIdentifier = #function,
        via transition: Transition<Self>? = nil,
        _ onSetMutations: @escaping BasicClosure
        ) -> PendingState<Self>
    {
        return PendingState(
            host: self,
            stateId: stateId,
            onSetTransition: transition ?? DefaultTransitions.instant(),
            onSetMutations: onSetMutations
        )
    }
}

//---

/**
 An intermediate data structure that is used as syntax suger to define a state with both 'onSet' and 'onUpdate' mutations via chainable API.
 */
public
struct PendingState<Subject: Stateful>
{
    fileprivate
    let host: Subject

    fileprivate
    let stateId: StateIdentifier

    fileprivate
    let onSetTransition: Transition<Subject>

    fileprivate
    let onSetMutations: BasicClosure
}

public
extension PendingState
{
    /**
     One of the designated functions to define a state.

     - Parameters:

     - onUpdateTransition: Transition that will be used to apply `onUpdate` mutations.

     - onUpdateMutations: Closure that must be called to apply this state when this state IS already current. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.
     */
    func updateState(
        via onUpdateTransition: Transition<Subject>? = nil,
        _ onUpdateMutations: @escaping BasicClosure
        )
    {
        let state = State<Subject>(
            identifier: stateId,
            onSet: (onSetMutations, onSetTransition),
            onUpdate: (onUpdateMutations, onUpdateTransition ?? DefaultTransitions.instant())
        )

        host.dispatcher.queue.enqueue(state.toSomeState(with: host))

        host.dispatcher.processNext()
    }
}
