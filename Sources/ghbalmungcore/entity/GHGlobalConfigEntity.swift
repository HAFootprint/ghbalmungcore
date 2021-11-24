//
//  GHGlobalConfigEntity.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

internal struct GHGlobalConfigEntity: Decodable {
    var version: String?
    var timeOutInterval: Int?
    var identifierServerList: [GHEnvironmentEntity]?
    var bundleIdentifierJsonMock: String?

    private enum CodingKeys: String, CodingKey {
        case version
        case timeOutInterval
        case identifierServerList
        case bundleIdentifierJsonMock
    }

    init(from decoder: Decoder) throws {
        let container = try decoder.container(keyedBy: CodingKeys.self)
        
        self.version                = try container.decodeIfPresent(String?.self, forKey: .version) ?? .empty
        self.timeOutInterval        = try container.decodeIfPresent(Int?.self, forKey: .timeOutInterval) ?? 0
        
        self.identifierServerList   = try container.decodeIfPresent(
            [GHEnvironmentEntity]?.self,
            forKey: .identifierServerList
        ) ?? []
        
        self.bundleIdentifierJsonMock = try container.decodeIfPresent(
            String?.self,
            forKey: .bundleIdentifierJsonMock
        ) ?? .empty
    }
}
