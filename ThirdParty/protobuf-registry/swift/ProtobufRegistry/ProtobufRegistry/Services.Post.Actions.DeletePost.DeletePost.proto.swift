// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file delete_post.proto

import Foundation

public extension Services.Post.Actions{ public struct DeletePost { }}

public func == (lhs: Services.Post.Actions.DeletePost.RequestV1, rhs: Services.Post.Actions.DeletePost.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasId == rhs.hasId) && (!lhs.hasId || lhs.id == rhs.id)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Post.Actions.DeletePost.ResponseV1, rhs: Services.Post.Actions.DeletePost.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Post.Actions.DeletePost {
  public struct DeletePostRoot {
    public static var sharedInstance : DeletePostRoot {
     struct Static {
         static let instance : DeletePostRoot = DeletePostRoot()
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
    public private(set) var hasId:Bool = false
    public private(set) var id:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasId {
        try output.writeString(1, value:id)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasId {
        serialize_size += id.computeStringSize(1)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Post.Actions.DeletePost.RequestV1> {
      var mergedArray = Array<Services.Post.Actions.DeletePost.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Post.Actions.DeletePost.RequestV1? {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Post.Actions.DeletePost.RequestV1 {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Post.Actions.DeletePost.DeletePostRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.RequestV1 {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Post.Actions.DeletePost.RequestV1 {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.RequestV1 {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Post.Actions.DeletePost.RequestV1 {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.RequestV1 {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Post.Actions.DeletePost.RequestV1.Builder {
      return Services.Post.Actions.DeletePost.RequestV1.classBuilder() as! Services.Post.Actions.DeletePost.RequestV1.Builder
    }
    public func getBuilder() -> Services.Post.Actions.DeletePost.RequestV1.Builder {
      return classBuilder() as! Services.Post.Actions.DeletePost.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Post.Actions.DeletePost.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Post.Actions.DeletePost.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Post.Actions.DeletePost.RequestV1.Builder {
      return try Services.Post.Actions.DeletePost.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Post.Actions.DeletePost.RequestV1) throws -> Services.Post.Actions.DeletePost.RequestV1.Builder {
      return try Services.Post.Actions.DeletePost.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasId {
        output += "\(indent) id: \(id) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasId {
               hashCode = (hashCode &* 31) &+ id.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Post.Actions.DeletePost.RequestV1"
    }
    override public func className() -> String {
        return "Services.Post.Actions.DeletePost.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Post.Actions.DeletePost.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Post.Actions.DeletePost.RequestV1 = Services.Post.Actions.DeletePost.RequestV1()
      public func getMessage() -> Services.Post.Actions.DeletePost.RequestV1 {
          return builderResult
      }

      required override public init () {
         super.init()
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
      public func setId(value:String) -> Services.Post.Actions.DeletePost.RequestV1.Builder {
        self.id = value
        return self
      }
      public func clearId() -> Services.Post.Actions.DeletePost.RequestV1.Builder{
           builderResult.hasId = false
           builderResult.id = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Post.Actions.DeletePost.RequestV1.Builder {
        builderResult = Services.Post.Actions.DeletePost.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Post.Actions.DeletePost.RequestV1.Builder {
        return try Services.Post.Actions.DeletePost.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Post.Actions.DeletePost.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Post.Actions.DeletePost.RequestV1 {
        let returnMe:Services.Post.Actions.DeletePost.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Post.Actions.DeletePost.RequestV1) throws -> Services.Post.Actions.DeletePost.RequestV1.Builder {
        if other == Services.Post.Actions.DeletePost.RequestV1() {
         return self
        }
        if other.hasId {
             id = other.id
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Post.Actions.DeletePost.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            id = try input.readString()

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
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Post.Actions.DeletePost.ResponseV1> {
      var mergedArray = Array<Services.Post.Actions.DeletePost.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Post.Actions.DeletePost.ResponseV1? {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Post.Actions.DeletePost.ResponseV1 {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Post.Actions.DeletePost.DeletePostRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.ResponseV1 {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Post.Actions.DeletePost.ResponseV1 {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.ResponseV1 {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Post.Actions.DeletePost.ResponseV1 {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.ResponseV1 {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
      return Services.Post.Actions.DeletePost.ResponseV1.classBuilder() as! Services.Post.Actions.DeletePost.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
      return classBuilder() as! Services.Post.Actions.DeletePost.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Post.Actions.DeletePost.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Post.Actions.DeletePost.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
      return try Services.Post.Actions.DeletePost.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Post.Actions.DeletePost.ResponseV1) throws -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
      return try Services.Post.Actions.DeletePost.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Post.Actions.DeletePost.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Post.Actions.DeletePost.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Post.Actions.DeletePost.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Post.Actions.DeletePost.ResponseV1 = Services.Post.Actions.DeletePost.ResponseV1()
      public func getMessage() -> Services.Post.Actions.DeletePost.ResponseV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
        builderResult = Services.Post.Actions.DeletePost.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
        return try Services.Post.Actions.DeletePost.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Post.Actions.DeletePost.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Post.Actions.DeletePost.ResponseV1 {
        let returnMe:Services.Post.Actions.DeletePost.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Post.Actions.DeletePost.ResponseV1) throws -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
        if other == Services.Post.Actions.DeletePost.ResponseV1() {
         return self
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Post.Actions.DeletePost.ResponseV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

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