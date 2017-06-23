import Foundation

class NSDictionaryUtility {
    static func getChildren(json: NSDictionary, parent: String) -> [NSDictionary]? {
        return json[parent] as? [NSDictionary]
    }
}
