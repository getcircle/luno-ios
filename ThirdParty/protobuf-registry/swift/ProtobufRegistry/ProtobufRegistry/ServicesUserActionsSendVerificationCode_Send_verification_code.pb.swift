// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.User.Actions{ public struct SendVerificationCode { }}

public func == (lhs: Services.User.Actions.SendVerificationCode.RequestV1, rhs: Services.User.Actions.SendVerificationCode.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasUserId == rhs.hasUserId) && (!lhs.hasUserId || lhs.userId == rhs.userId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.User.Actions.SendVerificationCode.ResponseV1, rhs: Services.User.Actions.SendVerificationCode.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasMessageId == rhs.hasMessageId) && (!lhs.hasMessageId || lhs.messageId == rhs.messageId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.User.Actions.SendVerificationCode {
  public struct SendVerificationCodeRoot {
    public static var sharedInstance : SendVerificationCodeRoot {
     struct Static {
         static let instance : SendVerificationCodeRoot = SendVerificationCodeRoot()
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
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "userId": return userId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasUserId:Bool = false
    public private(set) var userId:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) {
      if hasVersion {
        output.writeUInt32(1, value:version)
      }
      if hasUserId {
        output.writeString(2, value:userId)
      }
      unknownFields.writeToCodedOutputStream(output)
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
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.SendVerificationCode.RequestV1 {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.SendVerificationCode.SendVerificationCodeRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.SendVerificationCode.RequestV1 {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.SendVerificationCode.RequestV1 {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.SendVerificationCode.RequestV1 {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.SendVerificationCode.RequestV1 {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.SendVerificationCode.RequestV1 {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      return Services.User.Actions.SendVerificationCode.RequestV1.classBuilder() as! Services.User.Actions.SendVerificationCode.RequestV1Builder
    }
    public func builder() -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      return classBuilder() as! Services.User.Actions.SendVerificationCode.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.SendVerificationCode.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      return Services.User.Actions.SendVerificationCode.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.SendVerificationCode.RequestV1) -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      return Services.User.Actions.SendVerificationCode.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasUserId {
        output += "\(indent) userId: \(userId) \n"
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
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.SendVerificationCode.RequestV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.SendVerificationCode.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.SendVerificationCode.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.SendVerificationCode.RequestV1

    required override public init () {
       builderResult = Services.User.Actions.SendVerificationCode.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.SendVerificationCode.RequestV1Builder{
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
    public func setUserId(value:String)-> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      self.userId = value
      return self
    }
    public func clearUserId() -> Services.User.Actions.SendVerificationCode.RequestV1Builder{
         builderResult.hasUserId = false
         builderResult.userId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      builderResult = Services.User.Actions.SendVerificationCode.RequestV1()
      return self
    }
    public override func clone() -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      return Services.User.Actions.SendVerificationCode.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.SendVerificationCode.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.SendVerificationCode.RequestV1 {
      var returnMe:Services.User.Actions.SendVerificationCode.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.SendVerificationCode.RequestV1) -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      if (other == Services.User.Actions.SendVerificationCode.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasUserId {
           userId = other.userId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.SendVerificationCode.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.SendVerificationCode.RequestV1Builder {
      var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        var tag = input.readTag()
        switch tag {
        case 0: 
          self.unknownFields = unknownFieldsBuilder.build()
          return self

        case 8 :
          version = input.readUInt32()

        case 18 :
          userId = input.readString()

        default:
          if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
             unknownFields = unknownFieldsBuilder.build()
             return self
          }
        }
      }
    }
  }

  final public class ResponseV1 : GeneratedMessage, GeneratedMessageProtocol {
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "messageId": return messageId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasMessageId:Bool = false
    public private(set) var messageId:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) {
      if hasVersion {
        output.writeUInt32(1, value:version)
      }
      if hasMessageId {
        output.writeString(2, value:messageId)
      }
      unknownFields.writeToCodedOutputStream(output)
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
      if hasMessageId {
        serialize_size += messageId.computeStringSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.SendVerificationCode.ResponseV1 {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.SendVerificationCode.SendVerificationCodeRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.SendVerificationCode.ResponseV1 {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.SendVerificationCode.ResponseV1 {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.SendVerificationCode.ResponseV1 {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.SendVerificationCode.ResponseV1 {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.SendVerificationCode.ResponseV1 {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      return Services.User.Actions.SendVerificationCode.ResponseV1.classBuilder() as! Services.User.Actions.SendVerificationCode.ResponseV1Builder
    }
    public func builder() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      return classBuilder() as! Services.User.Actions.SendVerificationCode.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.SendVerificationCode.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.SendVerificationCode.ResponseV1) -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasMessageId {
        output += "\(indent) messageId: \(messageId) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasMessageId {
               hashCode = (hashCode &* 31) &+ messageId.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.SendVerificationCode.ResponseV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.SendVerificationCode.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.SendVerificationCode.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.SendVerificationCode.ResponseV1

    required override public init () {
       builderResult = Services.User.Actions.SendVerificationCode.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasMessageId:Bool {
         get {
              return builderResult.hasMessageId
         }
    }
    public var messageId:String {
         get {
              return builderResult.messageId
         }
         set (value) {
             builderResult.hasMessageId = true
             builderResult.messageId = value
         }
    }
    public func setMessageId(value:String)-> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      self.messageId = value
      return self
    }
    public func clearMessageId() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder{
         builderResult.hasMessageId = false
         builderResult.messageId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      builderResult = Services.User.Actions.SendVerificationCode.ResponseV1()
      return self
    }
    public override func clone() -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      return Services.User.Actions.SendVerificationCode.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.SendVerificationCode.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.SendVerificationCode.ResponseV1 {
      var returnMe:Services.User.Actions.SendVerificationCode.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.SendVerificationCode.ResponseV1) -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      if (other == Services.User.Actions.SendVerificationCode.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasMessageId {
           messageId = other.messageId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.SendVerificationCode.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.SendVerificationCode.ResponseV1Builder {
      var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        var tag = input.readTag()
        switch tag {
        case 0: 
          self.unknownFields = unknownFieldsBuilder.build()
          return self

        case 8 :
          version = input.readUInt32()

        case 18 :
          messageId = input.readString()

        default:
          if (!parseUnknownField(input,unknownFields:unknownFieldsBuilder, extensionRegistry:extensionRegistry, tag:tag)) {
             unknownFields = unknownFieldsBuilder.build()
             return self
          }
        }
      }
    }
  }

}

// @@protoc_insertion_point(global_scope)
