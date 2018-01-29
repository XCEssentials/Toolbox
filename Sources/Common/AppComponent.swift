public
protocol AppComponent { } // might be model/feature

//---

public
protocol NestedType
{
    associatedtype Parent
}

//---

public
protocol VisualAppComponent: AppComponent
{
    associatedtype ViewModel // conform to NestedType!
    associatedtype Controller //: UIViewController ???
    associatedtype View //: UIView
}
