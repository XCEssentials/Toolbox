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

import UIKit

import XCEFunctionalState
import XCEReusableView

//---

//swiftlint:disable comma
open
class BaseCell: UICollectionViewCell
    , CustomCell
    , WithReferenceToItself
    //swiftlint:enable comma
{
    // MARK: - Stateful support

    public
    let dispatcher = Dispatcher()

    // MARK: - Initializers

    public
    override
    init(frame: CGRect)
    {
        super.init(frame: frame)

        //---

        initialSetup()
    }

    public
    required
    init?(coder aDecoder: NSCoder)
    {
        fatalError("This class is supposed to be used from code only!")
    }

    open
    func initialSetup()
    {
        // override me in subclass!
    }

    // MARK: - Injectable support

    open
    func onAfterInjected()
    {
        // Injectable support - override in subclass if needed
    }
}

//---

#if DEBUG

extension BaseCell: Injectable
{
    @objc
    public
    func injected()
    {
        onAfterInjected()
    }
}

#endif
