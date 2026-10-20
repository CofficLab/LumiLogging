import AppKit
import Foundation
import Testing

@testable import LumiLoggingKit

/// 日志条目模型
@Suite("MagicLogEntry / 日志条目")
struct MagicLogEntryTests {
    @Test("保留原始消息并组合出展示消息")
    func entryKeepsOriginalMessage() {
        let entry = MagicLogEntry(message: "加载用户数据", level: .info)

        #expect(entry.originalMessage == "加载用户数据")
        #expect(entry.message.contains("加载用户数据"))
        #expect(entry.message.contains(" | "))
        #expect(entry.message.hasSuffix(entry.originalMessage.withContextEmoji))
    }

    @Test("记录级别、调用方与行号")
    func entryCarriesMetadata() {
        let entry = MagicLogEntry(
            message: "hello",
            level: .warning,
            caller: "UserService",
            line: 42
        )

        #expect(entry.level == .warning)
        #expect(entry.caller == "UserService")
        #expect(entry.line == 42)
    }

    @Test("默认调用方为空、行号缺省")
    func entryDefaultsAreEmpty() {
        let entry = MagicLogEntry(message: "hello", level: .debug)

        #expect(entry.caller.isEmpty)
        #expect(entry.line == nil)
    }

    @Test("每个级别都有唯一图标")
    func everyLevelHasDistinctIcon() {
        let levels: [MagicLogEntry.Level] = [.info, .warning, .error, .debug]
        let icons = levels.map(\.icon)

        for level in levels {
            #expect(!level.icon.isEmpty)
        }
        #expect(Set(icons).count == levels.count, "级别图标存在重复：\(icons)")
    }

    @Test("每个级别都有可区分的颜色")
    func everyLevelHasDistinctColor() {
        let levels: [MagicLogEntry.Level] = [.info, .warning, .error, .debug]
        let resolved = levels.map { NSColor($0.color).usingColorSpace(.sRGB) }

        for color in resolved {
            #expect(color != nil, "\(levels) 的颜色无法转换")
        }

        // warning / error / debug 必须是三种可区分的颜色。
        let distinct = resolved.dropFirst().compactMap { $0 }.map {
            "\($0.redComponent),\($0.greenComponent),\($0.blueComponent)"
        }
        #expect(Set(distinct).count == 3, "级别颜色存在重复：\(distinct)")
    }

    @Test("时间戳默认为当前时间")
    func timestampDefaultsToNow() {
        let before = Date()
        let entry = MagicLogEntry(message: "hello", level: .info)
        let after = Date()

        #expect(entry.timestamp >= before)
        #expect(entry.timestamp <= after)
    }
}
