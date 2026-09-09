import Foundation

struct UNIXYZCommand: Codable, Sendable {
    let id: String
    let intent: String
}

protocol UNIXYZCommandSubmitting: Sendable {
    func submit(_ command: UNIXYZCommand) async throws
}

@MainActor
final class UNIXYZViewModel: ObservableObject {
    private let gateway: UNIXYZCommandSubmitting

    init(gateway: UNIXYZCommandSubmitting) {
        self.gateway = gateway
    }

    func submit(_ command: UNIXYZCommand) async throws {
        // Phoenix submits commands. It never directly mutates authoritative UNI.XYZ state.
        try await gateway.submit(command)
    }
}
