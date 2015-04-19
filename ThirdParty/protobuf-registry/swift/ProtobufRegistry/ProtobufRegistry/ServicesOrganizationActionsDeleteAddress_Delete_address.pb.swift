// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Organization.Actions{ public struct DeleteAddress { }}

public func == (lhs: Services.Organization.Actions.DeleteAddress.RequestV1, rhs: Services.Organization.Actions.DeleteAddress.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasAddressId == rhs.hasAddressId) && (!lhs.hasAddressId || lhs.addressId == rhs.addressId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Organization.Actions.DeleteAddress.ResponseV1, rhs: Services.Organization.Actions.DeleteAddress.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Organization.Actions.DeleteAddress {
  public struct DeleteAddressRoot {
    public static var sharedInstance : DeleteAddressRoot {
     struct Static {
         static let instance : DeleteAddressRoot = DeleteAddressRoot()
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
    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "addressId": return addressId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasAddressId:Bool = false
    public private(set) var addressId:String = ""

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
      if hasAddressId {
        output.writeString(2, value:addressId)
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
      if hasAddressId {
        serialize_size += addressId.computeStringSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.DeleteAddress.RequestV1 {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.DeleteAddress.DeleteAddressRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.DeleteAddress.RequestV1 {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.DeleteAddress.RequestV1 {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.DeleteAddress.RequestV1 {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.DeleteAddress.RequestV1 {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.DeleteAddress.RequestV1 {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      return Services.Organization.Actions.DeleteAddress.RequestV1.classBuilder() as! Services.Organization.Actions.DeleteAddress.RequestV1Builder
    }
    public func builder() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      return classBuilder() as! Services.Organization.Actions.DeleteAddress.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.DeleteAddress.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.DeleteAddress.RequestV1) -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasAddressId {
        output += "\(indent) addressId: \(addressId) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasAddressId {
               hashCode = (hashCode &* 31) &+ addressId.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.DeleteAddress.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.DeleteAddress.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.DeleteAddress.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.DeleteAddress.RequestV1

    required override public init () {
       builderResult = Services.Organization.Actions.DeleteAddress.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasAddressId:Bool {
         get {
              return builderResult.hasAddressId
         }
    }
    public var addressId:String {
         get {
              return builderResult.addressId
         }
         set (value) {
             builderResult.hasAddressId = true
             builderResult.addressId = value
         }
    }
    public func setAddressId(value:String)-> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      self.addressId = value
      return self
    }
    public func clearAddressId() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder{
         builderResult.hasAddressId = false
         builderResult.addressId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      builderResult = Services.Organization.Actions.DeleteAddress.RequestV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      return Services.Organization.Actions.DeleteAddress.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.DeleteAddress.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.DeleteAddress.RequestV1 {
      var returnMe:Services.Organization.Actions.DeleteAddress.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.DeleteAddress.RequestV1) -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
      if (other == Services.Organization.Actions.DeleteAddress.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasAddressId {
           addressId = other.addressId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.DeleteAddress.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.DeleteAddress.RequestV1Builder {
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
          addressId = input.readString()

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
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.DeleteAddress.DeleteAddressRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.DeleteAddress.ResponseV1 {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.classBuilder() as! Services.Organization.Actions.DeleteAddress.ResponseV1Builder
    }
    public func builder() -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      return classBuilder() as! Services.Organization.Actions.DeleteAddress.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.DeleteAddress.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.DeleteAddress.ResponseV1) -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builder().mergeFrom(prototype)
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
        return "Services.Organization.Actions.DeleteAddress.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.DeleteAddress.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.DeleteAddress.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.DeleteAddress.ResponseV1

    required override public init () {
       builderResult = Services.Organization.Actions.DeleteAddress.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      builderResult = Services.Organization.Actions.DeleteAddress.ResponseV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      return Services.Organization.Actions.DeleteAddress.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.DeleteAddress.ResponseV1 {
      var returnMe:Services.Organization.Actions.DeleteAddress.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.DeleteAddress.ResponseV1) -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
      if (other == Services.Organization.Actions.DeleteAddress.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.DeleteAddress.ResponseV1Builder {
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
