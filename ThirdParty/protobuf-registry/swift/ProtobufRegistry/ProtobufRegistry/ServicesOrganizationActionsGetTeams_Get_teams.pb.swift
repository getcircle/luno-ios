// Generated by the protocol buffer compiler.  DO NOT EDIT!

import Foundation
public extension Services.Organization.Actions{ public struct GetTeams { }}

public func == (lhs: Services.Organization.Actions.GetTeams.RequestV1, rhs: Services.Organization.Actions.GetTeams.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasOrganizationId == rhs.hasOrganizationId) && (!lhs.hasOrganizationId || lhs.organizationId == rhs.organizationId)
  fieldCheck = fieldCheck && (lhs.hasLocationId == rhs.hasLocationId) && (!lhs.hasLocationId || lhs.locationId == rhs.locationId)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public func == (lhs: Services.Organization.Actions.GetTeams.ResponseV1, rhs: Services.Organization.Actions.GetTeams.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.teams == rhs.teams)
  return (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
}

public extension Services.Organization.Actions.GetTeams {
  public struct GetTeamsRoot {
    public static var sharedInstance : GetTeamsRoot {
     struct Static {
         static let instance : GetTeamsRoot = GetTeamsRoot()
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
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           case "organizationId": return organizationId
           case "locationId": return locationId
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasOrganizationId:Bool = false
    public private(set) var organizationId:String = ""

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
      if hasOrganizationId {
        output.writeString(2, value:organizationId)
      }
      if hasLocationId {
        output.writeString(3, value:locationId)
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
      if hasOrganizationId {
        serialize_size += organizationId.computeStringSize(2)
      }
      if hasLocationId {
        serialize_size += locationId.computeStringSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetTeams.RequestV1 {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetTeams.GetTeamsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTeams.RequestV1 {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetTeams.RequestV1 {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetTeams.RequestV1 {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetTeams.RequestV1 {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTeams.RequestV1 {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      return Services.Organization.Actions.GetTeams.RequestV1.classBuilder() as! Services.Organization.Actions.GetTeams.RequestV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetTeams.RequestV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTeams.RequestV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTeams.RequestV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      return Services.Organization.Actions.GetTeams.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetTeams.RequestV1) -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      return Services.Organization.Actions.GetTeams.RequestV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasOrganizationId {
        output += "\(indent) organizationId: \(organizationId) \n"
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
            if hasOrganizationId {
               hashCode = (hashCode &* 31) &+ organizationId.hashValue
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
        return "Services.Organization.Actions.GetTeams.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetTeams.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetTeams.RequestV1.self
    }
    //Meta information declaration end

  }

  final public class RequestV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetTeams.RequestV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetTeams.RequestV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetTeams.RequestV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetTeams.RequestV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var hasOrganizationId:Bool {
         get {
              return builderResult.hasOrganizationId
         }
    }
    public var organizationId:String {
         get {
              return builderResult.organizationId
         }
         set (value) {
             builderResult.hasOrganizationId = true
             builderResult.organizationId = value
         }
    }
    public func setOrganizationId(value:String)-> Services.Organization.Actions.GetTeams.RequestV1Builder {
      self.organizationId = value
      return self
    }
    public func clearOrganizationId() -> Services.Organization.Actions.GetTeams.RequestV1Builder{
         builderResult.hasOrganizationId = false
         builderResult.organizationId = ""
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
    public func setLocationId(value:String)-> Services.Organization.Actions.GetTeams.RequestV1Builder {
      self.locationId = value
      return self
    }
    public func clearLocationId() -> Services.Organization.Actions.GetTeams.RequestV1Builder{
         builderResult.hasLocationId = false
         builderResult.locationId = ""
         return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      builderResult = Services.Organization.Actions.GetTeams.RequestV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      return Services.Organization.Actions.GetTeams.RequestV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetTeams.RequestV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetTeams.RequestV1 {
      var returnMe:Services.Organization.Actions.GetTeams.RequestV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetTeams.RequestV1) -> Services.Organization.Actions.GetTeams.RequestV1Builder {
      if (other == Services.Organization.Actions.GetTeams.RequestV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if other.hasOrganizationId {
           organizationId = other.organizationId
      }
      if other.hasLocationId {
           locationId = other.locationId
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetTeams.RequestV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTeams.RequestV1Builder {
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
          organizationId = input.readString()

        case 26 :
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
    public subscript(key: String) -> Any? {
           switch key {
           case "version": return version
           default: return nil
           }
    }

    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var teams:Array<Services.Organization.Containers.TeamV1>  = Array<Services.Organization.Containers.TeamV1>()
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
      for oneElementteams in teams {
          output.writeMessage(2, value:oneElementteams)
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
      for oneElementteams in teams {
          serialize_size += oneElementteams.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseFromData(data:NSData) -> Services.Organization.Actions.GetTeams.ResponseV1 {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.GetTeams.GetTeamsRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTeams.ResponseV1 {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) -> Services.Organization.Actions.GetTeams.ResponseV1 {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) ->Services.Organization.Actions.GetTeams.ResponseV1 {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) -> Services.Organization.Actions.GetTeams.ResponseV1 {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTeams.ResponseV1 {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func builder() -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      return Services.Organization.Actions.GetTeams.ResponseV1.classBuilder() as! Services.Organization.Actions.GetTeams.ResponseV1Builder
    }
    public func builder() -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      return classBuilder() as! Services.Organization.Actions.GetTeams.ResponseV1Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTeams.ResponseV1Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder()
    }
    public func toBuilder() -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      return Services.Organization.Actions.GetTeams.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.GetTeams.ResponseV1) -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      return Services.Organization.Actions.GetTeams.ResponseV1.builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var teamsElementIndex:Int = 0
      for oneElementteams in teams {
          output += "\(indent) teams[\(teamsElementIndex)] {\n"
          oneElementteams.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          teamsElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementteams in teams {
                hashCode = (hashCode &* 31) &+ oneElementteams.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Organization.Actions.GetTeams.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.GetTeams.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.GetTeams.ResponseV1.self
    }
    //Meta information declaration end

  }

  final public class ResponseV1Builder : GeneratedMessageBuilder {
    private var builderResult:Services.Organization.Actions.GetTeams.ResponseV1

    required override public init () {
       builderResult = Services.Organization.Actions.GetTeams.ResponseV1()
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
    public func setVersion(value:UInt32)-> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      self.version = value
      return self
    }
    public func clearVersion() -> Services.Organization.Actions.GetTeams.ResponseV1Builder{
         builderResult.hasVersion = false
         builderResult.version = UInt32(1)
         return self
    }
    public var teams:Array<Services.Organization.Containers.TeamV1> {
         get {
             return builderResult.teams
         }
         set (value) {
             builderResult.teams = value
         }
    }
    public func setTeams(value:Array<Services.Organization.Containers.TeamV1>)-> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      self.teams = value
      return self
    }
    public func clearTeams() -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      builderResult.teams.removeAll(keepCapacity: false)
      return self
    }
    override public var internalGetResult:GeneratedMessage {
         get {
            return builderResult
         }
    }
    public override func clear() -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      builderResult = Services.Organization.Actions.GetTeams.ResponseV1()
      return self
    }
    public override func clone() -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      return Services.Organization.Actions.GetTeams.ResponseV1.builderWithPrototype(builderResult)
    }
    public override func build() -> Services.Organization.Actions.GetTeams.ResponseV1 {
         checkInitialized()
         return buildPartial()
    }
    public func buildPartial() -> Services.Organization.Actions.GetTeams.ResponseV1 {
      var returnMe:Services.Organization.Actions.GetTeams.ResponseV1 = builderResult
      return returnMe
    }
    public func mergeFrom(other:Services.Organization.Actions.GetTeams.ResponseV1) -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
      if (other == Services.Organization.Actions.GetTeams.ResponseV1()) {
       return self
      }
      if other.hasVersion {
           version = other.version
      }
      if !other.teams.isEmpty  {
         builderResult.teams += other.teams
      }
      mergeUnknownFields(other.unknownFields)
      return self
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream) ->Services.Organization.Actions.GetTeams.ResponseV1Builder {
         return mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
    }
    public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) -> Services.Organization.Actions.GetTeams.ResponseV1Builder {
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
          var subBuilder = Services.Organization.Containers.TeamV1.builder()
          input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
          teams += [subBuilder.buildPartial()]

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
