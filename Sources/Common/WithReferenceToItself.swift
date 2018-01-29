public
protocol WithReferenceToItself { }

//---

public
extension WithReferenceToItself
{
    typealias Itself = Self
}
