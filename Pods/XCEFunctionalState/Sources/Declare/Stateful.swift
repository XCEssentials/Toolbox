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
    var stateDispatcher: Dispatcher { get }

    /**
     Transition that will be used as `onSetTransition` in each state related to this class, if no other transition is specified explicitly.
     */
    static
    var defaultOnSetTransition: Transition<Self> { get }

    /**
     Transition that will be used as `onUpdateTransition` in each state related to this class, if no other transition is specified explicitly.
     */
    static
    var defaultOnUpdateTransition: Transition<Self> { get }
}

// MARK: - Default implementations

public
extension Stateful
{
    /**
     Don't be confused, it's called 'state' jsut for a nicer API.
     When need to apply a state, you call use it like this:

     ```swift
     self.state.apply{ $0.someState() }
     ```
     */
    var state: DispatcherProxy<Self>
    {
        return DispatcherProxy(dispatcher: stateDispatcher, object: self)
    }

    static
    var defaultOnSetTransition: Transition<Self>
    {
        return FST.instantTransition()
    }

    static
    var defaultOnUpdateTransition: Transition<Self>
    {
        return FST.instantTransition()
    }
}
