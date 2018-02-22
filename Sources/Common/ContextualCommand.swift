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
protocol CommandContext: class
{
    //
}

//---

//public
//struct ContextualCommand<Context: CommandContext, Output>
//{
//    public
//    let body: (Context) -> Output
//
//    fileprivate
//    init(with body: @escaping (Context) -> Output)
//    {
//        self.body = body
//    }
//}

//---

public
struct Commands<Context: CommandContext>
{
    fileprivate
    let context: Context

//    public
//    typealias CommandReturns<Output> = ContextualCommand<Context, Output>
//
//    public
//    typealias Command = CommandReturns<Void>

    @discardableResult
    public
    func command<Output>(
        _ handler: (Context) -> Output
        ) -> Output
    {
        return handler(context)
    }

//    public
//    func commandReturns<Output>(
//        _ handler: (Context) -> Output
//        ) -> Output
//    {
//        return handler(context)
//    }
//
//    public
//    func command(
//        _ handler: (Context) -> Void
//        )
//    {
//        handler(context)
//    }
}

//---

public
extension CommandContext
{
    typealias Cmd = Commands<Self>

    var execute: Cmd
    {
        return Cmd(context: self)
    }

//    func execute(
//        _ commandGetter: (Self.Type) -> Command
//        )
//    {
//        commandGetter(type(of: self)).body(self)
//    }
//    func map<Output>(
//        _ commandGetter: (Self.Type) -> CommandReturns<Output>
//        ) -> Output
//    {
//        return commandGetter(type(of: self)).body(self)
//    }
}

//---

final
class Tst: CommandContext
{
    let num: Int = 4

    func useHere()
    {
     // cmd.setup()
     // execute(Cmd.setup())
     // execute << cmd.setup()
     // execute << setup()
     // execute{ $0.setup() }
     // execute(.setup)
     // execute(.setupWith(4))
     // execute << .setup
     // execute << .setupWith(4)
     // execute << .setup.with(4)
     // execute(Itself.setup.with(4))

        execute.setup()

        //
    }

    static
    let aaa =
    {
        print("dsdsd")
    }
}

//---

fileprivate
extension Commands where Context: Tst
{
    func setup()
    {
        command
        {
            _ = $0.num
        }
    }

    func doAndReturn() -> Bool
    {
        return command
        {
            _ = $0.num

            return false
        }
    }
}



//=================

//public
//struct ContextualCommand<Context: AnyObject, Output>
//{
//    public
//    let body: (Context) -> Output
//
//    fileprivate
//    init(with body: @escaping (Context) -> Output)
//    {
//        self.body = body
//    }
//}

//// MARK: - CommandContext protocol
//
//public
//protocol CommandContext: class { }
//
//// MARK: - CommandContext protocol - Command aliases
//
//public
//extension CommandContext
//{
//    typealias CommandReturns<Output> = ContextualCommand<Self, Output>
//    typealias Command = CommandReturns<Void>
//}
//
//// MARK: - CommandContext protocol - Command definition constructor
//
//public
//extension CommandContext
//{
//    static
//    func command<Output>(
//        _ handler: @escaping (Self) -> Output
//        ) -> CommandReturns<Output>
//    {
//        return CommandReturns(with: handler)
//    }
//}
//
//// MARK: - CommandContext protocol - Usage helpers
//
//public
//enum CmdExt<Host: AnyObject>
//{
//    //
//}
//
//public
//extension CommandContext
//{
//    typealias Cmd = CmdExt<Self>
//
//    var exec: Self.Type
//    {
//        return type(of: self)
//    }
//
//    func execute(
//        _ commandGetter: (Self.Type) -> Command
//        )
//    {
//        commandGetter(type(of: self)).body(self)
//    }
//
//    func map<Output>(
//        _ commandGetter: (Self.Type) -> CommandReturns<Output>
//        ) -> Output
//    {
//        return commandGetter(type(of: self)).body(self)
//    }
//}
//
//final
//class Tst: CommandContext
//{
//    static
//    let setup = command
//    {
//        _ = $0
//    }
//
//    static
//    func setupAgain(with num: Int) -> Command
//    {
//        return command
//        {
//            _ = $0
//        }
//    }
//
//    func tst()
//    {
////        Cmd
//    }
//}
//
//extension CmdExt where Host == Tst
//{
//
//}
