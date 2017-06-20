import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//the template
print("BehaviorSubject<T> is similar to ReplaySubject<T> except it only remembers the last publication. BehaviorSubject<T> also requires you to provide it a default value of T. This means that all subscribers will receive a value immediately (unless it is already completed).")

let subject = BehaviorSubject<String>(value: "Initial value")
let observable : Observable<String> = subject

subject.onNext("hi1")
subject.onNext("hi2")
subject.onNext("hi3")

observable.mySubscribe()

subject.onNext("hi4")
subject.onNext("hi5")

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
