//
//  Logging.swift
//  AgeVerification
//
//  Created by Bharat Jagtap on 22/08/25.
//

import Foundation
import os
import Swinject

// MARK: - Global Swift print overrides
#if !DEBUG
@inline(__always)
func print(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  // no-op
}

@inline(__always)
func debugPrint(_ items: Any..., separator: String = " ", terminator: String = "\n") {
  // no-op
}

@inline(__always)
func dump<T>(_ value: T,
             name: String? = nil,
             indent: Int = 0,
             maxDepth: Int = .max,
             maxItems: Int = .max) -> T {
  return value // no log output
}
#endif

// MARK: - Global Objective-C NSLog override
#if !DEBUG
func NSLog(_ format: String, _ args: CVarArg...) {
  // no-op
}
#endif

// MARK: - Unified Logging (Logger / os_log) overrides
#if !DEBUG
extension Logger {
  func log(level: OSLogType, _ message: OSLogMessage) {}
  func trace(_ message: OSLogMessage) {}
  func debug(_ message: OSLogMessage) {}
  func info(_ message: OSLogMessage) {}
  func notice(_ message: OSLogMessage) {}
  func warning(_ message: OSLogMessage) {}
  func error(_ message: OSLogMessage) {}
  func critical(_ message: OSLogMessage) {}
}

// Also override the old os_log API
@_transparent
func os_log(_ message: StaticString, _ args: CVarArg...) {
  // no-op
}
#endif

// MARK: - Auto-disable logs at runtime using environment variable
// This prevents *system* and *framework* logs from showing in Release
// (they may still exist internally but won’t appear in Console/Xcode logs).
#if !DEBUG
func disableUnifiedLogging() {
  setenv("OS_ACTIVITY_MODE", "disable", 1)
}

// Call this early in app startup, e.g. in AppDelegate.init()
#endif

#if !DEBUG
func disableSwinjectLogging() {
  Container.loggingFunction = nil
}
#endif
