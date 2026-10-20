import Foundation
import Testing

@testable import LumiLoggingKit

/// 上下文 emoji 推断
@Suite("ContextEmoji / 上下文 emoji")
struct ContextEmojiTests {
    @Test("常见日志关键词命中对应 emoji")
    func keywordsMapToExpectedEmoji() {
        let cases: [(String, String)] = [
            ("加载 user data", "💾"),
            ("保存完成", "✅"),
            ("插件加载", "💾"),
            ("网络请求失败", "❌"),
            ("HTTP 请求", "🌐"),
            ("跳过此项", "⏭️"),
            ("测试用例", "🔍"),
            ("显示结果", "👀"),
            ("准备好了", "✅"),
        ]

        for (text, expected) in cases {
            #expect(
                text.generateContextEmoji() == expected,
                "\(text) 期望 \(expected)，实际 \(text.generateContextEmoji())"
            )
        }
    }

    @Test("多个关键词命中时按映射表顺序取第一个")
    func firstMatchingKeywordWins() {
        // 映射表是定序的：先命中的关键词决定 emoji。
        // "配置"（config）排在 "更新"（update）之前。
        #expect("配置已更新".generateContextEmoji() == "🚩")
        // "内存"（memory）排在 "警告"（warning）之前。
        #expect("警告：内存不足".generateContextEmoji() == "📊")
        // "完成"（complete）排在 "保存"（save）之前。
        #expect("保存完成".generateContextEmoji() == "✅")
    }

    @Test("关键词匹配不区分大小写")
    func matchingIsCaseInsensitive() {
        #expect("LOADING".generateContextEmoji() == "💾")
        #expect("Loading".generateContextEmoji() == "💾")
        #expect("loading".generateContextEmoji() == "💾")
    }

    @Test("未命中任何关键词时回退到通用标记")
    func unknownTextFallsBackToGenericEmoji() {
        #expect("zzz-unrelated-text".generateContextEmoji() == "📝")
        #expect("".generateContextEmoji() == "📝")
    }

    @Test("withContextEmoji 在原文前拼接 emoji")
    func withContextEmojiPrefixesTheMessage() {
        let text = "加载用户数据"

        #expect(text.withContextEmoji == "💾 \(text)")
    }

    @Test("withContextEmoji 保留原始文本")
    func withContextEmojiKeepsOriginalText() {
        let text = "zzz-unrelated-text"

        #expect(text.withContextEmoji.hasSuffix(text))
        #expect(text.withContextEmoji.contains(text))
    }
}
