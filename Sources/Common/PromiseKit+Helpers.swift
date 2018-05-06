import PromiseKit

//---

public
extension CatchMixin
{
    @discardableResult
    func ignoreIfFails() -> PMKFinalizer
    {
        return self.catch{ _ in }
    }
}
