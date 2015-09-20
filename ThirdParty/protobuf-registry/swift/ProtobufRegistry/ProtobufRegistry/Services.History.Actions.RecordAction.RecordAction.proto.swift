// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file record_action.proto

import Foundation
import ProtocolBuffers


public extension Services{ public struct History { public struct Actions { public struct RecordAction { }}}}

public func == (lhs: Services.History.Actions.RecordAction.RequestV1, rhs: Services.History.Actions.RecordAction.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasAction == rhs.hasAction) && (!lhs.hasAction || lhs.action == rhs.action)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.History.Actions.RecordAction.ResponseV1, rhs: Services.History.Actions.RecordAction.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
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
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasVersion {
        try output.writeUInt32(1, value:version)
      }
      if hasAction {
        try output.writeMessage(2, value:action)
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
      if hasAction {
          if let varSizeaction = action?.computeMessageSize(2) {
              serialize_size += varSizeaction
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.History.Actions.RecordAction.RequestV1> {
      var mergedArray = Array<Services.History.Actions.RecordAction.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.History.Actions.RecordAction.RequestV1? {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.History.Actions.RecordAction.RequestV1 {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.History.Actions.RecordAction.RecordActionRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.RequestV1 {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.History.Actions.RecordAction.RequestV1 {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.RequestV1 {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.History.Actions.RecordAction.RequestV1 {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.RequestV1 {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.History.Actions.RecordAction.RequestV1.Builder {
      return Services.History.Actions.RecordAction.RequestV1.classBuilder() as! Services.History.Actions.RecordAction.RequestV1.Builder
    }
    public func getBuilder() -> Services.History.Actions.RecordAction.RequestV1.Builder {
      return classBuilder() as! Services.History.Actions.RecordAction.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
      return try Services.History.Actions.RecordAction.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.History.Actions.RecordAction.RequestV1) throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
      return try Services.History.Actions.RecordAction.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasAction {
        output += "\(indent) action {\n"
        try action?.writeDescriptionTo(&output, indent:"\(indent)  ")
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

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.History.Actions.RecordAction.RequestV1 = Services.History.Actions.RecordAction.RequestV1()
      public func getMessage() -> Services.History.Actions.RecordAction.RequestV1 {
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
      public func setVersion(value:UInt32) -> Services.History.Actions.RecordAction.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.History.Actions.RecordAction.RequestV1.Builder{
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
               if actionBuilder_ != nil {
                  builderResult.action = actionBuilder_.getMessage()
               }
               return builderResult.action
           }
           set (value) {
               builderResult.hasAction = true
               builderResult.action = value
           }
      }
      private var actionBuilder_:Services.History.Containers.ActionV1.Builder! {
           didSet {
              builderResult.hasAction = true
           }
      }
      public func getActionBuilder() -> Services.History.Containers.ActionV1.Builder {
        if actionBuilder_ == nil {
           actionBuilder_ = Services.History.Containers.ActionV1.Builder()
           builderResult.action = actionBuilder_.getMessage()
           if action != nil {
              try! actionBuilder_.mergeFrom(action)
           }
        }
        return actionBuilder_
      }
      public func setAction(value:Services.History.Containers.ActionV1!) -> Services.History.Actions.RecordAction.RequestV1.Builder {
        self.action = value
        return self
      }
      public func mergeAction(value:Services.History.Containers.ActionV1) throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
        if builderResult.hasAction {
          builderResult.action = try Services.History.Containers.ActionV1.builderWithPrototype(builderResult.action).mergeFrom(value).buildPartial()
        } else {
          builderResult.action = value
        }
        builderResult.hasAction = true
        return self
      }
      public func clearAction() -> Services.History.Actions.RecordAction.RequestV1.Builder {
        actionBuilder_ = nil
        builderResult.hasAction = false
        builderResult.action = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.History.Actions.RecordAction.RequestV1.Builder {
        builderResult = Services.History.Actions.RecordAction.RequestV1()
        return self
      }
      public override func clone() throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
        return try Services.History.Actions.RecordAction.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.History.Actions.RecordAction.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.History.Actions.RecordAction.RequestV1 {
        let returnMe:Services.History.Actions.RecordAction.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.History.Actions.RecordAction.RequestV1) throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
        if other == Services.History.Actions.RecordAction.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if (other.hasAction) {
            try mergeAction(other.action)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.RequestV1.Builder {
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
            let subBuilder:Services.History.Containers.ActionV1.Builder = Services.History.Containers.ActionV1.Builder()
            if hasAction {
              try subBuilder.mergeFrom(action)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            action = subBuilder.buildPartial()

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
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.History.Actions.RecordAction.ResponseV1> {
      var mergedArray = Array<Services.History.Actions.RecordAction.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.History.Actions.RecordAction.ResponseV1? {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.History.Actions.RecordAction.ResponseV1 {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.History.Actions.RecordAction.RecordActionRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.ResponseV1 {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.History.Actions.RecordAction.ResponseV1 {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.ResponseV1 {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.History.Actions.RecordAction.ResponseV1 {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.ResponseV1 {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.History.Actions.RecordAction.ResponseV1.Builder {
      return Services.History.Actions.RecordAction.ResponseV1.classBuilder() as! Services.History.Actions.RecordAction.ResponseV1.Builder
    }
    public func getBuilder() -> Services.History.Actions.RecordAction.ResponseV1.Builder {
      return classBuilder() as! Services.History.Actions.RecordAction.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.History.Actions.RecordAction.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.History.Actions.RecordAction.ResponseV1.Builder {
      return try Services.History.Actions.RecordAction.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.History.Actions.RecordAction.ResponseV1) throws -> Services.History.Actions.RecordAction.ResponseV1.Builder {
      return try Services.History.Actions.RecordAction.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
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

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.History.Actions.RecordAction.ResponseV1 = Services.History.Actions.RecordAction.ResponseV1()
      public func getMessage() -> Services.History.Actions.RecordAction.ResponseV1 {
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
      public func setVersion(value:UInt32) -> Services.History.Actions.RecordAction.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.History.Actions.RecordAction.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.History.Actions.RecordAction.ResponseV1.Builder {
        builderResult = Services.History.Actions.RecordAction.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.History.Actions.RecordAction.ResponseV1.Builder {
        return try Services.History.Actions.RecordAction.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.History.Actions.RecordAction.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.History.Actions.RecordAction.ResponseV1 {
        let returnMe:Services.History.Actions.RecordAction.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.History.Actions.RecordAction.ResponseV1) throws -> Services.History.Actions.RecordAction.ResponseV1.Builder {
        if other == Services.History.Actions.RecordAction.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.History.Actions.RecordAction.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.History.Actions.RecordAction.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 8 :
            version = try input.readUInt32()

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