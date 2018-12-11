# Throttler

Throttler is a component object you can use for regulating the rate of performing a process.

## Why is this useful?

Because you can achieve throttling behavior with just a small component.  Processes can easily be defined using a closure.  You can also customize the Throttler's delay time, and even change its dispatch queue.

## Why not just use RxSwift?

This library was intended as a small component with simplicity in mind.  You do not need to learn complicated syntaxes.  Functions were designed to have few inputs, making your code simpler.

## How to use?

Lets say you want to regulate firing off a network request to search using a UISearchBar.  You should not send a search request for every key pressed.
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
