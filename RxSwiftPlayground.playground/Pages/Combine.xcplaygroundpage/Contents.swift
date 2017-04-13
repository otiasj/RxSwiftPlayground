import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

let login = Observable<String>.just("Login result")

let obs1 = Observable<Int>.just(1)
let obs2 = Observable<String>.just("someString")
let obs3 = Observable<Void>.just()
let obs4 = Observable<Bool>.just(true)

let postLoginRequestObservable = Observable<String>.zip(obs1, obs2, obs3, obs4) { (obs1Result, obs2Result, obs3Result, obs4Result) in
    let zipResult = "ziped result = (\(obs1Result), \(obs2Result), \(obs3Result), \(obs4Result))"
    return zipResult
}

postLoginRequestObservable.mySubscribe()


//at bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func verbose() -> Observable {
        return self.do(onNext: { (nextValue) in
            print(nextValue)
        }, onError: { (someError) in
            print(someError)
        }, onCompleted: { 
            print(".")
        }, onSubscribe: { 
            print("-")
        }, onSubscribed: { 
            print(">")
        }) { 
            print(".")
        }
    }
    
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
