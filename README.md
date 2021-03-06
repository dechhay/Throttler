# Throttler

Throttler is a component object you can use for regulating the rate of performing a process.

Processes can easily be defined using a closure.  You can also customize the delay time, and even change its dispatch queue.

## Why not just use RxSwift?

This library was intended as a small component with simplicity in mind.  You do not need to learn complicated syntaxes.  Functions were designed to have few inputs, making your code simpler and cleaner.

## How do I use it?

By creating a Throttler instance, you can define a process using a closure, and customize the timing if desired.  After setting up, simply call `throttle()` on the Throttler instance, it's that easy!

## Example

Lets say you want to automatically send a search request as you type into a UISearchBar, but don't want to send a request for every key pressed. Because you are a responsible developer, you want to *regulate* the search. This can be done easily using the Throttler as shown below.

```swift
func commonInit() {
    let delay: TimeInterval = 0.5
    let dispatchQueue = DispatchQueue.main
    let dispatchBlock = { [weak self] in
        guard let strongSelf = self,
              let searchString = strongSelf.searchBar.text else {
                  return
        }
        strongSelf.searchService.search(searchString)// send search request
     }
    throttler = Throttler(delay: delay, dispatchQueue: dispatchQueue, dispatchBlock: dispatchBlock)
}

func searchBar(_ searchBar: UISearchBar, textDidChange searchText: String) {
    // We don't want to send a search request for every character typed.
    // But using the throttler, it will fire off only after the delay time.
    throttler.throttle()
}

func searchBarSearchButtonClicked(_ searchBar: UISearchBar) {
    // But we can also fire off immediately
    throttler.fire()
}
    
```
