import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//the template
print(" When you subscribe to it, you will only get the values that were emitted after the subscription.")

let subject = PublishSubject<String>()
let observable : Observable<String> = subject

subject.onNext("hi1")
subject.onNext("hi2")
observable.mySubscribe()
subject.onNext("hi3")
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
