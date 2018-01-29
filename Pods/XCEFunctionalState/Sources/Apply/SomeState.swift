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
 Special container object that represents a single state, does not contain metadata about 'Subject' type.
 */
public
struct SomeState
{
    /**
     Internal state identifier that helps to distinguish one state from another. It is supposed to be unique per stateful object, regardless of the rest of the state internal member values.
     */
    let identifier: String
    
    /**
     Closure that must be called to apply this state (when this state is NOT current yet, or current state is undefined yet, to make it current).
     */
    let onSet: SomeMutationWithCompletion
    
    /**
     Closure that must be called to apply this state when this state IS already current. This might be useful to update some parameters that the state captures from the outer scope when gets called/created, while entire state stays the same.
     */
    let onUpdate: SomeMutationWithCompletion?
    
    //===
    
    /**
     The only designated constructor, intentionally inaccessible from outer scope to make the static `state(...)` functions of `Stateful` protocol exclusive way of defining states for a given class.
     */
    init(
        identifier: String,
        onSet: @escaping SomeMutationWithCompletion,
        onUpdate: SomeMutationWithCompletion?
        )
    {
        self.identifier = identifier
        
        self.onSet = onSet
        self.onUpdate = onUpdate
    }
}

//===

extension SomeState: Equatable
{
    public
    static
    func == (left: SomeState, right: SomeState) -> Bool
    {
        return left.identifier == right.identifier
    }
}
