// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.User.Actions{ public struct BulkCreateUsers { }}

public func == (lhs: Services.User.Actions.BulkCreateUsers.RequestV1, rhs: Services.User.Actions.BulkCreateUsers.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.users == rhs.users)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.User.Actions.BulkCreateUsers.ResponseV1, rhs: Services.User.Actions.BulkCreateUsers.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.users == rhs.users)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.User.Actions.BulkCreateUsers {
  public struct BulkCreateUsersRoot {
    public static var sharedInstance : BulkCreateUsersRoot {
     struct Static {
         static let instance : BulkCreateUsersRoot = BulkCreateUsersRoot()
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
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var users:Array<Services.User.Containers.UserV1>  = Array<Services.User.Containers.UserV1>()
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
      for oneElementusers in users {
          output.writeMessage(2, value:oneElementusers)
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
      for oneElementusers in users {
          serialize_size += oneElementusers.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.BulkCreateUsers.RequestV1 {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.BulkCreateUsers.BulkCreateUsersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.BulkCreateUsers.RequestV1 {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.BulkCreateUsers.RequestV1 {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.BulkCreateUsers.RequestV1 {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.BulkCreateUsers.RequestV1 {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.BulkCreateUsers.RequestV1 {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      return Services.User.Actions.BulkCreateUsers.RequestV1.classBuilder() as! Services.User.Actions.BulkCreateUsers.RequestV1Builder
    }
    public func builder() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      return classBuilder() as! Services.User.Actions.BulkCreateUsers.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.BulkCreateUsers.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.BulkCreateUsers.RequestV1) -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var usersElementIndex:Int = 0
      for oneElementusers in users {
          output += "\(indent) users[\(usersElementIndex)] {\n"
          oneElementusers.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          usersElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementusers in users {
                hashCode = (hashCode &* 31) &+ oneElementusers.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.BulkCreateUsers.RequestV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.BulkCreateUsers.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.BulkCreateUsers.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.BulkCreateUsers.RequestV1

    required override public init () {
       builderResult = Services.User.Actions.BulkCreateUsers.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var users:Array<Services.User.Containers.UserV1> {
         get {
             return builderResult.users
         }
         set (value) {
             builderResult.users = value
         }
    }
    public func setUsers(value:Array<Services.User.Containers.UserV1>)-> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      self.users = value
      return self
    }
    public func clearUsers() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      builderResult.users.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      builderResult = Services.User.Actions.BulkCreateUsers.RequestV1()
      return self
    }
    public override func clone() -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      return Services.User.Actions.BulkCreateUsers.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.BulkCreateUsers.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.BulkCreateUsers.RequestV1 {
      var returnMe:Services.User.Actions.BulkCreateUsers.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.BulkCreateUsers.RequestV1) -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
      if (other == Services.User.Actions.BulkCreateUsers.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.users.isEmpty  {
         builderResult.users += other.users
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.BulkCreateUsers.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.BulkCreateUsers.RequestV1Builder {
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
          var subBuilder = Services.User.Containers.UserV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          users += [subBuilder.buildPartial()]

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
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var users:Array<Services.User.Containers.UserV1>  = Array<Services.User.Containers.UserV1>()
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
      for oneElementusers in users {
          output.writeMessage(2, value:oneElementusers)
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
      for oneElementusers in users {
          serialize_size += oneElementusers.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.User.Actions.BulkCreateUsers.BulkCreateUsersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.User.Actions.BulkCreateUsers.ResponseV1 {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.classBuilder() as! Services.User.Actions.BulkCreateUsers.ResponseV1Builder
    }
    public func builder() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      return classBuilder() as! Services.User.Actions.BulkCreateUsers.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.User.Actions.BulkCreateUsers.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder()
    }
    public func toBuilder() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.User.Actions.BulkCreateUsers.ResponseV1) -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var usersElementIndex:Int = 0
      for oneElementusers in users {
          output += "\(indent) users[\(usersElementIndex)] {\n"
          oneElementusers.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          usersElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementusers in users {
                hashCode = (hashCode &* 31) &+ oneElementusers.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.User.Actions.BulkCreateUsers.ResponseV1"
    }
    override public func className() -> String {
        return "Services.User.Actions.BulkCreateUsers.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.User.Actions.BulkCreateUsers.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.User.Actions.BulkCreateUsers.ResponseV1

    required override public init () {
       builderResult = Services.User.Actions.BulkCreateUsers.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var users:Array<Services.User.Containers.UserV1> {
         get {
             return builderResult.users
         }
         set (value) {
             builderResult.users = value
         }
    }
    public func setUsers(value:Array<Services.User.Containers.UserV1>)-> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      self.users = value
      return self
    }
    public func clearUsers() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      builderResult.users.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      builderResult = Services.User.Actions.BulkCreateUsers.ResponseV1()
      return self
    }
    public override func clone() -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      return Services.User.Actions.BulkCreateUsers.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.User.Actions.BulkCreateUsers.ResponseV1 {
      var returnMe:Services.User.Actions.BulkCreateUsers.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.User.Actions.BulkCreateUsers.ResponseV1) -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
      if (other == Services.User.Actions.BulkCreateUsers.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.users.isEmpty  {
         builderResult.users += other.users
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.User.Actions.BulkCreateUsers.ResponseV1Builder {
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
          var subBuilder = Services.User.Containers.UserV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          users += [subBuilder.buildPartial()]

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
