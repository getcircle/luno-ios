// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Group{ public struct Containers { public struct Permissions { public struct WhoCanInvite { }}}}

public extension Services.Group.Containers.Permissions.WhoCanInvite {
  public struct WhoCanInviteRoot {
    public static var sharedInstance : WhoCanInviteRoot {
     struct Static {
         static let instance : WhoCanInviteRoot = WhoCanInviteRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }



  //Enum type declaration start 

  public enum WhoCanInvitePermissionsV1:Int32 {
    case AllMembers = 0
    case AllManagers = 1

  }

  //Enum type declaration end 

}

// @@protoc_insertion_point(global_scope)