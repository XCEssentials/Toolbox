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
typealias BasicClosure = () -> Void

/**
 Completion block that gets the only `Bool` parameter, that indicates whatever related process has been finished successfully or not.
 */
public
typealias Completion = (Bool) -> Void

/**
 This closure must represent pure changes (synchonous) on a captured from outer scope subject. NO info about 'Subject' type, no need to call completion, any kind of transition is out of scope as well (no animation expected to be used inside this closure).
 */
public
typealias SomePureMutation = BasicClosure

/**
 This closure must contain some (asynchonous) changes on a captured from outer scope subject. As in case of 'SomePureMutation', there is NO info about 'Subject' type, BUT any kind of transition/animation code IS allowed inside, the only input parameter is completion block that must be dispatched on main thread as soon as all changes are applied and all transitions/animations (if being used) are completed - in case of positive completion, or as soon as an interruption happened in case of unsuccessful completion of the mutation/transition.
 */
public
typealias SomeMutationWithCompletion = (@escaping Completion) -> Void

/**
 An 'InternalCompletion' closure is being passed into 'SomeMutationWithCompletion' closure, and when it gets called - it calls 'UserProvidedCompletion' (if presented) and continues processing of the transitions in the queue.
 */
public
typealias SomeTransition = SomeMutationWithCompletion

//---

public
typealias StateIdentifier = String

// MARK: Prefixed aliases for all public top-level types

public
typealias FSTBasicClosure = BasicClosure

public
typealias FSTCompletion = Completion

public
typealias FSTSomePureMutation = SomePureMutation

public
typealias FSTSomeMutationWithCompletion = SomeMutationWithCompletion

public
typealias FSTSomeTransition = SomeTransition

public
typealias FSTStateIdentifier = StateIdentifier

public
typealias FSTTransition<Owner: Stateful> = Transition<Owner>

public
typealias FSTDefaultTransitions = DefaultTransitions

//---

public
typealias FSTStateful = Stateful

//public
//typealias FSTState<Subject: AnyObject> = State<Subject>

public
typealias FSTPendingState<Subject: Stateful>  = PendingState<Subject>

public
typealias FSTSomeState = SomeState

public
typealias FSTDispatcher = Dispatcher
