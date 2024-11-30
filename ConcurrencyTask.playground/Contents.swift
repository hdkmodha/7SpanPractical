import UIKit
import PlaygroundSupport

var greeting = "Hello, playground"

func fetchMessage(withCompletion completion: @escaping @Sendable (String) -> Void) {
    let queue = DispatchQueue(label: "messageQueue", attributes: .concurrent)
    let group = DispatchGroup()
    
    var firstMessage: String?
    var secondMessage: String?
    var isTimeOut = false
    
    let timeOut = DispatchTime.now() + 2
    
    group.enter()
    fetchMessageOne { message in
        if DispatchTime.now() > timeOut {
            isTimeOut = true
        } else {
            firstMessage = message
        }
        group.leave()
    }
    
    group.enter()
    fetchMessageTwo { message in
        if DispatchTime.now() > timeOut {
            isTimeOut = true
        } else {
            secondMessage = message
        }
        group.leave()
    }
    
    group.notify(queue: queue) {
        let result: String
        print("Group Notified")
        if isTimeOut {
            result = "Unable to load message: Time out exceeded"
        } else if let messageOne = firstMessage, let messageSecond = secondMessage {
            result = "\(messageOne)  \(messageSecond)"
        } else {
            result = "Unable to load message: No messages received"
        }
        
        DispatchQueue.main.async {
            completion(result)
        }
    }
    
    group.wait(timeout: timeOut)
    
//    queue.asyncAfter(deadline: timeOut) {
//        group.notify(queue: .main) { [isTimeOut] in
//            if isTimeOut {
//                completion("Unable to load message - Time out exceeded")
//            }
//        }
//    }
}

func fetchMessageOne(withCompletion completion: @escaping @Sendable (String) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        completion("Hello")
    }
}

func fetchMessageTwo(withCompletion completion: @escaping @Sendable (String) -> Void) {
    DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
        completion("World")
    }
}

DispatchQueue.main.async {
    print("Fetching Messages")
    fetchMessage { message in
        print(message)
    }
}

PlaygroundPage.current.needsIndefiniteExecution = true

