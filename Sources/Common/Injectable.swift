// http://johnholdsworth.com/injection.html
// https://medium.com/@robnorback/the-secret-to-1-second-compile-times-in-xcode-9de4ec8345a1
// https://github.com/johnno1962/injectionforxcode

import Foundation

//---

#if DEBUG

@objc
public
protocol Injectable: NSObjectProtocol
{
    func onAfterInjected()

    @objc
    func injected()
}

#endif
