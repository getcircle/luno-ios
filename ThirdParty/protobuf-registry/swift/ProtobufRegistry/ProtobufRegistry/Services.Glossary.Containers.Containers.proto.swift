// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file containers.proto

import Foundation
import ProtocolBuffers


public extension Services.Glossary{ public struct Containers { }}

public func == (lhs: Services.Glossary.Containers.TermV1, rhs: Services.Glossary.Containers.TermV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasId == rhs.hasId) && (!lhs.hasId || lhs.id == rhs.id)
  fieldCheck = fieldCheck && (lhs.hasName == rhs.hasName) && (!lhs.hasName || lhs.name == rhs.name)
  fieldCheck = fieldCheck && (lhs.hasDefinition == rhs.hasDefinition) && (!lhs.hasDefinition || lhs.definition == rhs.definition)
  fieldCheck = fieldCheck && (lhs.hasOrganizationId == rhs.hasOrganizationId) && (!lhs.hasOrganizationId || lhs.organizationId == rhs.organizationId)
  fieldCheck = fieldCheck && (lhs.hasCreatedByProfileId == rhs.hasCreatedByProfileId) && (!lhs.hasCreatedByProfileId || lhs.createdByProfileId == rhs.createdByProfileId)
  fieldCheck = fieldCheck && (lhs.hasCreated == rhs.hasCreated) && (!lhs.hasCreated || lhs.created == rhs.created)
  fieldCheck = fieldCheck && (lhs.hasChanged == rhs.hasChanged) && (!lhs.hasChanged || lhs.changed == rhs.changed)
  fieldCheck = fieldCheck && (lhs.hasPermissions == rhs.hasPermissions) && (!lhs.hasPermissions || lhs.permissions == rhs.permissions)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Glossary.Containers {
  public struct ContainersRoot {
    public static var sharedInstance : ContainersRoot {
     struct Static {
         static let instance : ContainersRoot = ContainersRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Common.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class TermV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasId:Bool = false
    public private(set) var id:String = ""

    public private(set) var hasName:Bool = false
    public private(set) var name:String = ""

    public private(set) var hasDefinition:Bool = false
    public private(set) var definition:String = ""

    public private(set) var hasOrganizationId:Bool = false
    public private(set) var organizationId:String = ""

    public private(set) var hasCreatedByProfileId:Bool = false
    public private(set) var createdByProfileId:String = ""

    public private(set) var hasCreated:Bool = false
    public private(set) var created:String = ""

    public private(set) var hasChanged:Bool = false
    public private(set) var changed:String = ""

    public private(set) var hasPermissions:Bool = false
    public private(set) var permissions:Services.Common.Containers.PermissionsV1!
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasVersion {
        try output.writeUInt32(1, value:version)
      }
      if hasId {
        try output.writeString(2, value:id)
      }
      if hasName {
        try output.writeString(3, value:name)
      }
      if hasDefinition {
        try output.writeString(4, value:definition)
      }
      if hasOrganizationId {
        try output.writeString(5, value:organizationId)
      }
      if hasCreatedByProfileId {
        try output.writeString(6, value:createdByProfileId)
      }
      if hasCreated {
        try output.writeString(7, value:created)
      }
      if hasChanged {
        try output.writeString(8, value:changed)
      }
      if hasPermissions {
        try output.writeMessage(9, value:permissions)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasVersion {
        serialize_size += version.computeUInt32Size(1)
      }
      if hasId {
        serialize_size += id.computeStringSize(2)
      }
      if hasName {
        serialize_size += name.computeStringSize(3)
      }
      if hasDefinition {
        serialize_size += definition.computeStringSize(4)
      }
      if hasOrganizationId {
        serialize_size += organizationId.computeStringSize(5)
      }
      if hasCreatedByProfileId {
        serialize_size += createdByProfileId.computeStringSize(6)
      }
      if hasCreated {
        serialize_size += created.computeStringSize(7)
      }
      if hasChanged {
        serialize_size += changed.computeStringSize(8)
      }
      if hasPermissions {
          if let varSizepermissions = permissions?.computeMessageSize(9) {
              serialize_size += varSizepermissions
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Glossary.Containers.TermV1> {
      var mergedArray = Array<Services.Glossary.Containers.TermV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Glossary.Containers.TermV1? {
      return try Services.Glossary.Containers.TermV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Glossary.Containers.TermV1 {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFromData(data, extensionRegistry:Services.Glossary.Containers.ContainersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Glossary.Containers.TermV1 {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Glossary.Containers.TermV1 {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Glossary.Containers.TermV1 {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Glossary.Containers.TermV1 {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Glossary.Containers.TermV1 {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Glossary.Containers.TermV1.Builder {
      return Services.Glossary.Containers.TermV1.classBuilder() as! Services.Glossary.Containers.TermV1.Builder
    }
    public func getBuilder() -> Services.Glossary.Containers.TermV1.Builder {
      return classBuilder() as! Services.Glossary.Containers.TermV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Glossary.Containers.TermV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Glossary.Containers.TermV1.Builder()
    }
    public func toBuilder() throws -> Services.Glossary.Containers.TermV1.Builder {
      return try Services.Glossary.Containers.TermV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Glossary.Containers.TermV1) throws -> Services.Glossary.Containers.TermV1.Builder {
      return try Services.Glossary.Containers.TermV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasId {
        output += "\(indent) id: \(id) \n"
      }
      if hasName {
        output += "\(indent) name: \(name) \n"
      }
      if hasDefinition {
        output += "\(indent) definition: \(definition) \n"
      }
      if hasOrganizationId {
        output += "\(indent) organizationId: \(organizationId) \n"
      }
      if hasCreatedByProfileId {
        output += "\(indent) createdByProfileId: \(createdByProfileId) \n"
      }
      if hasCreated {
        output += "\(indent) created: \(created) \n"
      }
      if hasChanged {
        output += "\(indent) changed: \(changed) \n"
      }
      if hasPermissions {
        output += "\(indent) permissions {\n"
        try permissions?.writeDescriptionTo(&output, indent:"\(indent)  ")
        output += "\(indent) }\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasId {
               hashCode = (hashCode &* 31) &+ id.hashValue
            }
            if hasName {
               hashCode = (hashCode &* 31) &+ name.hashValue
            }
            if hasDefinition {
               hashCode = (hashCode &* 31) &+ definition.hashValue
            }
            if hasOrganizationId {
               hashCode = (hashCode &* 31) &+ organizationId.hashValue
            }
            if hasCreatedByProfileId {
               hashCode = (hashCode &* 31) &+ createdByProfileId.hashValue
            }
            if hasCreated {
               hashCode = (hashCode &* 31) &+ created.hashValue
            }
            if hasChanged {
               hashCode = (hashCode &* 31) &+ changed.hashValue
            }
            if hasPermissions {
                if let hashValuepermissions = permissions?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValuepermissions
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Glossary.Containers.TermV1"
    }
    override public func className() -> String {
        return "Services.Glossary.Containers.TermV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Glossary.Containers.TermV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Glossary.Containers.TermV1 = Services.Glossary.Containers.TermV1()
      public func getMessage() -> Services.Glossary.Containers.TermV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasVersion:Bool {
           get {
                return builderResult.hasVersion
           }
      }
      public var version:UInt32 {
           get {
                return builderResult.version
           }
           set (value) {
               builderResult.hasVersion = true
               builderResult.version = value
           }
      }
      public func setVersion(value:UInt32) -> Services.Glossary.Containers.TermV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasId:Bool {
           get {
                return builderResult.hasId
           }
      }
      public var id:String {
           get {
                return builderResult.id
           }
           set (value) {
               builderResult.hasId = true
               builderResult.id = value
           }
      }
      public func setId(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.id = value
        return self
      }
      public func clearId() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasId = false
           builderResult.id = ""
           return self
      }
      public var hasName:Bool {
           get {
                return builderResult.hasName
           }
      }
      public var name:String {
           get {
                return builderResult.name
           }
           set (value) {
               builderResult.hasName = true
               builderResult.name = value
           }
      }
      public func setName(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.name = value
        return self
      }
      public func clearName() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasName = false
           builderResult.name = ""
           return self
      }
      public var hasDefinition:Bool {
           get {
                return builderResult.hasDefinition
           }
      }
      public var definition:String {
           get {
                return builderResult.definition
           }
           set (value) {
               builderResult.hasDefinition = true
               builderResult.definition = value
           }
      }
      public func setDefinition(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.definition = value
        return self
      }
      public func clearDefinition() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasDefinition = false
           builderResult.definition = ""
           return self
      }
      public var hasOrganizationId:Bool {
           get {
                return builderResult.hasOrganizationId
           }
      }
      public var organizationId:String {
           get {
                return builderResult.organizationId
           }
           set (value) {
               builderResult.hasOrganizationId = true
               builderResult.organizationId = value
           }
      }
      public func setOrganizationId(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.organizationId = value
        return self
      }
      public func clearOrganizationId() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasOrganizationId = false
           builderResult.organizationId = ""
           return self
      }
      public var hasCreatedByProfileId:Bool {
           get {
                return builderResult.hasCreatedByProfileId
           }
      }
      public var createdByProfileId:String {
           get {
                return builderResult.createdByProfileId
           }
           set (value) {
               builderResult.hasCreatedByProfileId = true
               builderResult.createdByProfileId = value
           }
      }
      public func setCreatedByProfileId(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.createdByProfileId = value
        return self
      }
      public func clearCreatedByProfileId() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasCreatedByProfileId = false
           builderResult.createdByProfileId = ""
           return self
      }
      public var hasCreated:Bool {
           get {
                return builderResult.hasCreated
           }
      }
      public var created:String {
           get {
                return builderResult.created
           }
           set (value) {
               builderResult.hasCreated = true
               builderResult.created = value
           }
      }
      public func setCreated(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.created = value
        return self
      }
      public func clearCreated() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasCreated = false
           builderResult.created = ""
           return self
      }
      public var hasChanged:Bool {
           get {
                return builderResult.hasChanged
           }
      }
      public var changed:String {
           get {
                return builderResult.changed
           }
           set (value) {
               builderResult.hasChanged = true
               builderResult.changed = value
           }
      }
      public func setChanged(value:String) -> Services.Glossary.Containers.TermV1.Builder {
        self.changed = value
        return self
      }
      public func clearChanged() -> Services.Glossary.Containers.TermV1.Builder{
           builderResult.hasChanged = false
           builderResult.changed = ""
           return self
      }
      public var hasPermissions:Bool {
           get {
               return builderResult.hasPermissions
           }
      }
      public var permissions:Services.Common.Containers.PermissionsV1! {
           get {
               if permissionsBuilder_ != nil {
                  builderResult.permissions = permissionsBuilder_.getMessage()
               }
               return builderResult.permissions
           }
           set (value) {
               builderResult.hasPermissions = true
               builderResult.permissions = value
           }
      }
      private var permissionsBuilder_:Services.Common.Containers.PermissionsV1.Builder! {
           didSet {
              builderResult.hasPermissions = true
           }
      }
      public func getPermissionsBuilder() -> Services.Common.Containers.PermissionsV1.Builder {
        if permissionsBuilder_ == nil {
           permissionsBuilder_ = Services.Common.Containers.PermissionsV1.Builder()
           builderResult.permissions = permissionsBuilder_.getMessage()
           if permissions != nil {
              try! permissionsBuilder_.mergeFrom(permissions)
           }
        }
        return permissionsBuilder_
      }
      public func setPermissions(value:Services.Common.Containers.PermissionsV1!) -> Services.Glossary.Containers.TermV1.Builder {
        self.permissions = value
        return self
      }
      public func mergePermissions(value:Services.Common.Containers.PermissionsV1) throws -> Services.Glossary.Containers.TermV1.Builder {
        if builderResult.hasPermissions {
          builderResult.permissions = try Services.Common.Containers.PermissionsV1.builderWithPrototype(builderResult.permissions).mergeFrom(value).buildPartial()
        } else {
          builderResult.permissions = value
        }
        builderResult.hasPermissions = true
        return self
      }
      public func clearPermissions() -> Services.Glossary.Containers.TermV1.Builder {
        permissionsBuilder_ = nil
        builderResult.hasPermissions = false
        builderResult.permissions = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Glossary.Containers.TermV1.Builder {
        builderResult = Services.Glossary.Containers.TermV1()
        return self
      }
      public override func clone() throws -> Services.Glossary.Containers.TermV1.Builder {
        return try Services.Glossary.Containers.TermV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Glossary.Containers.TermV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Glossary.Containers.TermV1 {
        let returnMe:Services.Glossary.Containers.TermV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Glossary.Containers.TermV1) throws -> Services.Glossary.Containers.TermV1.Builder {
        if other == Services.Glossary.Containers.TermV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasId {
             id = other.id
        }
        if other.hasName {
             name = other.name
        }
        if other.hasDefinition {
             definition = other.definition
        }
        if other.hasOrganizationId {
             organizationId = other.organizationId
        }
        if other.hasCreatedByProfileId {
             createdByProfileId = other.createdByProfileId
        }
        if other.hasCreated {
             created = other.created
        }
        if other.hasChanged {
             changed = other.changed
        }
        if (other.hasPermissions) {
            try mergePermissions(other.permissions)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Glossary.Containers.TermV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Glossary.Containers.TermV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 8 :
            version = try input.readUInt32()

          case 18 :
            id = try input.readString()

          case 26 :
            name = try input.readString()

          case 34 :
            definition = try input.readString()

          case 42 :
            organizationId = try input.readString()

          case 50 :
            createdByProfileId = try input.readString()

          case 58 :
            created = try input.readString()

          case 66 :
            changed = try input.readString()

          case 74 :
            let subBuilder:Services.Common.Containers.PermissionsV1.Builder = Services.Common.Containers.PermissionsV1.Builder()
            if hasPermissions {
              try subBuilder.mergeFrom(permissions)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            permissions = subBuilder.buildPartial()

          default:
            if (!(try parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag))) {
               unknownFields = try unknownFieldsBuilder.build()
               return self
            }
          }
        }
      }
    }

  }

}

// @@protoc_insertion_point(global_scope)