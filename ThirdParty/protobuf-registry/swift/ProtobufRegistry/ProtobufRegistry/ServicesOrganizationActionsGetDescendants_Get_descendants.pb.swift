// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Organization.Actions{ public struct GetDescendants { }}

public func == (lhs: Services.Organization.Actions.GetDescendants.RequestV1, rhs: Services.Organization.Actions.GetDescendants.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasProfileId == rhs.hasProfileId) && (!lhs.hasProfileId || lhs.profileId == rhs.profileId)
  fieldCheck = fieldCheck && (lhs.hasTeamId == rhs.hasTeamId) && (!lhs.hasTeamId || lhs.teamId == rhs.teamId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Organization.Actions.GetDescendants.ResponseV1, rhs: Services.Organization.Actions.GetDescendants.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.profileIds == rhs.profileIds)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Organization.Actions.GetDescendants {
  public struct GetDescendantsRoot {
    public static var sharedInstance : GetDescendantsRoot {
     struct Static {
         static let instance : GetDescendantsRoot = GetDescendantsRoot()
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
           case "profileId": return profileId
           case "teamId": return teamId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasProfileId:Bool = false
    public private(set) var profileId:String = ""

    public private(set) var hasTeamId:Bool = false
    public private(set) var teamId:String = ""

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
      if hasProfileId {
        output.writeString(2, value:profileId)
      }
      if hasTeamId {
        output.writeString(3, value:teamId)
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
      if hasProfileId {
        serialize_size += profileId.computeStringSize(2)
      }
      if hasTeamId {
        serialize_size += teamId.computeStringSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetDescendants.RequestV1 {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetDescendants.GetDescendantsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetDescendants.RequestV1 {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetDescendants.RequestV1 {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetDescendants.RequestV1 {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetDescendants.RequestV1 {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetDescendants.RequestV1 {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      return Services.Organization.Actions.GetDescendants.RequestV1.classBuilder() as! Services.Organization.Actions.GetDescendants.RequestV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetDescendants.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetDescendants.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      return Services.Organization.Actions.GetDescendants.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetDescendants.RequestV1) -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      return Services.Organization.Actions.GetDescendants.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasProfileId {
        output += "\(indent) profileId: \(profileId) \n"
      }
      if hasTeamId {
        output += "\(indent) teamId: \(teamId) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasProfileId {
               hashCode = (hashCode &* 31) &+ profileId.hashValue
            }
            if hasTeamId {
               hashCode = (hashCode &* 31) &+ teamId.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetDescendants.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetDescendants.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetDescendants.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetDescendants.RequestV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetDescendants.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetDescendants.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasProfileId:Bool {
         get {
              return builderResult.hasProfileId
         }
    }
    public var profileId:String {
         get {
              return builderResult.profileId
         }
         set (value) {
             builderResult.hasProfileId = true
             builderResult.profileId = value
         }
    }
    public func setProfileId(value:String)-> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      self.profileId = value
      return self
    }
    public func clearProfileId() -> Services.Organization.Actions.GetDescendants.RequestV1Builder{
         builderResult.hasProfileId = false
         builderResult.profileId = ""
         return self
    }
    public var hasTeamId:Bool {
         get {
              return builderResult.hasTeamId
         }
    }
    public var teamId:String {
         get {
              return builderResult.teamId
         }
         set (value) {
             builderResult.hasTeamId = true
             builderResult.teamId = value
         }
    }
    public func setTeamId(value:String)-> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      self.teamId = value
      return self
    }
    public func clearTeamId() -> Services.Organization.Actions.GetDescendants.RequestV1Builder{
         builderResult.hasTeamId = false
         builderResult.teamId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      builderResult = Services.Organization.Actions.GetDescendants.RequestV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      return Services.Organization.Actions.GetDescendants.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetDescendants.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetDescendants.RequestV1 {
      var returnMe:Services.Organization.Actions.GetDescendants.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetDescendants.RequestV1) -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
      if (other == Services.Organization.Actions.GetDescendants.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasProfileId {
           profileId = other.profileId
      }
      if other.hasTeamId {
           teamId = other.teamId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetDescendants.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetDescendants.RequestV1Builder {
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
          profileId = input.readString()

        case 26 :
          teamId = input.readString()

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

    public private(set) var profileIds:Array<String> = Array<String>()
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
      if !profileIds.isEmpty {
        for oneValueprofileIds in profileIds {
          output.writeString(3, value:oneValueprofileIds)
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
      var dataSizeProfileIds:Int32 = 0
      for oneValueprofileIds in profileIds {
          dataSizeProfileIds += oneValueprofileIds.computeStringSizeNoTag()
      }
      serialize_size += dataSizeProfileIds
      serialize_size += 1 * Int32(profileIds.count)
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetDescendants.ResponseV1 {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetDescendants.GetDescendantsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetDescendants.ResponseV1 {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetDescendants.ResponseV1 {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetDescendants.ResponseV1 {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetDescendants.ResponseV1 {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetDescendants.ResponseV1 {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      return Services.Organization.Actions.GetDescendants.ResponseV1.classBuilder() as! Services.Organization.Actions.GetDescendants.ResponseV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetDescendants.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetDescendants.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetDescendants.ResponseV1) -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var profileIdsElementIndex:Int = 0
      for oneValueprofileIds in profileIds  {
          output += "\(indent) profileIds[\(profileIdsElementIndex)]: \(oneValueprofileIds)\n"
          profileIdsElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneValueprofileIds in profileIds {
                hashCode = (hashCode &* 31) &+ oneValueprofileIds.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetDescendants.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetDescendants.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetDescendants.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetDescendants.ResponseV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetDescendants.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var profileIds:Array<String> {
         get {
             return builderResult.profileIds
         }
         set (array) {
             builderResult.profileIds = array
         }
    }
    public func setProfileIds(value:Array<String>)-> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      self.profileIds = value
      return self
    }
    public func clearProfileIds() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
       builderResult.profileIds.removeAll(keepCapacity: false)
       return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      builderResult = Services.Organization.Actions.GetDescendants.ResponseV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      return Services.Organization.Actions.GetDescendants.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetDescendants.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetDescendants.ResponseV1 {
      var returnMe:Services.Organization.Actions.GetDescendants.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetDescendants.ResponseV1) -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      if (other == Services.Organization.Actions.GetDescendants.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.profileIds.isEmpty {
          builderResult.profileIds += other.profileIds
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetDescendants.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetDescendants.ResponseV1Builder {
      var unknownFieldsBuilder:UnknownFieldSetBuilder = UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
      while (true) {
        var tag = input.readTag()
        switch tag {
        case 0: 
          self.unknownFields = unknownFieldsBuilder.build()
          return self

        case 8 :
          version = input.readUInt32()

        case 26 :
          profileIds += [input.readString()]

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