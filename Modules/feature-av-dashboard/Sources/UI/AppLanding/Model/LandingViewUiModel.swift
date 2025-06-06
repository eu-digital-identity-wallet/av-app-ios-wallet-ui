//
//  LandingViewUiModel.swift
//  feature-av-dashboard
//
//  Created by A200156428 on 04/06/25.
//

import logic_core
import logic_ui
import Copyable

@Copyable
public struct LandingViewUiModel: Equatable, Identifiable, Routable {
    
    public let id: String
    public let docClaims: [DocClaim]
    
    public var log: String {
        "id: \(id), docClaims: \([docClaims])"
    }
    
    public init(
        id: String,
        docClaims: [DocClaim]
    ) {
        self.id = id
        self.docClaims = docClaims
    }
}

extension LandingViewUiModel {
    static func mock() -> LandingViewUiModel {
        LandingViewUiModel(id: "id",
                           docClaims: [])
    }
}


public extension DocClaimsDecodable {
  func transformToLandingUi() -> LandingViewUiModel {
      
      return LandingViewUiModel(
        id: self.id,
        docClaims: self.docClaims
      )
  }
}
