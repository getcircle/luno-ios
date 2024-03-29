// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file add_location_members.proto

import Foundation

public extension Services.Organization.Actions{ public struct AddLocationMembers { }}

public func == (lhs: Services.Organization.Actions.AddLocationMembers.RequestV1, rhs: Services.Organization.Actions.AddLocationMembers.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasLocationId == rhs.hasLocationId) && (!lhs.hasLocationId || lhs.locationId == rhs.locationId)
  fieldCheck = fieldCheck && (lhs.profileIds == rhs.profileIds)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Organization.Actions.AddLocationMembers.ResponseV1, rhs: Services.Organization.Actions.AddLocationMembers.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Organization.Actions.AddLocationMembers {
  public struct AddLocationMembersRoot {
    public static var sharedInstance : AddLocationMembersRoot {
     struct Static {
         static let instance : AddLocationMembersRoot = AddLocationMembersRoot()
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
    public private(set) var hasLocationId:Bool = false
    public private(set) var locationId:String = ""

    public private(set) var profileIds:Array<String> = Array<String>()
    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasLocationId {
        try output.writeString(1, value:locationId)
      }
      if !profileIds.isEmpty {
        for oneValueprofileIds in profileIds {
          try output.writeString(2, value:oneValueprofileIds)
        }
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasLocationId {
        serialize_size += locationId.computeStringSize(1)
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
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Organization.Actions.AddLocationMembers.RequestV1> {
      var mergedArray = Array<Services.Organization.Actions.AddLocationMembers.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1? {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.AddLocationMembers.AddLocationMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
      return Services.Organization.Actions.AddLocationMembers.RequestV1.classBuilder() as! Services.Organization.Actions.AddLocationMembers.RequestV1.Builder
    }
    public func getBuilder() -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
      return classBuilder() as! Services.Organization.Actions.AddLocationMembers.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.AddLocationMembers.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.AddLocationMembers.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.AddLocationMembers.RequestV1) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
      return try Services.Organization.Actions.AddLocationMembers.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasLocationId {
        output += "\(indent) locationId: \(locationId) \n"
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
            if hasLocationId {
               hashCode = (hashCode &* 31) &+ locationId.hashValue
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
        return "Services.Organization.Actions.AddLocationMembers.RequestV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.AddLocationMembers.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.AddLocationMembers.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Organization.Actions.AddLocationMembers.RequestV1 = Services.Organization.Actions.AddLocationMembers.RequestV1()
      public func getMessage() -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
          return builderResult
      }

      required override public init () {
         super.init()
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
      public func setLocationId(value:String) -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
        self.locationId = value
        return self
      }
      public func clearLocationId() -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder{
           builderResult.hasLocationId = false
           builderResult.locationId = ""
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
      public func setProfileIds(value:Array<String>) -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
        self.profileIds = value
        return self
      }
      public func clearProfileIds() -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
         builderResult.profileIds.removeAll(keepCapacity: false)
         return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
        builderResult = Services.Organization.Actions.AddLocationMembers.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
        return try Services.Organization.Actions.AddLocationMembers.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Organization.Actions.AddLocationMembers.RequestV1 {
        let returnMe:Services.Organization.Actions.AddLocationMembers.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Organization.Actions.AddLocationMembers.RequestV1) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
        if other == Services.Organization.Actions.AddLocationMembers.RequestV1() {
         return self
        }
        if other.hasLocationId {
             locationId = other.locationId
        }
        if !other.profileIds.isEmpty {
            builderResult.profileIds += other.profileIds
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.RequestV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            locationId = try input.readString()

          case 18 :
            profileIds += [try input.readString()]

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
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Organization.Actions.AddLocationMembers.ResponseV1> {
      var mergedArray = Array<Services.Organization.Actions.AddLocationMembers.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1? {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Organization.Actions.AddLocationMembers.AddLocationMembersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
      return Services.Organization.Actions.AddLocationMembers.ResponseV1.classBuilder() as! Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
      return classBuilder() as! Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Organization.Actions.AddLocationMembers.ResponseV1) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
      return try Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder().mergeFrom(prototype)
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
        return "Services.Organization.Actions.AddLocationMembers.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Organization.Actions.AddLocationMembers.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Organization.Actions.AddLocationMembers.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Organization.Actions.AddLocationMembers.ResponseV1 = Services.Organization.Actions.AddLocationMembers.ResponseV1()
      public func getMessage() -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
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
      public override func clear() -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
        builderResult = Services.Organization.Actions.AddLocationMembers.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
        return try Services.Organization.Actions.AddLocationMembers.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Organization.Actions.AddLocationMembers.ResponseV1 {
        let returnMe:Services.Organization.Actions.AddLocationMembers.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Organization.Actions.AddLocationMembers.ResponseV1) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
        if other == Services.Organization.Actions.AddLocationMembers.ResponseV1() {
         return self
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Organization.Actions.AddLocationMembers.ResponseV1.Builder {
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
