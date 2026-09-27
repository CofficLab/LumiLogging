import Foundation
import LumiLocalizationKit

public enum LumiLoggingLocalization {
    public static func string(_ key: String, bundle: Bundle, locale: Locale = .current) -> String {
        LumiLocalization.string(key, bundle: bundle, locale: locale)
    }
}

@available(*, deprecated, renamed: "LumiLoggingLocalization")
public typealias KitSuperLogLocalization = LumiLoggingLocalization
