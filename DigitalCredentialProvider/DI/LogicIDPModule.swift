import Swinject
import logic_business
import logic_ui
import DcApi18013AnnexC

public final class LogicIDPModule: Assembly {

  public init() {}

  public func assemble(container: Container) {
    // Register DcApiHandler
    container.register(DcApiHandler.self) { _ in
      let serviceName = Bundle.getDocumentStorageServiceName()
      let accessGroup = LogicIDPModule.getKeychainAccessGroup()
      return DcApiHandler(
        serviceName: serviceName,
        accessGroup: accessGroup
      )
    }
    .inObjectScope(ObjectScope.container)

    container.register(RouterHost.self) { _ in
      return DigitalCredentialProviderRouter()
    }
    .inObjectScope(ObjectScope.container)

  }
}

extension LogicIDPModule {
  static func getKeychainAccessGroup() -> String {
    return Bundle.getKeychainAccessGroup()
  }
}

final class DocumentProviderDIContainer {
  static let shared = DocumentProviderDIContainer()
  let container: Container

  private init() {
    container = Container()
    setupDependencies()
  }

  private func setupDependencies() {
    DIGraph.assembleDependenciesGraph()
  }

  func resolve<T>(_ type: T.Type) -> T {
    guard let resolved = container.resolve(type) else {
      fatalError("Failed to resolve \(type)")
    }
    return resolved
  }
}
