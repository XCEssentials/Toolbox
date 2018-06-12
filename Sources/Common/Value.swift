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

import XCEValidatableValue

//---

public
enum Value {} // scope

//---

public
extension Value
{
    /**
     Intended to be a lightweight replacement for ‘guard … else’ statements.

     Usage (best works with Pipeline operators):

     ```swift
     try (40+2) .| Value.is(42)

     try someBoolVar ./ Value.is(NO)

     // in a closure with an implicit String parameter:
     try $0 ./ Value.is("some text")
     ```
     */
    static
    func `is`<T: Equatable>(
        _ expectedValue: T
        ) -> (T) throws -> Void
    {
        let check =

        Check<T>("Value expected to be \(expectedValue)"){ $0 == expectedValue }

        //---

        return { try check.validate(value: $0) }
    }
}
