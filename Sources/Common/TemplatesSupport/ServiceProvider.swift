import XCEUniFlow

//---

public
protocol ServiceProvider: Feature, NoBindings
{
    associatedtype Service
}
