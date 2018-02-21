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

public
struct ContextualCommand<Context, Output>
{
    public
    let body: (Context) -> Output

    fileprivate
    init(with body: @escaping (Context) -> Output)
    {
        self.body = body
    }
}

// MARK: - CommandContext protocol

public
protocol CommandContext: class { }

// MARK: - CommandContext protocol - Command aliases

public
extension CommandContext
{
    typealias CommandReturns<Output> = ContextualCommand<Self, Output>
    typealias Command = CommandReturns<Void>
}

// MARK: - CommandContext protocol - Command definition constructor

public
extension CommandContext
{
    static
    func command<Output>(
        _ handler: @escaping (Self) -> Output
        ) -> CommandReturns<Output>
    {
        return CommandReturns(with: handler)
    }
}

// MARK: - CommandContext protocol - Usage helpers

public
extension CommandContext
{
    func execute(
        _ commandGetter: (Self.Type) -> Command
        )
    {
        commandGetter(type(of: self)).body(self)
    }

    func map<Output>(
        _ commandGetter: (Self.Type) -> CommandReturns<Output>
        ) -> Output
    {
        return commandGetter(type(of: self)).body(self)
    }
}
