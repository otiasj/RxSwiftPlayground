//: [Previous](@previous)

import Foundation


import Foundation
import RxSwift

struct Test {
    let value: String
    
    init(_ value: String){
        self.value = value
    }
    
    var description: String {
        return value
    }
}

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//the template
print("Merge: combine multiple Observables into one by merging their emissions")

let someObservable = Observable<Test>.from([Test("1"), Test("2"), Test("3"), Test("4"), Test("5"), Test("6"), Test("7")])
let stringObservable = Observable<Test>.from([Test("first"), Test("second"), Test("third"), Test("forth"), Test("etc")])


let obs = Observable<Test>.merge(someObservable, stringObservable)
obs.mySubscribe()

//at bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func mySubscribe() {
        self.subscribeOn(workScheduler)
        self.subscribe(
            onNext: { s in
                print("onNext:\(s)")
        },
            onError: {
                e in
                print("on Error:\(e)")
        },
            onCompleted: {
                print("onCompleted")
        },
            onDisposed: {
                print("onDisposed")
        })
    }
}
