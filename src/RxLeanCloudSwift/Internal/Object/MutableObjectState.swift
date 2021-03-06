//
//  MutableObjectState.swift
//  RxLeanCloudSwift
//
//  Created by WuJun on 23/05/2017.
//  Copyright © 2017 LeanCloud. All rights reserved.
//

import Foundation

public class MutableObjectState: IObjectState {

    public var objectId: String? = nil
    public var isNew: Bool = true
    public var className: String = "DefaultAVObject"
    public var updatedAt: Date? = nil
    public var createdAt: Date? = nil
    public var app: RxAVApp? = nil
    public var serverData: [String: Any] = [String: Any]()

//    init(objectId: String?, isNew: Bool?, className: String?, updatedAt: Date?, createdAt: Date?, app: RxAVApp?, serverData: [String: Any]?) {
//        self.app = app!;
//        self.objectId = objectId
//        self.className = className!
//        self.updatedAt = updatedAt!
//        self.createdAt = createdAt!
//        self.serverData = serverData!
//        self.isNew = isNew!;
//    }

    public func apply(state: IObjectState) -> Void {
        self.app = state.app
        self.objectId = state.objectId
        self.isNew = state.isNew
        self.className = state.className
        self.updatedAt = state.updatedAt
        self.createdAt = state.createdAt
        self.serverData = state.serverData
    }

    public func containsKey(key: String) -> Bool {
        return serverData[key] != nil
    }

    public func mutatedClone(_ hook: (IObjectState) -> Void) -> IObjectState {
        let clone = self.mutableClone()
        hook(clone)
        return clone
    }

    public func mutableClone() -> IObjectState {
        let state = MutableObjectState()
        state.objectId = self.objectId
        state.isNew = self.isNew
        state.className = self.className
        state.updatedAt = self.updatedAt
        state.createdAt = self.createdAt
        state.app = self.app
        state.serverData = self.serverData

        return state
    }

    public func removeReadOnlyFields() -> Void {
        if self.containsKey(key: "objectId") {
            serverData.removeValue(forKey: "objectId")
        } else if self.containsKey(key: "createdAt") {
            serverData.removeValue(forKey: "createdAt")
        } else if self.containsKey(key: "updatedAt") {
            serverData.removeValue(forKey: "updatedAt")
        }
    }

    public func removeRelationFields() -> Void {
        for (key, value) in serverData {
            if value is [String: Any] {
                var vMap = value as! [String: Any]
                if vMap["__type"] != nil {
                    if (vMap["__type"] as! String) == "Relation" {
                        serverData.removeValue(forKey: key)
                    }
                }
            }
        }
    }
}
