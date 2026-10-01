import SwiftData
import Foundation
import CryptoKit

@Model
public final class JanusMemory {
    public var timestamp: Date
    public var contextHash: String
    public var payload: Data
    public var frequencyTag: String = "12_ALPHA"
    
    public init(timestamp: Date = .now, contextHash: String, payload: Data) {
        self.timestamp = timestamp
        self.contextHash = contextHash
        self.payload = payload
    }
}

public actor JanusDataController {
    private let container: ModelContainer
    public init() {
        let schema = Schema([JanusMemory.self])
        let configuration = ModelConfiguration(schema: schema, isStoredInMemoryOnly: false)
        do {
            self.container = try ModelContainer(for: schema, configurations: [configuration])
            print("✅ SwiftData container monté – Persistance souveraine active")
        } catch {
            fatalError("Échec SwiftData : \(error)")
        }
    }
}
