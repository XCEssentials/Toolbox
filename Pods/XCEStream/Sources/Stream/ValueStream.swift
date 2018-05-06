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

// MARK: - Stream

public
struct ValueStream<T>
{
    let wrapper = HandlerWrapper<T>()

    //---

    public
    init() { }
}

// MARK: - Stream management

public
extension ValueStream
{
    /**
     Defines handler that's going to be executed when the stream emits an event.
     */
    func bind<Target: AnyObject>(
        with object: Target,
        _ functionGetter: @escaping (Target) -> (T) -> Void
        )
    {
        wrapper.wrap(object, functionGetter)
    }

    /**
     This function is 'mutating' only to allow limit usage of this func
     to the local scope by marking property of this type as
     'private(set)'.
     */
    mutating
    func submit(_ payload: T)
    {
        wrapper.handler?(payload)
    }
}

public
extension ValueStream where T == Void
{
    func bind<Target: AnyObject>(
        with object: Target,
        _ functionGetter: @escaping (Target) -> () -> Void
        )
    {
        wrapper.wrap(object, functionGetter)
    }
}

// MARK: - Convenience aliases

public
typealias StreamOf<T> = ValueStream<T>

public
typealias StreamVoid = ValueStream<Void>

// MARK: - Custom operators

public
func >> <Target: AnyObject, Input>(
    stream: ValueStream<Input>,
    handler: (Target, (Target) -> (Input) -> Void)
    )
{
    stream.bind(with: handler.0, handler.1)
}

public
func >> <Target: AnyObject>(
    stream: StreamVoid,
    handler: (Target, (Target) -> () -> Void)
    )
{
    stream.bind(with: handler.0, handler.1)
}
