import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//a fake login network call
let login = Observable<String>.just("Login result")


//another operation to be done after login was successfull
class anotherObservable {
    var loginResult:String?
    
    //use the login result as parameter
    func setLoginResult(loginResult:String) {
        self.loginResult = loginResult;
    }
    
    func load() -> Observable<String>  {
        return Observable<String>.create { observer in
            let disposable2 = workScheduler.schedule(()) {
                print("init another Observable")
                
                return workScheduler.schedule(()) {
                    print("Running another Observable")
                    if let loginResult = self.loginResult {
                        observer.onNext(">modified \(loginResult)<")
                    }
                    observer.onCompleted()
                    return Disposables.create()
                }
            }
            return Disposables.create {
                disposable2.dispose()
            }
        }
    }
}

//4 operations to be done parallely after login
let obs1 = Observable<Int>.just(1)
let obs2 = Observable<String>.just("someString")
let obs3 = Observable<Void>.empty()
let obs4 = Observable<Bool>.just(true)

//another operation to be done parallely after login, but dependant on login received result
let obs5 = anotherObservable()

//postLogin is a zip of all the operations that need to happen after login
let postLoginRequestObservable = Observable<String>.zip(obs1, obs2, obs3, obs4, obs5.load()) { (obs1Result, obs2Result, obs3Result, obs4Result, obs5Result) in
    
    //All the observable have completed, here are the results:
    let zipResult = "ziped result = \(obs1Result), \(obs2Result), \(obs3Result), \(obs4Result), \(obs5Result)"
    
    return zipResult
}


let loginFlowObs = login.flatMap { (myLoginResult) -> Observable<String> in
    print("login is done, lets do postLogin operations")
    obs5.setLoginResult(loginResult: myLoginResult)
    
    return postLoginRequestObservable
    }
    
loginFlowObs
    //.map { result in print(result.characters.count) }
    .mySubscribe()


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
