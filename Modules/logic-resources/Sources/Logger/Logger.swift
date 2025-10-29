import Foundation

public enum LogLevel {
  case debug
  case info
  case warning
  case error

  var emoji: String {
    switch self {
    case .debug: return "🔍"
    case .info: return "ℹ️"
    case .warning: return "⚠️"
    case .error: return "❌"
    }
  }
}

public func log(_ message: @autoclosure () -> Any,
                level: LogLevel = .info,
                file: String = #file,
                function: String = #function,
                line: Int = #line) {
#if DEBUG
  let fileName = URL(fileURLWithPath: file).lastPathComponent
  let functionName = function
  let output = """
        \(level.emoji) \(fileName):\(line) - \(functionName)
        \(message())
        """
  print(output)
#endif
  // No logging happens in RELEASE builds
}
