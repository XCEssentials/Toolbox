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

import XCEUniFlow
import XCERequirement
import XCEOperationFlow

//===

public
extension M
{
    public
    enum ConcurrentProcess<Input, Result>: Model, NoBindings
    {
        public
        struct Idle: StateAuto
        {
            public
            typealias Parent = ConcurrentProcess<Input, Result>

            public
            init() { }
        }

        public
        struct Running: State
        {
            public
            typealias Parent = ConcurrentProcess<Input, Result>

            public
            let startedAt = Date()

            public
            let processId: UUID

            public
            let input: Input

            public
            let flow: OperationFlow.ActiveProxy
        }

        public
        struct Failed: State
        {
            public
            typealias Parent = ConcurrentProcess<Input, Result>

            public
            let input: Input

            public
            let error: Error
        }

        public
        struct Succeeded: State
        {
            public
            typealias Parent = ConcurrentProcess<Input, Result>

            public
            let input: Input

            public
            let result: Result
        }
    }
}

// MARK: - Process customization points

public
protocol ConcurrentProcessConfig
{
    associatedtype _Input

    typealias Implementation = (_Input, UUID, @escaping SubmitAction) -> OperationFlow

    static
    var minDelay: TimeInterval { get } // throttle

    static
    var run: Implementation { get }

}

//===

public
extension ConcurrentProcessConfig
{
    static
    var minDelay: TimeInterval
    {
        return 0
    }

    //===

    static
    var run: Implementation
    {
        return { _, _, _ in fatalError("Override me!") }
    }
}

//===

extension M.ConcurrentProcess: ConcurrentProcessConfig
{
    public
    typealias _Input = Input
}

// MARK: - Actions

public
extension M.ConcurrentProcess
{
    static
    func setup() -> Action
    {
        return initialize.Into<Idle>.automatically()
    }

    //===

    static
    func start(with input: Input) -> Action
    {
        return transition.Into<Running>.via(same: .ok) { globalModel, become, submit in

            if
                let running = try? Running.from(globalModel)
            {
                try? running.flow.cancel()

                //---

                try Require("Threshold has been passed").isTrue(

                    minDelay <= Date().timeIntervalSince(running.startedAt)
                )
            }

            //---

            let processId = UUID()

            become << Running(
                processId: processId,
                input: input,
                flow: self.run(input, processId, submit).proxy
            )
        }
    }

    //===

    static
    func fail(with processId: UUID, error: Error) -> Action
    {
        return transition.Between<Running, Failed>.via { running, become, _ in

            try Require("This is the most recent process result.").isTrue(

                running.processId == processId
            )

            //---

            become << Failed(input: running.input, error: error)
        }
    }

    //===

    static
    func finish(with processId: UUID, result: Result) -> Action
    {
        return transition.Between<Running, Succeeded>.via { running, become, _ in

            try Require("This is the most recent process result.").isTrue(

                running.processId == processId
            )

            //---

            become << Succeeded(input: running.input, result: result)
        }
    }

    //===

    static
    func reset() -> Action
    {
        return transition.Into<Idle>.automatically(same: .no)
    }
}
