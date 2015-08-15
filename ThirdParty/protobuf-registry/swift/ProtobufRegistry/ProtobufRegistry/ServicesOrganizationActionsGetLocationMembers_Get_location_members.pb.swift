// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Organization.Actions{ public struct GetLocationMembers { }}

public func == (lhs: Services.Organization.Actions.GetLocationMembers.RequestV1, rhs: Services.Organization.Actions.GetLocationMembers.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasLocationId == rhs.hasLocationId) && (!lhs.hasLocationId || lhs.locationId == rhs.locationId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Organization.Actions.GetLocationMembers.ResponseV1, rhs: Services.Organization.Actions.GetLocationMembers.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.memberProfileIds == rhs.memberProfileIds)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Organization.Actions.GetLocationMembers {
  public struct GetLocationMembersRoot {
    public static var sharedInstance : GetLocationMembersRoot {
     struct Static {
         static let instance : GetLocationMembersRoot = GetLocationMembersRoot()
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
           case "locationId": return locationId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasLocationId:Bool = false
    public private(set) var locationId:String = ""

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
      if hasLocationId {
        output.writeString(2, value:locationId)
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
      if hasLocationId {
        serialize_size += locationId.computeStringSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetLocationMembers.GetLocationMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetLocationMembers.RequestV1 {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.classBuilder() as! Services.Organization.Actions.GetLocationMembers.RequestV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetLocationMembers.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetLocationMembers.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetLocationMembers.RequestV1) -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasLocationId {
        output += "\(indent) locationId: \(locationId) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasLocationId {
               hashCode = (hashCode &* 31) &+ locationId.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetLocationMembers.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetLocationMembers.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetLocationMembers.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetLocationMembers.RequestV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetLocationMembers.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasLocationId:Bool {
         get {
              return builderResult.hasLocationId
         }
    }
    public var locationId:String {
         get {
              return builderResult.locationId
         }
         set (value) {
             builderResult.hasLocationId = true
             builderResult.locationId = value
         }
    }
    public func setLocationId(value:String)-> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      self.locationId = value
      return self
    }
    public func clearLocationId() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder{
         builderResult.hasLocationId = false
         builderResult.locationId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      builderResult = Services.Organization.Actions.GetLocationMembers.RequestV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      return Services.Organization.Actions.GetLocationMembers.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetLocationMembers.RequestV1 {
      var returnMe:Services.Organization.Actions.GetLocationMembers.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetLocationMembers.RequestV1) -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
      if (other == Services.Organization.Actions.GetLocationMembers.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasLocationId {
           locationId = other.locationId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetLocationMembers.RequestV1Builder {
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
          locationId = input.readString()

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

    public private(set) var memberProfileIds:Array<String> = Array<String>()
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
      if !memberProfileIds.isEmpty {
        for oneValuememberProfileIds in memberProfileIds {
          output.writeString(2, value:oneValuememberProfileIds)
        }
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
      var dataSizeMemberProfileIds:Int32 = 0
      for oneValuememberProfileIds in memberProfileIds {
          dataSizeMemberProfileIds += oneValuememberProfileIds.computeStringSizeNoTag()
      }
      serialize_size += dataSizeMemberProfileIds
      serialize_size += 1 * Int32(memberProfileIds.count)
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetLocationMembers.GetLocationMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.classBuilder() as! Services.Organization.Actions.GetLocationMembers.ResponseV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetLocationMembers.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetLocationMembers.ResponseV1) -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var memberProfileIdsElementIndex:Int = 0
      for oneValuememberProfileIds in memberProfileIds  {
          output += "\(indent) memberProfileIds[\(memberProfileIdsElementIndex)]: \(oneValuememberProfileIds)\n"
          memberProfileIdsElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneValuememberProfileIds in memberProfileIds {
                hashCode = (hashCode &* 31) &+ oneValuememberProfileIds.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetLocationMembers.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetLocationMembers.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetLocationMembers.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetLocationMembers.ResponseV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetLocationMembers.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var memberProfileIds:Array<String> {
         get {
             return builderResult.memberProfileIds
         }
         set (array) {
             builderResult.memberProfileIds = array
         }
    }
    public func setMemberProfileIds(value:Array<String>)-> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      self.memberProfileIds = value
      return self
    }
    public func clearMemberProfileIds() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
       builderResult.memberProfileIds.removeAll(keepCapacity: false)
       return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      builderResult = Services.Organization.Actions.GetLocationMembers.ResponseV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      return Services.Organization.Actions.GetLocationMembers.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetLocationMembers.ResponseV1 {
      var returnMe:Services.Organization.Actions.GetLocationMembers.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetLocationMembers.ResponseV1) -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
      if (other == Services.Organization.Actions.GetLocationMembers.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.memberProfileIds.isEmpty {
          builderResult.memberProfileIds += other.memberProfileIds
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetLocationMembers.ResponseV1Builder {
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
          memberProfileIds += [input.readString()]

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