//
//  GHEnvironmentEntity.swift
//  ghbalmungcore
//
//  Created by Javier Carapia on 23/11/21.
//

internal struct GHEnvironmentEntity: Decodable {
    var environment: String?
    var urls: [String]?
    var active: Bool?

    private enum CodingKeys: String, CodingKey {
        case environment
        case urls
        case active
    }

    init(from decoder: Decoder) throws {
        let container   = try decoder.container(keyedBy: CodingKeys.self)
        
        self.environment    = try container.decode(String?.self, forKey: .environment)
        self.urls           = try container.decode([String]?.self, forKey: .urls)
        self.active         = try container.decode(Bool?.self, forKey: .active)
    }
}
