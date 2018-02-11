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

import XCEUniFlow

//---

public
protocol CommandContext: class
{
    var dispatcher: Dispatcher.Proxy! { get }
}

//---

public
extension CommandContext
{
    typealias Command = ContextualCommand<Self>

    //---

    func execute(_ command: Command)
    {
        command.implementation(self)
    }

    //---

    func execute(_ command: Command.Act)
    {
        command.implementation(self, self.dispatcher.submit)
    }

    //---

    func execute<Input>(_ task: Command.In<Input>.PendingTask)
    {
        task.command(self, task.input)
    }

    //---

    func execute<Input>(_ task: Command.In<Input>.Act.PendingTask)
    {
        task.command(self, task.input, self.dispatcher.submit)
    }

    //---

    func map<Output>(_ command: Command.Out<Output>) -> Output
    {
        return command.implementation(self)
    }

    //---

    func map<Output>(_ command: Command.Act.Out<Output>) -> Output
    {
        return command.implementation(self, self.dispatcher.submit)
    }

    //---

    func map<Input, Output>(_ task: Command.In<Input>.Out<Output>.PendingTask) -> Output
    {
        return task.command(self, task.input)
    }

    //---

    func map<Input, Output>(_ task: Command.In<Input>.Act.Out<Output>.PendingTask) -> Output
    {
        return task.command(self, task.input, self.dispatcher.submit)
    }
}

//---

public
struct ContextualCommand<Context>
{
    public
    typealias Implementation = (Context) -> Void

    //---

    fileprivate
    let implementation: Implementation

    //---

    public
    init(_ implementation: @escaping Implementation)
    {
        self.implementation = implementation
    }
}

//---

public
extension ContextualCommand
{
    public
    struct Act // Actionable
    {
        public
        typealias Implementation = (Context, @escaping SubmitAction) -> Void

        //---

        fileprivate
        let implementation: Implementation

        //---

        public
        init(_ implementation: @escaping Implementation)
        {
            self.implementation = implementation
        }

        //---

        public
        struct Out<Output>
        {
            public
            typealias Implementation = (Context, @escaping SubmitAction) -> Output

            //---

            fileprivate
            let implementation: Implementation

            //---

            public
            init(_ implementation: @escaping Implementation)
            {
                self.implementation = implementation
            }
        }
    }

    //---

    public
    struct In<Input> //swiftlint:disable:this type_name
    {
        public
        typealias Implementation = (Context, Input) -> Void

        public
        typealias PendingTask = (command: Implementation, input: Input)

        //---

        fileprivate
        let implementation: Implementation

        //---

        public
        init(_ implementation: @escaping Implementation)
        {
            self.implementation = implementation
        }

        public
        func with(_ input: Input) -> PendingTask
        {
            return (self.implementation, input)
        }

        //---

        public
        struct Act // Actionable
        {
            public
            typealias Implementation = (Context, Input, @escaping SubmitAction) -> Void

            public
            typealias PendingTask = (command: Implementation, input: Input)

            //---

            fileprivate
            let implementation: Implementation

            //---

            public
            init(_ implementation: @escaping Implementation)
            {
                self.implementation = implementation
            }

            public
            func with(_ input: Input) -> PendingTask
            {
                return (self.implementation, input)
            }

            //---

            public
            struct Out<Output>
            {
                public
                typealias Implementation = (Context, Input, @escaping SubmitAction) -> Output

                public
                typealias PendingTask = (command: Implementation, input: Input)

                //---

                fileprivate
                let implementation: Implementation

                //---

                public
                init(_ implementation: @escaping Implementation)
                {
                    self.implementation = implementation
                }

                public
                func with(_ input: Input) -> PendingTask
                {
                    return (self.implementation, input)
                }
            }
        }

        //---

        public
        struct Out<Output>
        {
            public
            typealias Implementation = (Context, Input) -> Output

            public
            typealias PendingTask = (command: Implementation, input: Input)

            //---

            fileprivate
            let implementation: Implementation

            //---

            public
            init(_ implementation: @escaping Implementation)
            {
                self.implementation = implementation
            }

            public
            func with(_ input: Input) -> PendingTask
            {
                return (self.implementation, input)
            }
        }
    }

    //---

    public
    struct Out<Output>
    {
        public
        typealias Implementation = (Context) -> Output

        //---

        fileprivate
        let implementation: Implementation

        //---

        public
        init(_ implementation: @escaping Implementation)
        {
            self.implementation = implementation
        }
    }
}
