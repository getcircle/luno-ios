// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file create_token.proto

import Foundation

public extension Services.Organization.Actions{ public struct CreateToken { }}

public func == (lhs: Services.Organization.Actions.CreateToken.RequestV1, rhs: Services.Organization.Actions.CreateToken.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Organization.Actions.CreateToken.ResponseV1, rhs: Services.Organization.Actions.CreateToken.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasToken == rhs.hasToken) && (!lhs.hasToken || lhs.token == rhs.token)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Organization.Actions.CreateToken {
  public struct CreateTokenRoot {
    public static var sharedInstance : CreateTokenRoot {
     struct Static {
         static let instance : CreateTokenRoot = CreateTokenRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Organization.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
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
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Organization.Actions.CreateToken.RequestV1> {
      var mergedArray = Array<Services.Organization.Actions.CreateToken.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.CreateToken.RequestV1? {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Organization.Actions.CreateToken.RequestV1 {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.CreateToken.CreateTokenRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.RequestV1 {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.CreateToken.RequestV1 {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.RequestV1 {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.CreateToken.RequestV1 {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.RequestV1 {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
      return Services.Organization.Actions.CreateToken.RequestV1.classBuilder() as! Services.Organization.Actions.CreateToken.RequestV1.Builder
    }
    public func getBuilder() -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
      return classBuilder() as! Services.Organization.Actions.CreateToken.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.CreateToken.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.CreateToken.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
      return try Services.Organization.Actions.CreateToken.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.CreateToken.RequestV1) throws -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
      return try Services.Organization.Actions.CreateToken.RequestV1.Builder().mergeFrom(prototype)
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
        return "Services.Organization.Actions.CreateToken.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.CreateToken.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.CreateToken.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Organization.Actions.CreateToken.RequestV1 = Services.Organization.Actions.CreateToken.RequestV1()
      public func getMessage() -> Services.Organization.Actions.CreateToken.RequestV1 {
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
      public func setVersion(value:UInt32) -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Organization.Actions.CreateToken.RequestV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
        builderResult = Services.Organization.Actions.CreateToken.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
        return try Services.Organization.Actions.CreateToken.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Organization.Actions.CreateToken.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Organization.Actions.CreateToken.RequestV1 {
        let returnMe:Services.Organization.Actions.CreateToken.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Organization.Actions.CreateToken.RequestV1) throws -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
        if other == Services.Organization.Actions.CreateToken.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.RequestV1.Builder {
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

  final public class ResponseV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasToken:Bool = false
    public private(set) var token:Services.Organization.Containers.TokenV1!
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
      if hasToken {
        try output.writeMessage(2, value:token)
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
      if hasToken {
          if let varSizetoken = token?.computeMessageSize(2) {
              serialize_size += varSizetoken
          }
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Organization.Actions.CreateToken.ResponseV1> {
      var mergedArray = Array<Services.Organization.Actions.CreateToken.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.CreateToken.ResponseV1? {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.CreateToken.CreateTokenRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
      return Services.Organization.Actions.CreateToken.ResponseV1.classBuilder() as! Services.Organization.Actions.CreateToken.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
      return classBuilder() as! Services.Organization.Actions.CreateToken.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.CreateToken.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.CreateToken.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
      return try Services.Organization.Actions.CreateToken.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.CreateToken.ResponseV1) throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
      return try Services.Organization.Actions.CreateToken.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasToken {
        output += "\(indent) token {\n"
        try token?.writeDescriptionTo(&output, indent:"\(indent)  ")
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
            if hasToken {
                if let hashValuetoken = token?.hashValue {
                    hashCode = (hashCode &* 31) &+ hashValuetoken
                }
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.CreateToken.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.CreateToken.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.CreateToken.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Organization.Actions.CreateToken.ResponseV1 = Services.Organization.Actions.CreateToken.ResponseV1()
      public func getMessage() -> Services.Organization.Actions.CreateToken.ResponseV1 {
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
      public func setVersion(value:UInt32) -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Organization.Actions.CreateToken.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasToken:Bool {
           get {
               return builderResult.hasToken
           }
      }
      public var token:Services.Organization.Containers.TokenV1! {
           get {
               if tokenBuilder_ != nil {
                  builderResult.token = tokenBuilder_.getMessage()
               }
               return builderResult.token
           }
           set (value) {
               builderResult.hasToken = true
               builderResult.token = value
           }
      }
      private var tokenBuilder_:Services.Organization.Containers.TokenV1.Builder! {
           didSet {
              builderResult.hasToken = true
           }
      }
      public func getTokenBuilder() -> Services.Organization.Containers.TokenV1.Builder {
        if tokenBuilder_ == nil {
           tokenBuilder_ = Services.Organization.Containers.TokenV1.Builder()
           builderResult.token = tokenBuilder_.getMessage()
           if token != nil {
              try! tokenBuilder_.mergeFrom(token)
           }
        }
        return tokenBuilder_
      }
      public func setToken(value:Services.Organization.Containers.TokenV1!) -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        self.token = value
        return self
      }
      public func mergeToken(value:Services.Organization.Containers.TokenV1) throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        if builderResult.hasToken {
          builderResult.token = try Services.Organization.Containers.TokenV1.builderWithPrototype(builderResult.token).mergeFrom(value).buildPartial()
        } else {
          builderResult.token = value
        }
        builderResult.hasToken = true
        return self
      }
      public func clearToken() -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        tokenBuilder_ = nil
        builderResult.hasToken = false
        builderResult.token = nil
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        builderResult = Services.Organization.Actions.CreateToken.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        return try Services.Organization.Actions.CreateToken.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Organization.Actions.CreateToken.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Organization.Actions.CreateToken.ResponseV1 {
        let returnMe:Services.Organization.Actions.CreateToken.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Organization.Actions.CreateToken.ResponseV1) throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
        if other == Services.Organization.Actions.CreateToken.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if (other.hasToken) {
            try mergeToken(other.token)
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.CreateToken.ResponseV1.Builder {
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
            let subBuilder:Services.Organization.Containers.TokenV1.Builder = Services.Organization.Containers.TokenV1.Builder()
            if hasToken {
              try subBuilder.mergeFrom(token)
            }
            try input.readMessage(subBuilder, extensionRegistry:extensionRegistry)
            token = subBuilder.buildPartial()

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
