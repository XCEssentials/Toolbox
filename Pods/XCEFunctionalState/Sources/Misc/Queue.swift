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
 General-purpose queue (FIFO) with elements of genertic type `T`.
 Credits to [Ray Wenderlich](https://github.com/raywenderlich/swift-algorithm-club/tree/master/Queue).
 */
struct Queue<T>
{
    /**
     Internal storage where elements will be actually stored.
     */
    fileprivate
    var array = [T]()
    
    /**
     A Boolean value indicating whether the collection is empty: `true` if there is NO elements in the queue, `false` otherwise.
     
     - Note: When you need to check whether your queue is empty, use the
     `isEmpty` property instead of checking that the `count` property is
     equal to zero. Complexity: O(1).
     */
    var isEmpty: Bool
    {
        return array.isEmpty
    }
    
    /**
     Number of elements in the queue.
     */
    var count: Int
    {
        return array.count
    }
    
    /**
     The earliest added element, the same element that would be returned by `dequeue` element, or `nil`, if there is NO elements in the queue.
     */
    var front: T?
    {
        return array.first
    }
    
    /**
     Adds element to the queue.
     
     - Parameter element: The value to be added to the queue.
     */
    mutating
    func enqueue(_ element: T)
    {
        array.append(element)
    }
    
    /**
     Removes the earliest added element from the queue.
     
     - Returns: The earliest added element, or `nil`, if there were no elements in the queue at the moment when the function has been called.
     */
    mutating
    func dequeue() -> T?
    {
        if
            isEmpty
        {
            return nil
        }
        else
        {
            return array.removeFirst()
        }
    }
    
    /**
     Removes all elements from the queue, makes it empty.
     */
    mutating
    func reset()
    {
        array.removeAll()
    }
}
