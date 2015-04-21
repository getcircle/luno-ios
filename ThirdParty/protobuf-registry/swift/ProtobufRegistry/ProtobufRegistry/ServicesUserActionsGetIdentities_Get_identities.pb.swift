// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.User.Actions{ public struct GetIdentities { }}

public func == (lhs: Services.User.Actions.GetIdentities.RequestV1, rhs: Services.User.Actions.GetIdentities.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasUserId == rhs.hasUserId) && (!lhs.hasUserId || lhs.userId == rhs.userId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.User.Actions.GetIdentities.ResponseV1, rhs: Services.User.Actions.GetIdentities.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.identities == rhs.identities)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.User.Actions.GetIdentities {
  public struct GetIdentitiesRoot {
    public static var sharedInstance : GetIdentitiesRoot {
     struct Static {
         static let instance : GetIdentitiesRoot = GetIdentitiesRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.User.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
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
    public class func parseFromData(data:NSData) -> Services.User.Actions.GetIdentities.RequestV1 {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.GetIdentities.GetIdentitiesRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.GetIdentities.RequestV1 {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.GetIdentities.RequestV1 {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.GetIdentities.RequestV1 {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.GetIdentities.RequestV1 {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.GetIdentities.RequestV1 {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.GetIdentities.RequestV1Builder {
      return Services.User.Actions.GetIdentities.RequestV1.classBuilder() as! Services.User.Actions.GetIdentities.RequestV1Builder
    }
    public func builder() -> Services.User.Actions.GetIdentities.RequestV1Builder {
      return classBuilder() as! Services.User.Actions.GetIdentities.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetIdentities.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetIdentities.RequestV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.GetIdentities.RequestV1Builder {
      return Services.User.Actions.GetIdentities.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.GetIdentities.RequestV1) -> Services.User.Actions.GetIdentities.RequestV1Builder {
      return Services.User.Actions.GetIdentities.RequestV1.builder().mergeFrom(prototype)
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
        return "Services.User.Actions.GetIdentities.RequestV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.GetIdentities.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.GetIdentities.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.GetIdentities.RequestV1

    required override public init () {
       builderResult = Services.User.Actions.GetIdentities.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.User.Actions.GetIdentities.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.GetIdentities.RequestV1Builder{
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
    public func setUserId(value:String)-> Services.User.Actions.GetIdentities.RequestV1Builder {
      self.userId = value
      return self
    }
    public func clearUserId() -> Services.User.Actions.GetIdentities.RequestV1Builder{
         builderResult.hasUserId = false
         builderResult.userId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.GetIdentities.RequestV1Builder {
      builderResult = Services.User.Actions.GetIdentities.RequestV1()
      return self
    }
    public override func clone() -> Services.User.Actions.GetIdentities.RequestV1Builder {
      return Services.User.Actions.GetIdentities.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.GetIdentities.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.GetIdentities.RequestV1 {
      var returnMe:Services.User.Actions.GetIdentities.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.GetIdentities.RequestV1) -> Services.User.Actions.GetIdentities.RequestV1Builder {
      if (other == Services.User.Actions.GetIdentities.RequestV1()) {
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
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.GetIdentities.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.GetIdentities.RequestV1Builder {
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
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var identities:Array<Services.User.Containers.IdentityV1>  = Array<Services.User.Containers.IdentityV1>()
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
      for oneElementidentities in identities {
          output.writeMessage(2, value:oneElementidentities)
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
      for oneElementidentities in identities {
          serialize_size += oneElementidentities.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.GetIdentities.ResponseV1 {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.GetIdentities.GetIdentitiesRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.GetIdentities.ResponseV1 {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.GetIdentities.ResponseV1 {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.GetIdentities.ResponseV1 {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.GetIdentities.ResponseV1 {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.GetIdentities.ResponseV1 {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      return Services.User.Actions.GetIdentities.ResponseV1.classBuilder() as! Services.User.Actions.GetIdentities.ResponseV1Builder
    }
    public func builder() -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      return classBuilder() as! Services.User.Actions.GetIdentities.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetIdentities.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.GetIdentities.ResponseV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      return Services.User.Actions.GetIdentities.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.GetIdentities.ResponseV1) -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      return Services.User.Actions.GetIdentities.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var identitiesElementIndex:Int = 0
      for oneElementidentities in identities {
          output += "\(indent) identities[\(identitiesElementIndex)] {\n"
          oneElementidentities.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          identitiesElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementidentities in identities {
                hashCode = (hashCode &* 31) &+ oneElementidentities.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.GetIdentities.ResponseV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.GetIdentities.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.GetIdentities.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.GetIdentities.ResponseV1

    required override public init () {
       builderResult = Services.User.Actions.GetIdentities.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.User.Actions.GetIdentities.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.GetIdentities.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var identities:Array<Services.User.Containers.IdentityV1> {
         get {
             return builderResult.identities
         }
         set (value) {
             builderResult.identities = value
         }
    }
    public func setIdentities(value:Array<Services.User.Containers.IdentityV1>)-> Services.User.Actions.GetIdentities.ResponseV1Builder {
      self.identities = value
      return self
    }
    public func clearIdentities() -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      builderResult.identities.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      builderResult = Services.User.Actions.GetIdentities.ResponseV1()
      return self
    }
    public override func clone() -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      return Services.User.Actions.GetIdentities.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.GetIdentities.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.GetIdentities.ResponseV1 {
      var returnMe:Services.User.Actions.GetIdentities.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.GetIdentities.ResponseV1) -> Services.User.Actions.GetIdentities.ResponseV1Builder {
      if (other == Services.User.Actions.GetIdentities.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.identities.isEmpty  {
         builderResult.identities += other.identities
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.GetIdentities.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.GetIdentities.ResponseV1Builder {
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
          var subBuilder = Services.User.Containers.IdentityV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          identities += [subBuilder.buildPartial()]

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