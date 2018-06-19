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

/**
 Set of helpers for chainable value transformations, pipeline-style.

 Inspiration:
 - https://blog.mariusschulz.com/2014/09/13/implementing-a-custom-forward-pipe-operator-for-function-chains-in-swift

 Examples:
 - https://github.com/patgoley/Pipeline/blob/master/Pipeline/Operators.swift
 - https://github.com/danthorpe/Pipe (outdated!)
 - https://github.com/jarsen/Pipes (outdated!)
 */

//---

precedencegroup CompositionPrecedence {
    higherThan: AssignmentPrecedence
    lowerThan: TernaryPrecedence
    associativity: left
}

//---

infix operator ./ : CompositionPrecedence // pass through

// TODO: Remove this operator in a 1.12+ version release!
infix operator .| : CompositionPrecedence // final pass

//---

/**
 Special global-level helper operator
 for continuing chain/pipeline of transformations.
 */
@discardableResult
public
func ./ <T, U>(value: T, function: (T) throws -> U) rethrows -> U
{
    return try function(value)
}

// TODO: Remove this operator in a 1.12+ version release???
/**
 Special global-level helper operator
 for finilizing chain/pipeline of transformations.
 */
@available(*, deprecated, message: "Use the './' operator, it now marked with @discardableResult")
public
func .| <T>(value: T, function: (T) throws -> Void) rethrows
{
    return try function(value)
}

//---

/**
 Special global-level helper that's intended to be used
 for easy inline mutation of value-type instances. THROWS!
 */
public
func mutate<T>(
    _ body: @escaping (inout T) throws -> Void
    ) -> (T) throws -> T
{
    return { var tmp = $0; try body(&tmp); return tmp }
}

/**
 Special global-level helper that's intended to be used
 for easy inline mutation of value-type instances.
 */
public
func mutate<T>(
    _ body: @escaping (inout T) -> Void
    ) -> (T) -> T
{
    return { var tmp = $0; body(&tmp); return tmp }
}

/**
 Special global-level helper that's intended to be used
 for easy inline mutation of reference-type instances or
 observation (read-only) access to value type instances.
 THROWS!
 */
public
func use<T>(
    _ body: @escaping (T) throws -> Void
    ) -> (T) throws -> T
{
    return { try body($0); return $0 }
}

/**
 Special global-level helper that's intended to be used
 for easy inline mutation of reference-type instances or
 observation (read-only) access to value type instances.
 */
public
func use<T>(
    _ body: @escaping (T) -> Void
    ) -> (T) -> T
{
    return { body($0); return $0 }
}

/**
 Special global-level helper that's intended to be used
 for easy inline checking some conditions about provided input.
 THROWS!
 */
public
func check<T>(
    _ body: @escaping (T) throws -> Void
    ) -> (T) throws -> T
{
    return { try body($0); return $0 }
}

/**
 Special global-level helper that's intended to be used
 for easy inline checking some conditions about provided input.
 THROWS!
 */
public
func check<T>(
    _ description: String,
    _ condition: @escaping (T) -> Bool
    ) -> (T) throws -> T
{
    return { try Check(description, condition).validate(value: $0); return $0 }
}

/**
 Special global-level helper that's intended to stop passing
 results through the chain.
 THROWS!
 */
public
func done<T>(
    _ body: @escaping (T) throws -> Void
    ) -> (T) throws -> Void
{
    return { try body($0) }
}

/**
 Special global-level helper that's intended to stop passing
 results through the chain.
 */
public
func done<T>(
    _ body: @escaping (T) -> Void
    ) -> (T) -> Void
{
    return { body($0) }
}

/**
 Special global-level helper that's intended to disregard
 provided input and continue the chain with whatever will
 be returned from 'body'.
 THROWS!
 */
public
func reset<T, U>(
    _ body: @escaping () throws -> U
    ) -> (T) throws -> U
{
    return { _ in return try body() }
}

/**
 Special global-level helper that's intended to disregard
 provided input and continue the chain with whatever will
 be returned from 'body'.
 */
public
func reset<T, U>(
    _ body: @escaping () -> U
    ) -> (T) -> U
{
    return { _ in return body() }
}
