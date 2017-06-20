import Foundation
import RxSwift

//at the top
var workScheduler: SchedulerType = ConcurrentDispatchQueueScheduler(qos: .default)

//the template
print("this is a template")
let values = [0.377738601, 0.355108811, 0.332934121, 0.310570321, 0.28819531, 0.265496441, 0.241696751, 0.2211951, 0.198679661, 0.176595971, 0.154260281, 0.131820181, 0.109704291, 0.08708391101, 0.0646719112, 0.04256307112, 0.02015656122, -0.002069704132, -0.02424728142, -0.04678077142, -0.06894988152, -0.09178396162, -0.1135394172, -0.1363675172, -0.1587424182, -0.1820433192, -0.2031176202, -0.2255386203, -0.2485248213, -0.2703245223, -0.2925764233, -0.3152012233, -0.3371836243, -0.3598265253, -0.3822205263, -0.4044759263, -0.4268584273, -0.4491625283, -0.4714891293, -0.4937174293, -0.5161078303]
//let v = [0.4, 0.3, 0.2, 0.1, 0.0, -0.1, -0.2, -0.3, -0.4, -0.5, -0.6, -0.7, -0.8]
let obs = Observable<Double>.from(values)

obs.mySubscribe()

//at bottom
playgroundTimeLimit(seconds: 10)

extension Observable {
    
    func mySubscribe() {
        self.subscribeOn(workScheduler)
        self.subscribe(
            onNext: { s in
                let input = s as! Double
                let a = input - 0.4
                let b = -a * 100
                let c = b + 40
                let v = -((input - 0.4) * 100) / 3
                print("\(input)   \(-a)   \(b)   \(c) ")
//                if (v >= 1000) {
//                    print("onNext:\(s) \(v) ---")
//                } else {
//                    print("onNext:\(s) \(v)")
//                }
                
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