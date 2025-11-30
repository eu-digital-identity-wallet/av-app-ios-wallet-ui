import logic_business
import feature_issuance
import logic_storage
import logic_ui
import logic_assembly
import logic_authentication

public extension DIGraph {

  static func assembleDependenciesGraph() {
    DIGraph.shared.lazyLoad(
      with: [
        // Logic Modules
        LogicBusinessAssembly(),
        LogicCoreAssembly(),
        LogicUiAssembly(),
        LogicAuthAssembly(),
        LogicAssemblyModule(),
        LogicStorageAssembly(),
        // Feature Modules
        FeatureCommonAssembly(),
        LogicIDPModule(),
        FeatureIssuanceAssembly()
      ]
    )
  }
}
