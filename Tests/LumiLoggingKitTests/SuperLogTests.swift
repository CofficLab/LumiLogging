import Foundation
import Testing

@testable import LumiLoggingKit

/// 用于验证 SuperLog 默认实现的样例类型。
private struct SampleLogger: SuperLog {
    static var emoji: String { "🧪" }
}

/// 未提供 emoji 的类型：应回退到按类名推断的 emoji。
private struct PlainLogger: SuperLog {}

/// SuperLog 前缀与工具方法
@Suite("SuperLog / 日志前缀")
struct SuperLogTests {
    @Test("前缀包含 QoS 标记、emoji 与对齐后的作者名")
    func prefixContainsQoSEmojiAndAuthor() {
        let prefix = SampleLogger.t

        #expect(prefix.contains(" | "))
        #expect(prefix.contains("🧪"))
        #expect(prefix.contains(SampleLogger.author))
        #expect(prefix.hasSuffix(" | "))
    }

    @Test("作者名去掉泛型参数")
    func authorStripsGenericParameters() {
        #expect(SampleLogger.author == "SampleLogger")
        #expect(!SampleLogger.author.contains("<"))
    }

    @Test("作者名至少补齐到 27 个字符")
    func authorIsPaddedToFixedWidth() {
        let padded = SampleLogger.author.padding(toLength: 27, withPad: " ", startingAt: 0)

        #expect(padded.count == 27)
        #expect(SampleLogger.t.contains(padded), "前缀未包含补齐后的作者名")
    }

    @Test("未定义 emoji 时按类名推断")
    func emojiFallsBackToAuthorBasedEmoji() {
        #expect(PlainLogger.emoji == PlainLogger.author.generateContextEmoji())
    }

    @Test("原因标记使用箭头前缀")
    func reasonMarkerUsesArrow() {
        let logger = SampleLogger()

        #expect(logger.r("密码错误") == " ➡️ 密码错误")
        #expect(logger.makeReason("原因") == " ➡️ 原因")
    }

    @Test("实例属性与静态属性一致")
    func instanceAndStaticPropertiesMatch() {
        let logger = SampleLogger()

        #expect(logger.author == SampleLogger.author)
        #expect(logger.className == SampleLogger.author)
        #expect(logger.t == SampleLogger.t)
        #expect(logger.a == SampleLogger.onAppear)
        #expect(logger.i == SampleLogger.onInit)
    }

    @Test("生命周期标记带上前缀")
    func lifecycleMarkersUsePrefix() {
        #expect(SampleLogger.onAppear.hasPrefix(SampleLogger.t))
        #expect(SampleLogger.onInit.hasPrefix(SampleLogger.t))
        #expect(SampleLogger.onAppear.contains("OnAppear"))
        #expect(SampleLogger.onInit.contains("Init"))
    }

    @Test("时长换算为毫秒字符串")
    func durationConvertsToMilliseconds() {
        #expect(SampleLogger.ms(.milliseconds(12.34)) == "12.34")
        #expect(SampleLogger.ms(.milliseconds(0)) == "0.00")
        #expect(SampleLogger.ms(.seconds(1)) == "1000.00")
    }

    @Test("主线程判定与线程状态一致")
    func mainThreadDetection() {
        // Swift Testing 的用例不一定跑在主线程，这里断言与 Thread.isMainThread 一致。
        #expect(SampleLogger().isMain == Thread.isMainThread)
    }
}
