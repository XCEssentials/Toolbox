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
 Special container object that represents a single state for 'Subject' type.
 */
struct State<Subject: AnyObject>
{
    /**
     Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful object, regardless of the rest of the state internal member values.
     */
    let identifier: StateIdentifier
    
    /**
     A helper typealias that represents Subject-specific pure mutation combined with transition that is supposed to be used to apply that mutation.
     */
    typealias MutationWithTransition =
        (mutation: BasicClosure, transition: Transition<Subject>)
    
    /**
     Mutation and transition that must be used to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).
     */
    let onSet: MutationWithTransition
    
    /**
     Mutation and transition that must be used to apply this state when this state IS already current. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.
     */
    let onUpdate: MutationWithTransition?
    
    //---
    
    /**
     The only designated constructor, intentionally inaccessible from outer scope to make the static `state(...)` functions of `Stateful` protocol exclusive way of defining states for a given class.
     */
    init(
        identifier: String,
        onSet: MutationWithTransition,
        onUpdate: MutationWithTransition?
        )
    {
        self.identifier = identifier
        
        self.onSet = onSet
        self.onUpdate = onUpdate
    }
}

//---

extension State: Equatable
{
    public
    static
    func == (left: State, right: State) -> Bool
    {
        return left.identifier == right.identifier
    }
}
