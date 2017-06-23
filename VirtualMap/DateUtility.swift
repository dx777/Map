import Foundation

class DateUtility {
    static func dateForPrint() -> String {
        let formatter = DateFormatter()
        formatter.dateFormat = "hh:mm:ss.SSSS"
       return  formatter.string(from: NSDate() as Date)
    }
}
