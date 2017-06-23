import Foundation

class Logger {
    static func logMessageWithClassName(className: String, message:String, level: MessageLevel)
    {
        print("\(DateUtility.dateForPrint()), \(String(describing: level).capitalized) in class: \(className), message: \(message)")
    }
    
    static func logMessage(message: String, level: MessageLevel) {
        print("\(DateUtility.dateForPrint()), \(String(describing: level).capitalized) message: \(message)")
    }

}

enum MessageLevel {
    case info
    case warn
    case error
    
    init() {
        self = .info
    }
}
