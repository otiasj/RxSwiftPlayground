import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//the template
print("Replay subject will repeat last N number of values, even the ones before the subscription happened. The N is the buffer, so for our example it’s 3")

let subject = ReplaySubject<String>.create(bufferSize: 3)
let observable : Observable<String> = subject

subject.onNext("hi1")
subject.onNext("hi2")
subject.onNext("hi3")
subject.onNext("hi4")

observable.mySubscribe()

subject.onNext("hi5")
subject.onNext("hi6")

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
