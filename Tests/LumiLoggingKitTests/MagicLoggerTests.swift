import Foundation
import Testing

@testable import LumiLoggingKit

/// 日志收集器
@Suite("MagicLogger / 日志收集", .serialized)
@MainActor
struct MagicLoggerTests {
    /// addLog 通过主队列异步追加，等待队列排空后再断言。
    private func flush() async {
        try? await Task.sleep(for: .milliseconds(30))
    }

    @Test("记录日志后进入列表")
    func loggedEntryIsCollected() async {
        let logger = MagicLogger(app: "TestApp")

        logger.info("加载用户数据")
        await flush()

        #expect(logger.logs.count == 1)
        #expect(logger.logs.first?.originalMessage == "加载用户数据")
        #expect(logger.logs.first?.level == .info)
        #expect(logger.app == "TestApp")
    }

    @Test("不同级别分别记录")
    func levelsAreRecordedSeparately() async {
        let logger = MagicLogger(app: "TestApp")

        logger.info("i")
        logger.warning("w")
        logger.error("e")
        logger.debug("d")
        await flush()

        #expect(logger.logs.count == 4)
        #expect(Set(logger.logs.map(\.level)).count == 4)
    }

    @Test("清空日志后列表为空")
    func clearLogsEmptiesTheList() async {
        let logger = MagicLogger(app: "TestApp")
        logger.info("first")
        await flush()
        #expect(logger.logs.count == 1)

        logger.clearLogs()

        #expect(logger.logs.isEmpty)
    }

    @Test("日志条数被限制在上限内")
    func logCountIsCapped() async {
        let logger = MagicLogger(app: "TestApp")

        for index in 0..<1100 {
            logger.info("entry-\(index)")
        }
        await flush()

        #expect(logger.logs.count == 1000, "日志条数应被裁剪到 1000 条")
        #expect(logger.logs.last?.originalMessage == "entry-1099", "应保留最新的日志")
    }
}

/// 静态入口（写入共享日志器）
@Suite("MagicLogger / 静态入口", .serialized)
@MainActor
struct MagicLoggerStaticEntryTests {
    private func flush() async {
        try? await Task.sleep(for: .milliseconds(30))
    }

    @Test("静态入口写入共享日志器")
    func staticEntryPointsUseSharedLogger() async {
        let before = MagicLogger.shared.logs.count

        MagicLogger.info("shared-info")
        await flush()

        #expect(MagicLogger.shared.logs.count == before + 1)
        #expect(MagicLogger.shared.logs.last?.originalMessage == "shared-info")
        #expect(MagicLogger.shared.logs.last?.level == .info)

        MagicLogger.clearLogs()
    }

    @Test("静态清空会清掉共享日志器")
    func staticClearEmptiesSharedLogger() async {
        MagicLogger.warning("shared-warning")
        await flush()
        #expect(!MagicLogger.shared.logs.isEmpty)

        MagicLogger.clearLogs()

        #expect(MagicLogger.shared.logs.isEmpty)
    }
}
