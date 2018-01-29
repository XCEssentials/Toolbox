import Foundation

import XCEUniFlow
import XCEOperationFlow

//---

public
protocol ConcurrentProcess: Feature, NoBindings
{
    associatedtype Input
    associatedtype Output

    //---

    typealias Implementation =
        (Input, UUID, @escaping SubmitAction) -> OperationFlow

    //---

    static
    var run: Implementation { get }

    static
    var minDelay: TimeInterval { get }
}
