// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file update_profile.proto

import Foundation
import ProtocolBuffers


public extension Services.Profile.Actions{ public struct UpdateProfile { }}

public func == (lhs: Services.Profile.Actions.UpdateProfile.RequestV1, rhs: Services.Profile.Actions.UpdateProfile.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasProfile == rhs.hasProfile) && (!lhs.hasProfile || lhs.profile == rhs.profile)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Profile.Actions.UpdateProfile.ResponseV1, rhs: Services.Profile.Actions.UpdateProfile.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasProfile == rhs.hasProfile) && (!lhs.hasProfile || lhs.profile == rhs.profile)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Profile.Actions.UpdateProfile {
  public struct UpdateProfileRoot {
    public static var sharedInstance : UpdateProfileRoot {
     struct Static {
         static let instance : UpdateProfileRoot = UpdateProfileRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Profile.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasProfile:Bool = false
    public private(set) var profile:Services.Profile.Containers.ProfileV1!
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
      if hasProfile {
        try output.writeMessage(2, value:profile)
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
      if hasProfile {
          if let varSizeprofile = profile?.computeMessageSize(2) {
              serialize_size += varSizeprofile
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.UpdateProfile.RequestV1> {
      var mergedArray = Array<Services.Profile.Actions.UpdateProfile.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.UpdateProfile.RequestV1? {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.UpdateProfile.UpdateProfileRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
      return Services.Profile.Actions.UpdateProfile.RequestV1.classBuilder() as! Services.Profile.Actions.UpdateProfile.RequestV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
      return classBuilder() as! Services.Profile.Actions.UpdateProfile.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.UpdateProfile.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.UpdateProfile.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.UpdateProfile.RequestV1) throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
      return try Services.Profile.Actions.UpdateProfile.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasProfile {
        output += "\(indent) profile {\n"
        try profile?.writeDescriptionTo(&output, indent:"\(indent)  ")
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
            if hasProfile {
                if let hashValueprofile = profile?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueprofile
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.UpdateProfile.RequestV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.UpdateProfile.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.UpdateProfile.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.UpdateProfile.RequestV1 = Services.Profile.Actions.UpdateProfile.RequestV1()
      public func getMessage() -> Services.Profile.Actions.UpdateProfile.RequestV1 {
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
      public func setVersion(value:UInt32) -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasProfile:Bool {
           get {
               return builderResult.hasProfile
           }
      }
      public var profile:Services.Profile.Containers.ProfileV1! {
           get {
               if profileBuilder_ != nil {
                  builderResult.profile = profileBuilder_.getMessage()
               }
               return builderResult.profile
           }
           set (value) {
               builderResult.hasProfile = true
               builderResult.profile = value
           }
      }
      private var profileBuilder_:Services.Profile.Containers.ProfileV1.Builder! {
           didSet {
              builderResult.hasProfile = true
           }
      }
      public func getProfileBuilder() -> Services.Profile.Containers.ProfileV1.Builder {
        if profileBuilder_ == nil {
           profileBuilder_ = Services.Profile.Containers.ProfileV1.Builder()
           builderResult.profile = profileBuilder_.getMessage()
           if profile != nil {
              try! profileBuilder_.mergeFrom(profile)
           }
        }
        return profileBuilder_
      }
      public func setProfile(value:Services.Profile.Containers.ProfileV1!) -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        self.profile = value
        return self
      }
      public func mergeProfile(value:Services.Profile.Containers.ProfileV1) throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        if builderResult.hasProfile {
          builderResult.profile = try Services.Profile.Containers.ProfileV1.builderWithPrototype(builderResult.profile).mergeFrom(value).buildPartial()
        } else {
          builderResult.profile = value
        }
        builderResult.hasProfile = true
        return self
      }
      public func clearProfile() -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        profileBuilder_ = nil
        builderResult.hasProfile = false
        builderResult.profile = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        builderResult = Services.Profile.Actions.UpdateProfile.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        return try Services.Profile.Actions.UpdateProfile.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.UpdateProfile.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.UpdateProfile.RequestV1 {
        let returnMe:Services.Profile.Actions.UpdateProfile.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.UpdateProfile.RequestV1) throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
        if other == Services.Profile.Actions.UpdateProfile.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if (other.hasProfile) {
            try mergeProfile(other.profile)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.RequestV1.Builder {
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
            let subBuilder:Services.Profile.Containers.ProfileV1.Builder = Services.Profile.Containers.ProfileV1.Builder()
            if hasProfile {
              try subBuilder.mergeFrom(profile)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            profile = subBuilder.buildPartial()

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

  final public class ResponseV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasProfile:Bool = false
    public private(set) var profile:Services.Profile.Containers.ProfileV1!
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
      if hasProfile {
        try output.writeMessage(2, value:profile)
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
      if hasProfile {
          if let varSizeprofile = profile?.computeMessageSize(2) {
              serialize_size += varSizeprofile
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.UpdateProfile.ResponseV1> {
      var mergedArray = Array<Services.Profile.Actions.UpdateProfile.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1? {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.UpdateProfile.UpdateProfileRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
      return Services.Profile.Actions.UpdateProfile.ResponseV1.classBuilder() as! Services.Profile.Actions.UpdateProfile.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
      return classBuilder() as! Services.Profile.Actions.UpdateProfile.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.UpdateProfile.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.UpdateProfile.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.UpdateProfile.ResponseV1) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
      return try Services.Profile.Actions.UpdateProfile.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasProfile {
        output += "\(indent) profile {\n"
        try profile?.writeDescriptionTo(&output, indent:"\(indent)  ")
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
            if hasProfile {
                if let hashValueprofile = profile?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueprofile
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.UpdateProfile.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.UpdateProfile.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.UpdateProfile.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.UpdateProfile.ResponseV1 = Services.Profile.Actions.UpdateProfile.ResponseV1()
      public func getMessage() -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
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
      public func setVersion(value:UInt32) -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasProfile:Bool {
           get {
               return builderResult.hasProfile
           }
      }
      public var profile:Services.Profile.Containers.ProfileV1! {
           get {
               if profileBuilder_ != nil {
                  builderResult.profile = profileBuilder_.getMessage()
               }
               return builderResult.profile
           }
           set (value) {
               builderResult.hasProfile = true
               builderResult.profile = value
           }
      }
      private var profileBuilder_:Services.Profile.Containers.ProfileV1.Builder! {
           didSet {
              builderResult.hasProfile = true
           }
      }
      public func getProfileBuilder() -> Services.Profile.Containers.ProfileV1.Builder {
        if profileBuilder_ == nil {
           profileBuilder_ = Services.Profile.Containers.ProfileV1.Builder()
           builderResult.profile = profileBuilder_.getMessage()
           if profile != nil {
              try! profileBuilder_.mergeFrom(profile)
           }
        }
        return profileBuilder_
      }
      public func setProfile(value:Services.Profile.Containers.ProfileV1!) -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        self.profile = value
        return self
      }
      public func mergeProfile(value:Services.Profile.Containers.ProfileV1) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        if builderResult.hasProfile {
          builderResult.profile = try Services.Profile.Containers.ProfileV1.builderWithPrototype(builderResult.profile).mergeFrom(value).buildPartial()
        } else {
          builderResult.profile = value
        }
        builderResult.hasProfile = true
        return self
      }
      public func clearProfile() -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        profileBuilder_ = nil
        builderResult.hasProfile = false
        builderResult.profile = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        builderResult = Services.Profile.Actions.UpdateProfile.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        return try Services.Profile.Actions.UpdateProfile.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.UpdateProfile.ResponseV1 {
        let returnMe:Services.Profile.Actions.UpdateProfile.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.UpdateProfile.ResponseV1) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
        if other == Services.Profile.Actions.UpdateProfile.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if (other.hasProfile) {
            try mergeProfile(other.profile)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.UpdateProfile.ResponseV1.Builder {
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
            let subBuilder:Services.Profile.Containers.ProfileV1.Builder = Services.Profile.Containers.ProfileV1.Builder()
            if hasProfile {
              try subBuilder.mergeFrom(profile)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            profile = subBuilder.buildPartial()

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