// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file profile_exists.proto

import Foundation

public extension Services.Profile.Actions{ public struct ProfileExists { }}

public func == (lhs: Services.Profile.Actions.ProfileExists.RequestV1, rhs: Services.Profile.Actions.ProfileExists.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasDomain == rhs.hasDomain) && (!lhs.hasDomain || lhs.domain == rhs.domain)
  fieldCheck = fieldCheck && (lhs.hasEmail == rhs.hasEmail) && (!lhs.hasEmail || lhs.email == rhs.email)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Profile.Actions.ProfileExists.ResponseV1, rhs: Services.Profile.Actions.ProfileExists.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasExists == rhs.hasExists) && (!lhs.hasExists || lhs.exists == rhs.exists)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Profile.Actions.ProfileExists {
  public struct ProfileExistsRoot {
    public static var sharedInstance : ProfileExistsRoot {
     struct Static {
         static let instance : ProfileExistsRoot = ProfileExistsRoot()
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

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasDomain:Bool = false
    public private(set) var domain:String = ""

    public private(set) var hasEmail:Bool = false
    public private(set) var email:String = ""

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
      if hasDomain {
        try output.writeString(2, value:domain)
      }
      if hasEmail {
        try output.writeString(3, value:email)
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
      if hasDomain {
        serialize_size += domain.computeStringSize(2)
      }
      if hasEmail {
        serialize_size += email.computeStringSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.ProfileExists.RequestV1> {
      var mergedArray = Array<Services.Profile.Actions.ProfileExists.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.ProfileExists.RequestV1? {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.ProfileExists.ProfileExistsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
      return Services.Profile.Actions.ProfileExists.RequestV1.classBuilder() as! Services.Profile.Actions.ProfileExists.RequestV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
      return classBuilder() as! Services.Profile.Actions.ProfileExists.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.ProfileExists.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.ProfileExists.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
      return try Services.Profile.Actions.ProfileExists.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.ProfileExists.RequestV1) throws -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
      return try Services.Profile.Actions.ProfileExists.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasDomain {
        output += "\(indent) domain: \(domain) \n"
      }
      if hasEmail {
        output += "\(indent) email: \(email) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasDomain {
               hashCode = (hashCode &* 31) &+ domain.hashValue
            }
            if hasEmail {
               hashCode = (hashCode &* 31) &+ email.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.ProfileExists.RequestV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.ProfileExists.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.ProfileExists.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.ProfileExists.RequestV1 = Services.Profile.Actions.ProfileExists.RequestV1()
      public func getMessage() -> Services.Profile.Actions.ProfileExists.RequestV1 {
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
      public func setVersion(value:UInt32) -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Profile.Actions.ProfileExists.RequestV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasDomain:Bool {
           get {
                return builderResult.hasDomain
           }
      }
      public var domain:String {
           get {
                return builderResult.domain
           }
           set (value) {
               builderResult.hasDomain = true
               builderResult.domain = value
           }
      }
      public func setDomain(value:String) -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
        self.domain = value
        return self
      }
      public func clearDomain() -> Services.Profile.Actions.ProfileExists.RequestV1.Builder{
           builderResult.hasDomain = false
           builderResult.domain = ""
           return self
      }
      public var hasEmail:Bool {
           get {
                return builderResult.hasEmail
           }
      }
      public var email:String {
           get {
                return builderResult.email
           }
           set (value) {
               builderResult.hasEmail = true
               builderResult.email = value
           }
      }
      public func setEmail(value:String) -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
        self.email = value
        return self
      }
      public func clearEmail() -> Services.Profile.Actions.ProfileExists.RequestV1.Builder{
           builderResult.hasEmail = false
           builderResult.email = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
        builderResult = Services.Profile.Actions.ProfileExists.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
        return try Services.Profile.Actions.ProfileExists.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.ProfileExists.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.ProfileExists.RequestV1 {
        let returnMe:Services.Profile.Actions.ProfileExists.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.ProfileExists.RequestV1) throws -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
        if other == Services.Profile.Actions.ProfileExists.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasDomain {
             domain = other.domain
        }
        if other.hasEmail {
             email = other.email
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.RequestV1.Builder {
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
            domain = try input.readString()

          case 26 :
            email = try input.readString()

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

    public private(set) var hasExists:Bool = false
    public private(set) var exists:Bool = false

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
      if hasExists {
        try output.writeBool(2, value:exists)
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
      if hasExists {
        serialize_size += exists.computeBoolSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Profile.Actions.ProfileExists.ResponseV1> {
      var mergedArray = Array<Services.Profile.Actions.ProfileExists.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.ProfileExists.ResponseV1? {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Profile.Actions.ProfileExists.ProfileExistsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
      return Services.Profile.Actions.ProfileExists.ResponseV1.classBuilder() as! Services.Profile.Actions.ProfileExists.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
      return classBuilder() as! Services.Profile.Actions.ProfileExists.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.ProfileExists.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Profile.Actions.ProfileExists.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Profile.Actions.ProfileExists.ResponseV1) throws -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
      return try Services.Profile.Actions.ProfileExists.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasExists {
        output += "\(indent) exists: \(exists) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasExists {
               hashCode = (hashCode &* 31) &+ exists.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Profile.Actions.ProfileExists.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Profile.Actions.ProfileExists.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Profile.Actions.ProfileExists.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Profile.Actions.ProfileExists.ResponseV1 = Services.Profile.Actions.ProfileExists.ResponseV1()
      public func getMessage() -> Services.Profile.Actions.ProfileExists.ResponseV1 {
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
      public func setVersion(value:UInt32) -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasExists:Bool {
           get {
                return builderResult.hasExists
           }
      }
      public var exists:Bool {
           get {
                return builderResult.exists
           }
           set (value) {
               builderResult.hasExists = true
               builderResult.exists = value
           }
      }
      public func setExists(value:Bool) -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
        self.exists = value
        return self
      }
      public func clearExists() -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder{
           builderResult.hasExists = false
           builderResult.exists = false
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
        builderResult = Services.Profile.Actions.ProfileExists.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
        return try Services.Profile.Actions.ProfileExists.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Profile.Actions.ProfileExists.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Profile.Actions.ProfileExists.ResponseV1 {
        let returnMe:Services.Profile.Actions.ProfileExists.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Profile.Actions.ProfileExists.ResponseV1) throws -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
        if other == Services.Profile.Actions.ProfileExists.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasExists {
             exists = other.exists
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Profile.Actions.ProfileExists.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 8 :
            version = try input.readUInt32()

          case 16 :
            exists = try input.readBool()

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