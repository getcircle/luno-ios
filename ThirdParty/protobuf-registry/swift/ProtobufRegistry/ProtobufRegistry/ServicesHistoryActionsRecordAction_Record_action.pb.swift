// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services{ public struct History { public struct Actions { public struct RecordAction { }}}}

public func == (lhs: Services.History.Actions.RecordAction.RequestV1, rhs: Services.History.Actions.RecordAction.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasAction == rhs.hasAction) && (!lhs.hasAction || lhs.action == rhs.action)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.History.Actions.RecordAction.ResponseV1, rhs: Services.History.Actions.RecordAction.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.History.Actions.RecordAction {
  public struct RecordActionRoot {
    public static var sharedInstance : RecordActionRoot {
     struct Static {
         static let instance : RecordActionRoot = RecordActionRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.History.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "action": return action
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasAction:Bool = false
    public private(set) var action:Services.History.Containers.ActionV1!
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
      if hasAction {
        output.writeMessage(2, value:action)
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
      if hasAction {
          if let varSizeaction = action?.computeMessageSize(2) {
              serialize_size += varSizeaction
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.History.Actions.RecordAction.RequestV1 {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.History.Actions.RecordAction.RecordActionRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.History.Actions.RecordAction.RequestV1 {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.History.Actions.RecordAction.RequestV1 {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.History.Actions.RecordAction.RequestV1 {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.History.Actions.RecordAction.RequestV1 {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.History.Actions.RecordAction.RequestV1 {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.History.Actions.RecordAction.RequestV1Builder {
      return Services.History.Actions.RecordAction.RequestV1.classBuilder() as! Services.History.Actions.RecordAction.RequestV1Builder
    }
    public func builder() -> Services.History.Actions.RecordAction.RequestV1Builder {
      return classBuilder() as! Services.History.Actions.RecordAction.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.RequestV1.builder()
    }
    public func toBuilder() -> Services.History.Actions.RecordAction.RequestV1Builder {
      return Services.History.Actions.RecordAction.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.History.Actions.RecordAction.RequestV1) -> Services.History.Actions.RecordAction.RequestV1Builder {
      return Services.History.Actions.RecordAction.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasAction {
        output += "\(indent) action {\n"
        action?.writeDescriptionTo(&output, indent:"\(indent)  ")
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
            if hasAction {
                if let hashValueaction = action?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValueaction
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.History.Actions.RecordAction.RequestV1"
    }
    override public func className() -> String {
        return "Services.History.Actions.RecordAction.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.History.Actions.RecordAction.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.History.Actions.RecordAction.RequestV1

    required override public init () {
       builderResult = Services.History.Actions.RecordAction.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.History.Actions.RecordAction.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.History.Actions.RecordAction.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasAction:Bool {
         get {
             return builderResult.hasAction
         }
    }
    public var action:Services.History.Containers.ActionV1! {
         get {
             return builderResult.action
         }
         set (value) {
             builderResult.hasAction = true
             builderResult.action = value
         }
    }
    public func setAction(value:Services.History.Containers.ActionV1!)-> Services.History.Actions.RecordAction.RequestV1Builder {
      self.action = value
      return self
    }
    public func mergeAction(value:Services.History.Containers.ActionV1) -> Services.History.Actions.RecordAction.RequestV1Builder {
      if (builderResult.hasAction) {
        builderResult.action = Services.History.Containers.ActionV1.builderWithPrototype(builderResult.action).mergeFrom(value).buildPartial()
      } else {
        builderResult.action = value
      }
      builderResult.hasAction = true
      return self
    }
    public func clearAction() -> Services.History.Actions.RecordAction.RequestV1Builder {
      builderResult.hasAction = false
      builderResult.action = nil
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.History.Actions.RecordAction.RequestV1Builder {
      builderResult = Services.History.Actions.RecordAction.RequestV1()
      return self
    }
    public override func clone() -> Services.History.Actions.RecordAction.RequestV1Builder {
      return Services.History.Actions.RecordAction.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.History.Actions.RecordAction.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.History.Actions.RecordAction.RequestV1 {
      var returnMe:Services.History.Actions.RecordAction.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.History.Actions.RecordAction.RequestV1) -> Services.History.Actions.RecordAction.RequestV1Builder {
      if (other == Services.History.Actions.RecordAction.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if (other.hasAction) {
          mergeAction(other.action)
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.History.Actions.RecordAction.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.History.Actions.RecordAction.RequestV1Builder {
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
          var subBuilder:Services.History.Containers.ActionV1Builder = Services.History.Containers.ActionV1.builder()
          if hasAction {
            subBuilder.mergeFrom(action)
          }
          input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
          action = subBuilder.buildPartial()

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
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.History.Actions.RecordAction.ResponseV1 {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.History.Actions.RecordAction.RecordActionRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.History.Actions.RecordAction.ResponseV1 {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.History.Actions.RecordAction.ResponseV1 {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.History.Actions.RecordAction.ResponseV1 {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.History.Actions.RecordAction.ResponseV1 {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.History.Actions.RecordAction.ResponseV1 {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.History.Actions.RecordAction.ResponseV1Builder {
      return Services.History.Actions.RecordAction.ResponseV1.classBuilder() as! Services.History.Actions.RecordAction.ResponseV1Builder
    }
    public func builder() -> Services.History.Actions.RecordAction.ResponseV1Builder {
      return classBuilder() as! Services.History.Actions.RecordAction.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.ResponseV1.builder()
    }
    public func toBuilder() -> Services.History.Actions.RecordAction.ResponseV1Builder {
      return Services.History.Actions.RecordAction.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.History.Actions.RecordAction.ResponseV1) -> Services.History.Actions.RecordAction.ResponseV1Builder {
      return Services.History.Actions.RecordAction.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.History.Actions.RecordAction.ResponseV1"
    }
    override public func className() -> String {
        return "Services.History.Actions.RecordAction.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.History.Actions.RecordAction.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.History.Actions.RecordAction.ResponseV1

    required override public init () {
       builderResult = Services.History.Actions.RecordAction.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.History.Actions.RecordAction.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.History.Actions.RecordAction.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.History.Actions.RecordAction.ResponseV1Builder {
      builderResult = Services.History.Actions.RecordAction.ResponseV1()
      return self
    }
    public override func clone() -> Services.History.Actions.RecordAction.ResponseV1Builder {
      return Services.History.Actions.RecordAction.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.History.Actions.RecordAction.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.History.Actions.RecordAction.ResponseV1 {
      var returnMe:Services.History.Actions.RecordAction.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.History.Actions.RecordAction.ResponseV1) -> Services.History.Actions.RecordAction.ResponseV1Builder {
      if (other == Services.History.Actions.RecordAction.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.History.Actions.RecordAction.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.History.Actions.RecordAction.ResponseV1Builder {
      var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        var tag = input.readTag()
        switch tag {
        case 0: 
          self.unknownFields = unknownFieldsBuilder.build()
          return self

        case 8 :
          version = input.readUInt32()

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
