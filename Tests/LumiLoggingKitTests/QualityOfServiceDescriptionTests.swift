import Foundation
import Testing

@testable import LumiLoggingKit

/// QoS 描述文案
@Suite("QualityOfService / QoS 描述")
struct QualityOfServiceDescriptionTests {
    @Test("带名称时包含 QoS 名称")
    func descriptionWithNameIncludesTheName() {
        #expect(QualityOfService.userInteractive.description().contains("UserInteractive"))
        #expect(QualityOfService.userInitiated.description().contains("UserInitiated"))
        #expect(QualityOfService.default.description().contains("Default"))
        #expect(QualityOfService.utility.description().contains("Utility"))
        #expect(QualityOfService.background.description().contains("Background"))
    }

    @Test("不带名称时只保留 emoji 标记")
    func descriptionWithoutNameIsCompact() {
        let cases: [(QualityOfService, String)] = [
            (.userInteractive, "🔥"),
            (.userInitiated, "2️⃣"),
            (.default, "3️⃣"),
            (.utility, "4️⃣"),
            (.background, "5️⃣"),
        ]

        for (qos, expected) in cases {
            #expect(qos.description(withName: false) == expected)
            #expect(!qos.description(withName: false).contains(" "))
        }
    }

    @Test("带名称时以 emoji 开头")
    func descriptionWithNameStartsWithEmoji() {
        for qos in [
            QualityOfService.userInteractive,
            .userInitiated,
            .default,
            .utility,
            .background,
        ] {
            #expect(
                qos.description().hasPrefix(qos.description(withName: false)),
                "\(qos) 的带名称描述未以 emoji 开头"
            )
        }
    }

    @Test("全部可构造的 QoS 都有描述")
    func everyConstructibleQosHasDescription() {
        let cases: [QualityOfService] = [
            .userInteractive, .userInitiated, .default, .utility, .background,
        ]

        for qos in cases {
            #expect(!qos.description().isEmpty)
            #expect(!qos.description(withName: false).isEmpty)
        }
    }

    @Test("线程 QoS 标记非空")
    func threadQoSDescriptionIsNotEmpty() {
        #expect(!Thread.currentQosDescription.isEmpty)
    }
}
