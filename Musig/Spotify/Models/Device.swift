import Foundation

struct Device: Codable {
    let id: String
    let isActive: Bool?
    let isPrivateSession: Bool?
    let isRestricted: Bool?
    let name: String
    let type: String?
    let volumePercent: Int?
}
