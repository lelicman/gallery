//
//  SessionRepository.swift
//  FlightRadar
//
//  Created by Alexey Bondar on 3/28/23.
//  Copyright © 2023 Apalon. All rights reserved.
//

import Foundation

protocol SessionRepositoryProtocol {
    func getSession(of kind: Sessionable.Type) -> Sessionable?
    func setSession(_ session: Sessionable?)
}

class SessionRepository: SessionRepositoryProtocol {
    static let shared: SessionRepositoryProtocol = SessionRepository()
    
    private var sessions: [String: Sessionable] = [:]
    
    init() {}
    
    func getSession(of kind: Sessionable.Type) -> Sessionable? {
        sessions[String(describing: kind)]
    }
    
    func setSession(_ session: Sessionable?) {
        guard let session = session else {
            sessions.removeValue(forKey: String(describing: type(of: session)))
            return
        }
        sessions[String(describing: type(of: session))] = session
    }
}
