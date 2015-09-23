// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file verify_verification_code.proto

import Foundation

public extension Services.User.Actions{ public struct VerifyVerificationCode { }}

public func == (lhs: Services.User.Actions.VerifyVerificationCode.RequestV1, rhs: Services.User.Actions.VerifyVerificationCode.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasUserId == rhs.hasUserId) && (!lhs.hasUserId || lhs.userId == rhs.userId)
  fieldCheck = fieldCheck && (lhs.hasCode == rhs.hasCode) && (!lhs.hasCode || lhs.code == rhs.code)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.User.Actions.VerifyVerificationCode.ResponseV1, rhs: Services.User.Actions.VerifyVerificationCode.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasVerified == rhs.hasVerified) && (!lhs.hasVerified || lhs.verified == rhs.verified)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.User.Actions.VerifyVerificationCode {
  public struct VerifyVerificationCodeRoot {
    public static var sharedInstance : VerifyVerificationCodeRoot {
     struct Static {
         static let instance : VerifyVerificationCodeRoot = VerifyVerificationCodeRoot()
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

    public private(set) var hasUserId:Bool = false
    public private(set) var userId:String = ""

    public private(set) var hasCode:Bool = false
    public private(set) var code:String = ""

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
      if hasUserId {
        try output.writeString(2, value:userId)
      }
      if hasCode {
        try output.writeString(3, value:code)
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
      if hasUserId {
        serialize_size += userId.computeStringSize(2)
      }
      if hasCode {
        serialize_size += code.computeStringSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.User.Actions.VerifyVerificationCode.RequestV1> {
      var mergedArray = Array<Services.User.Actions.VerifyVerificationCode.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1? {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.User.Actions.VerifyVerificationCode.VerifyVerificationCodeRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
      return Services.User.Actions.VerifyVerificationCode.RequestV1.classBuilder() as! Services.User.Actions.VerifyVerificationCode.RequestV1.Builder
    }
    public func getBuilder() -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
      return classBuilder() as! Services.User.Actions.VerifyVerificationCode.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.VerifyVerificationCode.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.VerifyVerificationCode.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.VerifyVerificationCode.RequestV1) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
      return try Services.User.Actions.VerifyVerificationCode.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasUserId {
        output += "\(indent) userId: \(userId) \n"
      }
      if hasCode {
        output += "\(indent) code: \(code) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasUserId {
               hashCode = (hashCode &* 31) &+ userId.hashValue
            }
            if hasCode {
               hashCode = (hashCode &* 31) &+ code.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.VerifyVerificationCode.RequestV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.VerifyVerificationCode.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.VerifyVerificationCode.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.User.Actions.VerifyVerificationCode.RequestV1 = Services.User.Actions.VerifyVerificationCode.RequestV1()
      public func getMessage() -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
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
      public func setVersion(value:UInt32) -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasUserId:Bool {
           get {
                return builderResult.hasUserId
           }
      }
      public var userId:String {
           get {
                return builderResult.userId
           }
           set (value) {
               builderResult.hasUserId = true
               builderResult.userId = value
           }
      }
      public func setUserId(value:String) -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
        self.userId = value
        return self
      }
      public func clearUserId() -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder{
           builderResult.hasUserId = false
           builderResult.userId = ""
           return self
      }
      public var hasCode:Bool {
           get {
                return builderResult.hasCode
           }
      }
      public var code:String {
           get {
                return builderResult.code
           }
           set (value) {
               builderResult.hasCode = true
               builderResult.code = value
           }
      }
      public func setCode(value:String) -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
        self.code = value
        return self
      }
      public func clearCode() -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder{
           builderResult.hasCode = false
           builderResult.code = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
        builderResult = Services.User.Actions.VerifyVerificationCode.RequestV1()
        return self
      }
      public override func clone() throws -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
        return try Services.User.Actions.VerifyVerificationCode.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.User.Actions.VerifyVerificationCode.RequestV1 {
        let returnMe:Services.User.Actions.VerifyVerificationCode.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.User.Actions.VerifyVerificationCode.RequestV1) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
        if other == Services.User.Actions.VerifyVerificationCode.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasUserId {
             userId = other.userId
        }
        if other.hasCode {
             code = other.code
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.RequestV1.Builder {
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
            userId = try input.readString()

          case 26 :
            code = try input.readString()

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

    public private(set) var hasVerified:Bool = false
    public private(set) var verified:Bool = false

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
      if hasVerified {
        try output.writeBool(2, value:verified)
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
      if hasVerified {
        serialize_size += verified.computeBoolSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.User.Actions.VerifyVerificationCode.ResponseV1> {
      var mergedArray = Array<Services.User.Actions.VerifyVerificationCode.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1? {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.User.Actions.VerifyVerificationCode.VerifyVerificationCodeRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
      return Services.User.Actions.VerifyVerificationCode.ResponseV1.classBuilder() as! Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder
    }
    public func getBuilder() -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
      return classBuilder() as! Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.VerifyVerificationCode.ResponseV1) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
      return try Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasVerified {
        output += "\(indent) verified: \(verified) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasVerified {
               hashCode = (hashCode &* 31) &+ verified.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.VerifyVerificationCode.ResponseV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.VerifyVerificationCode.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.VerifyVerificationCode.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.User.Actions.VerifyVerificationCode.ResponseV1 = Services.User.Actions.VerifyVerificationCode.ResponseV1()
      public func getMessage() -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
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
      public func setVersion(value:UInt32) -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasVerified:Bool {
           get {
                return builderResult.hasVerified
           }
      }
      public var verified:Bool {
           get {
                return builderResult.verified
           }
           set (value) {
               builderResult.hasVerified = true
               builderResult.verified = value
           }
      }
      public func setVerified(value:Bool) -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
        self.verified = value
        return self
      }
      public func clearVerified() -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder{
           builderResult.hasVerified = false
           builderResult.verified = false
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
        builderResult = Services.User.Actions.VerifyVerificationCode.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
        return try Services.User.Actions.VerifyVerificationCode.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.User.Actions.VerifyVerificationCode.ResponseV1 {
        let returnMe:Services.User.Actions.VerifyVerificationCode.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.User.Actions.VerifyVerificationCode.ResponseV1) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
        if other == Services.User.Actions.VerifyVerificationCode.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasVerified {
             verified = other.verified
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.User.Actions.VerifyVerificationCode.ResponseV1.Builder {
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
            verified = try input.readBool()

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
