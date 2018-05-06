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

import XCEViewEvents

//---

public
extension PendingBarButtonOperation
{
    func plug<T>(into stream: ValueStream<T>)
    {
        set(#selector(stream.wrapper.submit), of: stream.wrapper)
    }
}

//---

public
extension PendingEventsOperation
{
    func plug<T>(into stream: ValueStream<T>)
    {
        removeAllHandlers(of: stream.wrapper)
        add(#selector(stream.wrapper.submit), of: stream.wrapper)
    }

    func unplug<T>(from stream: ValueStream<T>)
    {
        removeAllHandlers(of: stream.wrapper)
    }
}

//---

public
extension PendingRecognizerOperation
{
    func addRecognizer<T>(
        pluggedInto stream: ValueStream<T>,
        configuration: ((Recognizer) -> Void)? = nil
        )
    {
        addRecognizer(
            with: #selector(stream.wrapper.submit),
            of: stream.wrapper,
            configuration: configuration ?? { _ in }
        )
    }
}

// MARK: - Custom operators

public
func >> <T>(
    barButtonOperation: PendingBarButtonOperation,
    stream: ValueStream<T>
    )
{
    barButtonOperation.plug(into: stream)
}

public
func >> <T>(
    eventsOperation: PendingEventsOperation,
    stream: ValueStream<T>
    )
{
    eventsOperation.plug(into: stream)
}

public
func >> <R, T>(
    recognizerOperation: PendingRecognizerOperation<R>,
    stream: ValueStream<T>
    )
{
    recognizerOperation.addRecognizer(pluggedInto: stream)
}
