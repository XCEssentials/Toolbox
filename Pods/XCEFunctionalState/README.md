[![GitHub tag](https://img.shields.io/github/tag/XCEssentials/FunctionalState.svg)](https://github.com/XCEssentials/FunctionalState/releases)
[![CocoaPods](https://img.shields.io/cocoapods/v/XCEFunctionalState.svg)](https://cocoapods.org/?q=XCEFunctionalState)
[![CocoaPods](https://img.shields.io/cocoapods/p/XCEFunctionalState.svg)](https://cocoapods.org/?q=XCEFunctionalState)
[![license](https://img.shields.io/github/license/XCEssentials/FunctionalState.svg)](https://opensource.org/licenses/MIT)

# Introduction

Turn any object into discrete system and describe its states declaratively.



# How to install

The recommended way is to install using [CocoaPods](https://cocoapods.org/?q=XCEFunctionalState):

```ruby
pod 'XCEFunctionalState', '~> 2.8'
```



# How it works

This library allows to turn any object into [discrete system](https://en.wikipedia.org/wiki/Discrete_system) by defining a number of distinct states and then applying these states instantly or via transition.



# How to use

A typical use case for this library is for re-configuring instances of `UIView` and its subclasses as your app state changes.



## State

Each state defines how it's being applied, as well as how it's being updated (when it's been requested to be applied while it's already current state), plus transitions for each of these operations (instant by default).



## Stateful

Let's say we have a class `SearchView` that represents a view with text field where user can enter their search keyword and button that starts a search process. It must conform to `Stateful` protocol to become discrete system.

```swift
import XCEFunctionalState

class SearchView: Stateful
{
    let keyword = UITextField()
    let start = UIButton()
    
    private(set)
    lazy
    var state: Dispatcher<MyView> = Dispatcher(for: self)
}
```

To describe a state for a given class, define a class level function (its name will be interpreted as the state name) inside this class that returns a `State` for this class.

For example, let's define `awaiting` state for our `SearchView` class in which both `keyword` text field and `start` button are enabled and available for user input. Note that we can define as many input parameters as we want for the function, and this gives us opportunity to pass any kind of values from the outside into the state configuration closure. See how in the example below we can pass default value for `keyword` field.

```swift
extension SearchView
{
    static
    func awaiting(with keyword: String) -> State<SearchView>
    {
        return state{

            $0.keyword.text = keyword
            $0.keyword.isEnabled = true
            $0.start.isEnabled = true
        }
    }
}
```

Once user has entered search keyword and tapepd `start` button we may want to lock these controls while search is in progress. To do so, we may want to apply a state `locked` on the search view, which may be declared as follows:

```swift
extension SearchView
{
    static
    func locked() -> State<SearchView>
    {
        return state{

            $0.keyword.isEnabled = false
            $0.start.isEnabled = false
        }
    }
}
```

Later in time, we can apply any of the states declared for the class to an instance of this class as follows:

```swift
let transition: Transition<SearchView> = ... // define transition
let view = SearchView()

view.state.apply{ $0.awaiting(with: "something") }
view.state.apply{ $0.awaiting(with: "another value") } // no effect
view.state.apply(via: transition, MyView.locked()){ /* completion*/ }
//...
view.state.apply{ $0.awaiting(with: "after search") }
```

By default, all mutations are being applied instantly. When working with `UIView`-based classes, it's common to apply changes with animations, and `Transition` type gives full control over it.

`Stateful` protocol also gives a chance to define transitions that should be used by default when we apply a state, but do not provide specific transition explicitly in the state definition.

```swift
extension SearchView
{
    static
    var defaultOnSetTransition: Transition<SearchView> = {
    	
    	(view, mutations, completion) in

        view.alpha = 0.0

        //---

        mutations() // this is closure from the state

        //---

        UIView.animate(
        	withDuration: 1.0,
            animations: { v.alpha = 1.0 },
            completion: completion
        )
    }
    
    static
    var defaultOnUpdateTransition: Transition<SearchView> = {
      
      //...
    }
}
```

`defaultOnSetTransition` in listing above demonstrates transition that hides whole view, then applies mutations from the new state, and then fades in whole view with animation, making it visible again. Alternatively, we could put `mutations()` call inside `animations` closure of the `UIView.animate(…)` call to animate actual mutations during fade-in animation, if so desired.

# Interoperability with Objective-C

To make the result code as concise and self explanatory as possible, as well as to maintaining compile time type safety, this library relies on advanced Swift language features like generics and closure shorthand argument names, so it is NOT intended to be compatible with Objective-C.
