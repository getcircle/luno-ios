// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Search{ public struct Containers { public struct Search { }}}

public extension Services.Search.Containers.Search {
  public struct SearchRoot {
    public static var sharedInstance : SearchRoot {
     struct Static {
         static let instance : SearchRoot = SearchRoot()
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

  public enum CategoryV1:Int32 {
    case Profiles = 0
    case Teams = 1
    case Locations = 2
    case Skills = 3
    case Interests = 4
    case Groups = 5

  }

  //Enum type declaration end 



  //Enum type declaration start 

  public enum AttributeV1:Int32 {
    case LocationId = 0
    case TeamId = 1
    case SkillId = 2
    case OrganizationId = 3

  }

  //Enum type declaration end 

}

// @@protoc_insertion_point(global_scope)
