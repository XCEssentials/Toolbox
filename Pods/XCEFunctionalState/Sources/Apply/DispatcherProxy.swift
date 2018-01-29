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

//===

public
struct DispatcherProxy<Subject: Stateful>
{
    public
    let dispatcher: Dispatcher
    
    public
    let object: Subject
}

//===

public
extension DispatcherProxy
{
    /**
     Schedules transition into a given state (target state).
     
     - Parameters:
     
         - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.
     
         - state: State that needs to be applied to `self.subject` object (target state).
     
         - completion: Higher level completion that will be called after transition is complete and current state is set to target state.
     
     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        state: State<Subject>,
        completion: UserProvidedCompletion = nil
        ) -> DispatcherProxy<Subject>
    {
        dispatcher.queue.enqueue((
            state.toSomeState(with: object, forceTransition: forceTransition),
            completion
        ))
        
        dispatcher.processNext()
        
        //===
        
        return self
    }
    
    /**
     Schedules transition into a given state (target state).

     - Parameters:

         - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.

         - completion: Higher level completion that will be called after transition is complete and current state is set to target state.
     
         - stateGetter: Closure that returns state (target state) which needs to be applied to `self.subject` object

     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        state stateGetter: (Subject.Type) -> State<Subject>,
        completion: UserProvidedCompletion
        ) -> DispatcherProxy<Subject>
    {
        let state = stateGetter(Subject.self)
        
        dispatcher.queue.enqueue((
            state.toSomeState(with: object, forceTransition: forceTransition),
            completion
        ))
        
        dispatcher.processNext()

        //===

        return self
    }
    
    /**
     Schedules transition into a given state (target state).
     
     - Parameters:
     
         - forceTransition: Transition that must be used to override transitions defined in target state (both `onSetTransition` and `onUpdateTransition`). If it's `nil` then transitions from `targetState` will be used instead.
     
         - stateGetter: Closure that returns state (target state) which needs to be applied to `self.subject` object
     
     - Returns: Reference to self to support chaining calls.
     */
    @discardableResult
    func apply(
        via forceTransition: Transition<Subject>? = nil,
        state stateGetter: (Subject.Type) -> State<Subject>
        ) -> DispatcherProxy<Subject>
    {
        let state = stateGetter(Subject.self)
        
        dispatcher.queue.enqueue((
            state.toSomeState(with: object, forceTransition: forceTransition),
            nil
        ))
        
        dispatcher.processNext()
        
        //===
        
        return self
    }
}
