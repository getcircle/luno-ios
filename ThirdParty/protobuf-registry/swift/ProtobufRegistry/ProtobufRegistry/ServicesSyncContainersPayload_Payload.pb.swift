// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Sync{ public struct Containers { public struct Payload { }}}

public func == (lhs: Services.Sync.Containers.Payload.PayloadV1, rhs: Services.Sync.Containers.Payload.PayloadV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasPayload == rhs.hasPayload) && (!lhs.hasPayload || lhs.payload == rhs.payload)
  fieldCheck = fieldCheck && (lhs.hasPayloadType == rhs.hasPayloadType) && (!lhs.hasPayloadType || lhs.payloadType == rhs.payloadType)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Sync.Containers.Payload {
  public struct PayloadRoot {
    public static var sharedInstance : PayloadRoot {
     struct Static {
         static let instance : PayloadRoot = PayloadRoot()
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

  final public class PayloadV1 : GeneratedMessage, GeneratedMessageProtocol {


      //Enum type declaration start 

      public enum PayloadTypeV1:Int32 {
        case Users = 0
        case Groups = 1

      }

      //Enum type declaration end 

    override public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "payload": return payload
           case "payloadType": return self.payloadType
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasPayload:Bool = false
    public private(set) var payload:String = ""

    public private(set) var payloadType:Services.Sync.Containers.Payload.PayloadV1.PayloadTypeV1 = Services.Sync.Containers.Payload.PayloadV1.PayloadTypeV1.Users
    public private(set) var hasPayloadType:Bool = false
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
      if hasPayload {
        output.writeString(2, value:payload)
      }
      if hasPayloadType {
        output.writeEnum(3, value:payloadType.rawValue)
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
      if hasPayload {
        serialize_size += payload.computeStringSize(2)
      }
      if (hasPayloadType) {
        serialize_size += payloadType.rawValue.computeEnumSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Sync.Containers.Payload.PayloadV1 {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFromData(data, extensionRegistry:Services.Sync.Containers.Payload.PayloadRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Sync.Containers.Payload.PayloadV1 {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Sync.Containers.Payload.PayloadV1 {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Sync.Containers.Payload.PayloadV1 {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Sync.Containers.Payload.PayloadV1 {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Sync.Containers.Payload.PayloadV1 {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Sync.Containers.Payload.PayloadV1Builder {
      return Services.Sync.Containers.Payload.PayloadV1.classBuilder() as! Services.Sync.Containers.Payload.PayloadV1Builder
    }
    public func builder() -> Services.Sync.Containers.Payload.PayloadV1Builder {
      return classBuilder() as! Services.Sync.Containers.Payload.PayloadV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Sync.Containers.Payload.PayloadV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Sync.Containers.Payload.PayloadV1.builder()
    }
    public func toBuilder() -> Services.Sync.Containers.Payload.PayloadV1Builder {
      return Services.Sync.Containers.Payload.PayloadV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Sync.Containers.Payload.PayloadV1) -> Services.Sync.Containers.Payload.PayloadV1Builder {
      return Services.Sync.Containers.Payload.PayloadV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasPayload {
        output += "\(indent) payload: \(payload) \n"
      }
      if (hasPayloadType) {
        output += "\(indent) payloadType: \(payloadType.rawValue)\n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasPayload {
               hashCode = (hashCode &* 31) &+ payload.hashValue
            }
            if hasPayloadType {
               hashCode = (hashCode &* 31) &+ Int(payloadType.rawValue)
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Sync.Containers.Payload.PayloadV1"
    }
    override public func className() -> String {
        return "Services.Sync.Containers.Payload.PayloadV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Sync.Containers.Payload.PayloadV1.self
    }
    //Meta information declaration end

  }

  final public class PayloadV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Sync.Containers.Payload.PayloadV1

    required override public init () {
       builderResult = Services.Sync.Containers.Payload.PayloadV1()
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
    public func setVersion(value:UInt32)-> Services.Sync.Containers.Payload.PayloadV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Sync.Containers.Payload.PayloadV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasPayload:Bool {
         get {
              return builderResult.hasPayload
         }
    }
    public var payload:String {
         get {
              return builderResult.payload
         }
         set (value) {
             builderResult.hasPayload = true
             builderResult.payload = value
         }
    }
    public func setPayload(value:String)-> Services.Sync.Containers.Payload.PayloadV1Builder {
      self.payload = value
      return self
    }
    public func clearPayload() -> Services.Sync.Containers.Payload.PayloadV1Builder{
         builderResult.hasPayload = false
         builderResult.payload = ""
         return self
    }
      public var hasPayloadType:Bool{
          get {
              return builderResult.hasPayloadType
          }
      }
      public var payloadType:Services.Sync.Containers.Payload.PayloadV1.PayloadTypeV1 {
          get {
              return builderResult.payloadType
          }
          set (value) {
              builderResult.hasPayloadType = true
              builderResult.payloadType = value
          }
      }
      public func setPayloadType(value:Services.Sync.Containers.Payload.PayloadV1.PayloadTypeV1)-> Services.Sync.Containers.Payload.PayloadV1Builder {
        self.payloadType = value
        return self
      }
      public func clearPayloadType() -> Services.Sync.Containers.Payload.PayloadV1Builder {
         builderResult.hasPayloadType = false
         builderResult.payloadType = .Users
         return self
      }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Sync.Containers.Payload.PayloadV1Builder {
      builderResult = Services.Sync.Containers.Payload.PayloadV1()
      return self
    }
    public override func clone() -> Services.Sync.Containers.Payload.PayloadV1Builder {
      return Services.Sync.Containers.Payload.PayloadV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Sync.Containers.Payload.PayloadV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Sync.Containers.Payload.PayloadV1 {
      var returnMe:Services.Sync.Containers.Payload.PayloadV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Sync.Containers.Payload.PayloadV1) -> Services.Sync.Containers.Payload.PayloadV1Builder {
      if (other == Services.Sync.Containers.Payload.PayloadV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasPayload {
           payload = other.payload
      }
      if other.hasPayloadType {
           payloadType = other.payloadType
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Sync.Containers.Payload.PayloadV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Sync.Containers.Payload.PayloadV1Builder {
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
          payload = input.readString()

        case 24 :
          let valueIntpayloadType = input.readEnum()
          if let enumspayloadType = Services.Sync.Containers.Payload.PayloadV1.PayloadTypeV1(rawValue:valueIntpayloadType){
               payloadType = enumspayloadType
          } else {
               unknownFieldsBuilder.mergeVarintField(3, value:Int64(valueIntpayloadType))
          }

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