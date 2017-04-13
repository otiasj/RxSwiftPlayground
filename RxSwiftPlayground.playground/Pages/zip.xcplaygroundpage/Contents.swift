//: [Previous](@previous)

import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

let intObservable = Observable<Int>.from([1, 2, 3, 4, 5, 10, 11, 12, 13])
let stringObservable = Observable<String>.from(["first", "second", "third", "forth", "etc"])
    
let zipObservable = Observable<(Int, String)>.zip(intObservable, stringObservable) { (intValue, stringValue) in
    return (myIntResult: intValue, myStringResult: stringValue)
}

zipObservable.mySubscribe()

//at bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func mySubscribe() {
        self.subscribeOn(workScheduler)
        self.subscribe(
            onNext: { s in
                print(s)
        },
            onError: {
                e in
                print("on Error \(e)")
        },
            onCompleted: {
                print("onCompleted")
        },
            onDisposed: {
                print("onDisposed")
        })
    }
}
