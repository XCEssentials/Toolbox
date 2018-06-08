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

import PromiseKit
import XCEValidatableValue

//---

public
func take<T>(
    _ initialValue: T
    ) -> PromiseKit.Guarantee<T>
{
    return PromiseKit.Guarantee.value(initialValue)
}

//---

public
extension PromiseKit.Thenable
{
    /**
     Disregard current value of type 'Self.T',
     take new input value 'U' and continue chain
     with Promise<U>.
     */
    func take<U>(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        _ newInput: U
        ) -> PromiseKit.Promise<U>
    {
        return self.asVoid().map(on: queue){ newInput }
    }

    /**
     Based on 'get', throws an error if 'condition' returns 'false'.
     */
    func check(
        on queue: DispatchQueue? = PromiseKit.conf.Q.return,
        file: StaticString = #file,
        line: UInt = #line,
        _ description: String,
        _ condition: @escaping (Self.T) -> Bool
        ) -> PromiseKit.Promise<Self.T>
    {
        return self.get(on: queue)
        {
            try Check(description, condition)
                .validate(context: "file [\(file)] @ \(line)", value: $0)
        }
    }

    //---

    /**
     Based on 'get', fails if 'condition' throws an error.
     */
    func check(
        on queue: DispatchQueue? = PromiseKit.conf.Q.return,
        _ condition: @escaping (Self.T) throws -> Void
        ) -> PromiseKit.Promise<Self.T>
    {
        return self.get(on: queue, condition)
    }

    //---

    /**
     Uses 'map' to mutate the T value.
     */
    func mutate(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        _ body: @escaping (inout Self.T) throws -> Void
        ) -> PromiseKit.Promise<Self.T>
    {
        return map(on: queue){ var buf = $0; try body(&buf); return buf}
    }

    //---

    /**
     Syntax suger for 'compactMap(body)'.
     Intended to be used for checking optional values
     to be non-nil.
     */
    func mapNonEmpty<U>(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        _ body: @escaping (Self.T) throws -> U?
        ) -> PromiseKit.Promise<U>
    {
        return compactMap(on: queue, body)
    }

    //---

    /**
     Syntax sugar for 'then{ when(fulfilled: THENABLE) }'.
     It's similar to 'get()', but allows to do an async
     operation and continue with the value you had before
     that nested operatioin, but ONLY after that nested
     async operation is completed succesfully (fulfilled),
     otherwise - rejects the whole chain.
     */
    func thenGet(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        file: StaticString = #file,
        line: UInt = #line,
        _ body: @escaping (Self.T) throws -> PromiseKit.Promise<Void>
        ) -> PromiseKit.Promise<T>
    {

        let nestedOperation: (T) throws -> PromiseKit.Promise<Void>

            = { try body($0) }

        //---

        let transferValue: (T) -> PromiseKit.Guarantee<T>

            = { Guarantee.value($0) }

        //---

        return then(
            on: queue,
            file: file,
            line: line,
            { when(fulfilled: try nestedOperation($0), transferValue($0)) }
            )
            .map{ $1 }
    }
}

//---

public
extension PromiseKit.Thenable where Self.T : Sequence
{
    /**
     Syntax sugar for 'compactMapValues(transform)'.
     */
    func mapValuesNonEmpty<U>(
        on queue: DispatchQueue? = PromiseKit.conf.Q.map,
        _ transform: @escaping (Self.T.Iterator.Element) throws -> U?
        ) -> PromiseKit.Promise<[U]>
    {
        return compactMapValues(on: queue, transform)
    }
}

//---

public
extension PromiseKit.Thenable where Self.T : Collection
{
    /**
     Syntax suger for 'compactMap(body)'.
     Intended to be used for checking optional values
     to be non-nil.
     */
    func checkNonEmpty(
        on queue: DispatchQueue? = PromiseKit.conf.Q.return,
        file: StaticString = #file,
        line: UInt = #line
        ) -> PromiseKit.Promise<Self.T>
    {
        return check(
            on: queue,
            file: file,
            line: line,
            "Collection is non-empty",
            { (input: Self.T) -> Bool in !input.isEmpty }
            )
            .map{ $0 }
    }

}

//---

public
extension PromiseKit.CatchMixin
{
    @discardableResult
    func ignoreIfFails() -> PromiseKit.PMKFinalizer
    {
        return self.catch{ _ in }
    }
}
