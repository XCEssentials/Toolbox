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

public
extension Stateful
{
    /**
     One of the designated functions to define a state.
     
     - Parameters:
     
         - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type while is very convenient for debugging.
     
         - onSetTransition: Transition that will be used to apply `onSet` mutations.
     
         - onSet: Closure that must be called to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).
     
     - Returns: State with `Self` as state `Subject` type, made of all the provided input parameters.
     */
    static
    func state(
        _ identifier: String = #function,
        via onSetTransition: @escaping Transition<Self> = Self.defaultOnSetTransition,
        _ onSet: @escaping Mutation<Self>
        ) -> State<Self>
    {
        return State(
            identifier: identifier,
            onSet: (onSet, onSetTransition),
            onUpdate: nil
        )
    }
}

//===

public
extension Stateful
{
    /**
     One of the designated functions to define a state.
     
     - Parameters:
     
         - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type while is very convenient for debugging.
     
         - onSetTransition: Transition that will be used to apply `onSet` mutations.
     
         - onSet: Closure that must be called to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).
     
     - Returns: An intermediate data structure that is used as syntax suger to define a state with both 'onSet' and 'onUpdate' mutations via chainable API. It will keep inside a state value made of all provided parameters (with empty 'onUpdate').
         */
    static
    func onSet(
        _ identifier: String = #function,
        via onSetTransition: @escaping Transition<Self> = Self.defaultOnSetTransition,
        _ onSet: @escaping Mutation<Self>
        ) -> PendingState<Self>
    {
        return PendingState(
            state: State(
                identifier: identifier,
                onSet: (onSet, onSetTransition),
                onUpdate: nil
            )
        )
    }
}

//===

/**
 An intermediate data structure that is used as syntax suger to define a state with both 'onSet' and 'onUpdate' mutations via chainable API.
 */
public
struct PendingState<Subject: Stateful>
{
    let state: State<Subject>
}

//===

public
extension PendingState
{
    /**
     One of the designated functions to define a state.
     
     - Parameters:
     
         - identifier: Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful type. It's highly recommended to always let the function use default value, which is defined by the name of the enclosing function. This guarantees its uniqueness within `Subject` type while is very convenient for debugging.
     
         - onUpdateTransition: Transition that will be used to apply `onUpdate` mutations.
     
         - onUpdate: Closure that must be called to apply this state when this state IS already current. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.
     
     - Returns: State with `Self.Subject` as state `Subject` type, made of all the provided input parameters plus 'identifier' and 'onSet' related values from internal state value.
     */
    func onUpdate(
        via onUpdateTransition: @escaping Transition<Subject> = Subject.defaultOnUpdateTransition,
        _ onUpdate: @escaping Mutation<Subject>
        ) -> State<Subject>
    {
        return State(
            identifier: state.identifier,
            onSet: state.onSet,
            onUpdate: (onUpdate, onUpdateTransition)
        )
    }
}
