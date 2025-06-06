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


public extension DocClaimsDecodable {
  func transformToLandingUi() -> LandingViewUiModel {
      
      return LandingViewUiModel(
        id: self.id,
        docClaims: self.docClaims
      )
      
      
//      let docClaims: [DocClaim] =
//      parseClaim(
//        documentId: self.id,
//        isSensitive: isSensitive,
//        input: docClaims
//      )
//
//      LandingViewUiModelself.docClaims
      
//    var issuer: DocumentUIModel.IssuerField? {
//      guard !self.issuerName.isEmpty else {
//        return nil
//      }
//      return .init(
//        issuersName: self.issuerName,
//        logoUrl: self.issuerLogo,
//        isVerified: true
//      )
//    }
//
//    let documentFields: [GenericExpandableItem] =
//    parseClaim(
//      documentId: self.id,
//      isSensitive: isSensitive,
//      input: docClaims
//    )
//
//    var bearerName: String {
//      guard let fullName = getBearersName() else {
//        return ""
//      }
//      return "\(fullName.first) \(fullName.last)"
//    }

//    return .init(
//      id: id,
//      type: documentTypeIdentifier,
//      documentName: displayName.orEmpty,
//      issuer: issuer,
//      createdAt: createdAt,
//      hasExpired: hasExpired,
//      documentFields: documentFields
//    )
  }
}

public extension DocClaimsDecodable {
  func parseClaim(
    documentId: String,
    isSensitive: Bool,
    input: [DocClaim]
  ) -> [GenericExpandableItem] {
    input.reduce(into: []) { partialResult, docClaim in

      let title = docClaim.displayName.ifNilOrEmpty { docClaim.name }

      if let nested = docClaim.children {

        var children = parseClaim(
          documentId: documentId,
          isSensitive: isSensitive,
          input: nested
        )

        children = children.sortByName()

        if title.isEmpty {
          partialResult.append(contentsOf: children)
        } else {
          partialResult.append(
            .nested(
              .init(
                collapsed: .init(mainText: .custom(title)),
                expanded: children,
                isExpanded: false
              )
            )
          )
        }
      } else if let uiImage = docClaim.dataValue.image {
        partialResult.append(
          .single(
            .init(
              collapsed: .init(
                mainText: .custom(title),
                leadingIcon: .init(image: Image(uiImage: uiImage)),
                isBlur: isSensitive
              ),
              domainModel: nil
            )
          )
        )
      } else {

        let claim = docClaim
          .parseDate(
            parser: {
              Locale.current.localizedDateTime(
                date: $0,
                uiFormatter: "dd MMM yyyy"
              )
            }
          )
          .parseUserPseudonym()

        partialResult.append(
          .single(
            .init(
              collapsed: .init(
                mainText: .custom(claim.stringValue),
                overlineText: .custom(title),
                isBlur: isSensitive
              ),
              domainModel: nil
            )
          )
        )
      }
    }.sortByName()
  }
}


//public extension LandingViewUiModel {
//    
//    struct IssuerField: Identifiable, Sendable, Equatable {
//        public let id: String
//        public let name: String
//        public let logoUrl: URL?
//        public let isVerified: Bool
//        
//        public init(
//            id: String = UUID().uuidString,
//            issuersName: String,
//            logoUrl: URL?,
//            isVerified: Bool
//        ) {
//            self.id = id
//            self.name = issuersName
//            self.logoUrl = logoUrl
//            self.isVerified = isVerified
//        }
//    }
//}
