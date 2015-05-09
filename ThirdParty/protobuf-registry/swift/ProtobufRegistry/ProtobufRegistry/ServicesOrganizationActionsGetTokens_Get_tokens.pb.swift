// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Organization.Actions{ public struct GetTokens { }}

public func == (lhs: Services.Organization.Actions.GetTokens.RequestV1, rhs: Services.Organization.Actions.GetTokens.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Organization.Actions.GetTokens.ResponseV1, rhs: Services.Organization.Actions.GetTokens.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.tokens == rhs.tokens)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Organization.Actions.GetTokens {
  public struct GetTokensRoot {
    public static var sharedInstance : GetTokensRoot {
     struct Static {
         static let instance : GetTokensRoot = GetTokensRoot()
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
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetTokens.RequestV1 {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetTokens.GetTokensRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTokens.RequestV1 {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetTokens.RequestV1 {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetTokens.RequestV1 {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetTokens.RequestV1 {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTokens.RequestV1 {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      return Services.Organization.Actions.GetTokens.RequestV1.classBuilder() as! Services.Organization.Actions.GetTokens.RequestV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetTokens.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTokens.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTokens.RequestV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      return Services.Organization.Actions.GetTokens.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetTokens.RequestV1) -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      return Services.Organization.Actions.GetTokens.RequestV1.builder().mergeFrom(prototype)
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
        return "Services.Organization.Actions.GetTokens.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetTokens.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetTokens.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetTokens.RequestV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetTokens.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetTokens.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetTokens.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      builderResult = Services.Organization.Actions.GetTokens.RequestV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      return Services.Organization.Actions.GetTokens.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetTokens.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetTokens.RequestV1 {
      var returnMe:Services.Organization.Actions.GetTokens.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetTokens.RequestV1) -> Services.Organization.Actions.GetTokens.RequestV1Builder {
      if (other == Services.Organization.Actions.GetTokens.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetTokens.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTokens.RequestV1Builder {
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

  final public class ResponseV1 : GeneratedMessage, GeneratedMessageProtocol {
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var tokens:Array<Services.Organization.Containers.TokenV1>  = Array<Services.Organization.Containers.TokenV1>()
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
      for oneElementtokens in tokens {
          output.writeMessage(2, value:oneElementtokens)
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
      for oneElementtokens in tokens {
          serialize_size += oneElementtokens.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetTokens.ResponseV1 {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetTokens.GetTokensRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTokens.ResponseV1 {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetTokens.ResponseV1 {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetTokens.ResponseV1 {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetTokens.ResponseV1 {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTokens.ResponseV1 {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      return Services.Organization.Actions.GetTokens.ResponseV1.classBuilder() as! Services.Organization.Actions.GetTokens.ResponseV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetTokens.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTokens.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      return Services.Organization.Actions.GetTokens.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetTokens.ResponseV1) -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      return Services.Organization.Actions.GetTokens.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var tokensElementIndex:Int = 0
      for oneElementtokens in tokens {
          output += "\(indent) tokens[\(tokensElementIndex)] {\n"
          oneElementtokens.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          tokensElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementtokens in tokens {
                hashCode = (hashCode &* 31) &+ oneElementtokens.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetTokens.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetTokens.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetTokens.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetTokens.ResponseV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetTokens.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetTokens.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var tokens:Array<Services.Organization.Containers.TokenV1> {
         get {
             return builderResult.tokens
         }
         set (value) {
             builderResult.tokens = value
         }
    }
    public func setTokens(value:Array<Services.Organization.Containers.TokenV1>)-> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      self.tokens = value
      return self
    }
    public func clearTokens() -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      builderResult.tokens.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      builderResult = Services.Organization.Actions.GetTokens.ResponseV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      return Services.Organization.Actions.GetTokens.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetTokens.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetTokens.ResponseV1 {
      var returnMe:Services.Organization.Actions.GetTokens.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetTokens.ResponseV1) -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
      if (other == Services.Organization.Actions.GetTokens.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.tokens.isEmpty  {
         builderResult.tokens += other.tokens
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetTokens.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTokens.ResponseV1Builder {
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
          var subBuilder = Services.Organization.Containers.TokenV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          tokens += [subBuilder.buildPartial()]

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