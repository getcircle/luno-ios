// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file containers.proto

import Foundation

public extension Services.File{ public struct Containers { }}

public func == (lhs: Services.File.Containers.UploadInstructionsV1, rhs: Services.File.Containers.UploadInstructionsV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasUploadId == rhs.hasUploadId) && (!lhs.hasUploadId || lhs.uploadId == rhs.uploadId)
  fieldCheck = fieldCheck && (lhs.hasUploadUrl == rhs.hasUploadUrl) && (!lhs.hasUploadUrl || lhs.uploadUrl == rhs.uploadUrl)
  fieldCheck = fieldCheck && (lhs.hasUploadKey == rhs.hasUploadKey) && (!lhs.hasUploadKey || lhs.uploadKey == rhs.uploadKey)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.File.Containers.FileV1, rhs: Services.File.Containers.FileV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasId == rhs.hasId) && (!lhs.hasId || lhs.id == rhs.id)
  fieldCheck = fieldCheck && (lhs.hasByProfileId == rhs.hasByProfileId) && (!lhs.hasByProfileId || lhs.byProfileId == rhs.byProfileId)
  fieldCheck = fieldCheck && (lhs.hasOrganizationId == rhs.hasOrganizationId) && (!lhs.hasOrganizationId || lhs.organizationId == rhs.organizationId)
  fieldCheck = fieldCheck && (lhs.hasSourceUrl == rhs.hasSourceUrl) && (!lhs.hasSourceUrl || lhs.sourceUrl == rhs.sourceUrl)
  fieldCheck = fieldCheck && (lhs.hasContentType == rhs.hasContentType) && (!lhs.hasContentType || lhs.contentType == rhs.contentType)
  fieldCheck = fieldCheck && (lhs.hasCreated == rhs.hasCreated) && (!lhs.hasCreated || lhs.created == rhs.created)
  fieldCheck = fieldCheck && (lhs.hasName == rhs.hasName) && (!lhs.hasName || lhs.name == rhs.name)
  fieldCheck = fieldCheck && (lhs.hasBytes == rhs.hasBytes) && (!lhs.hasBytes || lhs.bytes == rhs.bytes)
  fieldCheck = fieldCheck && (lhs.hasSize == rhs.hasSize) && (!lhs.hasSize || lhs.size == rhs.size)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.File.Containers {
  public struct ContainersRoot {
    public static var sharedInstance : ContainersRoot {
     struct Static {
         static let instance : ContainersRoot = ContainersRoot()
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

  final public class UploadInstructionsV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasUploadId:Bool = false
    public private(set) var uploadId:String = ""

    public private(set) var hasUploadUrl:Bool = false
    public private(set) var uploadUrl:String = ""

    public private(set) var hasUploadKey:Bool = false
    public private(set) var uploadKey:String = ""

    required public init() {
         super.init()
    }
    override public func isInitialized() -> Bool {
     return true
    }
    override public func writeToCodedOutputStream(output:CodedOutputStream) throws {
      if hasUploadId {
        try output.writeString(1, value:uploadId)
      }
      if hasUploadUrl {
        try output.writeString(2, value:uploadUrl)
      }
      if hasUploadKey {
        try output.writeString(3, value:uploadKey)
      }
      try unknownFields.writeToCodedOutputStream(output)
    }
    override public func serializedSize() -> Int32 {
      var serialize_size:Int32 = memoizedSerializedSize
      if serialize_size != -1 {
       return serialize_size
      }

      serialize_size = 0
      if hasUploadId {
        serialize_size += uploadId.computeStringSize(1)
      }
      if hasUploadUrl {
        serialize_size += uploadUrl.computeStringSize(2)
      }
      if hasUploadKey {
        serialize_size += uploadKey.computeStringSize(3)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.File.Containers.UploadInstructionsV1> {
      var mergedArray = Array<Services.File.Containers.UploadInstructionsV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.File.Containers.UploadInstructionsV1? {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.File.Containers.UploadInstructionsV1 {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFromData(data, extensionRegistry:Services.File.Containers.ContainersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.UploadInstructionsV1 {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.File.Containers.UploadInstructionsV1 {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.UploadInstructionsV1 {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.File.Containers.UploadInstructionsV1 {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.UploadInstructionsV1 {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.File.Containers.UploadInstructionsV1.Builder {
      return Services.File.Containers.UploadInstructionsV1.classBuilder() as! Services.File.Containers.UploadInstructionsV1.Builder
    }
    public func getBuilder() -> Services.File.Containers.UploadInstructionsV1.Builder {
      return classBuilder() as! Services.File.Containers.UploadInstructionsV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.File.Containers.UploadInstructionsV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.File.Containers.UploadInstructionsV1.Builder()
    }
    public func toBuilder() throws -> Services.File.Containers.UploadInstructionsV1.Builder {
      return try Services.File.Containers.UploadInstructionsV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.File.Containers.UploadInstructionsV1) throws -> Services.File.Containers.UploadInstructionsV1.Builder {
      return try Services.File.Containers.UploadInstructionsV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasUploadId {
        output += "\(indent) uploadId: \(uploadId) \n"
      }
      if hasUploadUrl {
        output += "\(indent) uploadUrl: \(uploadUrl) \n"
      }
      if hasUploadKey {
        output += "\(indent) uploadKey: \(uploadKey) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasUploadId {
               hashCode = (hashCode &* 31) &+ uploadId.hashValue
            }
            if hasUploadUrl {
               hashCode = (hashCode &* 31) &+ uploadUrl.hashValue
            }
            if hasUploadKey {
               hashCode = (hashCode &* 31) &+ uploadKey.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.File.Containers.UploadInstructionsV1"
    }
    override public func className() -> String {
        return "Services.File.Containers.UploadInstructionsV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.File.Containers.UploadInstructionsV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.File.Containers.UploadInstructionsV1 = Services.File.Containers.UploadInstructionsV1()
      public func getMessage() -> Services.File.Containers.UploadInstructionsV1 {
          return builderResult
      }

      required override public init () {
         super.init()
      }
      public var hasUploadId:Bool {
           get {
                return builderResult.hasUploadId
           }
      }
      public var uploadId:String {
           get {
                return builderResult.uploadId
           }
           set (value) {
               builderResult.hasUploadId = true
               builderResult.uploadId = value
           }
      }
      public func setUploadId(value:String) -> Services.File.Containers.UploadInstructionsV1.Builder {
        self.uploadId = value
        return self
      }
      public func clearUploadId() -> Services.File.Containers.UploadInstructionsV1.Builder{
           builderResult.hasUploadId = false
           builderResult.uploadId = ""
           return self
      }
      public var hasUploadUrl:Bool {
           get {
                return builderResult.hasUploadUrl
           }
      }
      public var uploadUrl:String {
           get {
                return builderResult.uploadUrl
           }
           set (value) {
               builderResult.hasUploadUrl = true
               builderResult.uploadUrl = value
           }
      }
      public func setUploadUrl(value:String) -> Services.File.Containers.UploadInstructionsV1.Builder {
        self.uploadUrl = value
        return self
      }
      public func clearUploadUrl() -> Services.File.Containers.UploadInstructionsV1.Builder{
           builderResult.hasUploadUrl = false
           builderResult.uploadUrl = ""
           return self
      }
      public var hasUploadKey:Bool {
           get {
                return builderResult.hasUploadKey
           }
      }
      public var uploadKey:String {
           get {
                return builderResult.uploadKey
           }
           set (value) {
               builderResult.hasUploadKey = true
               builderResult.uploadKey = value
           }
      }
      public func setUploadKey(value:String) -> Services.File.Containers.UploadInstructionsV1.Builder {
        self.uploadKey = value
        return self
      }
      public func clearUploadKey() -> Services.File.Containers.UploadInstructionsV1.Builder{
           builderResult.hasUploadKey = false
           builderResult.uploadKey = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.File.Containers.UploadInstructionsV1.Builder {
        builderResult = Services.File.Containers.UploadInstructionsV1()
        return self
      }
      public override func clone() throws -> Services.File.Containers.UploadInstructionsV1.Builder {
        return try Services.File.Containers.UploadInstructionsV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.File.Containers.UploadInstructionsV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.File.Containers.UploadInstructionsV1 {
        let returnMe:Services.File.Containers.UploadInstructionsV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.File.Containers.UploadInstructionsV1) throws -> Services.File.Containers.UploadInstructionsV1.Builder {
        if other == Services.File.Containers.UploadInstructionsV1() {
         return self
        }
        if other.hasUploadId {
             uploadId = other.uploadId
        }
        if other.hasUploadUrl {
             uploadUrl = other.uploadUrl
        }
        if other.hasUploadKey {
             uploadKey = other.uploadKey
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.File.Containers.UploadInstructionsV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.UploadInstructionsV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            uploadId = try input.readString()

          case 18 :
            uploadUrl = try input.readString()

          case 26 :
            uploadKey = try input.readString()

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

  final public class FileV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasId:Bool = false
    public private(set) var id:String = ""

    public private(set) var hasByProfileId:Bool = false
    public private(set) var byProfileId:String = ""

    public private(set) var hasOrganizationId:Bool = false
    public private(set) var organizationId:String = ""

    public private(set) var hasSourceUrl:Bool = false
    public private(set) var sourceUrl:String = ""

    public private(set) var hasContentType:Bool = false
    public private(set) var contentType:String = ""

    public private(set) var hasCreated:Bool = false
    public private(set) var created:String = ""

    public private(set) var hasName:Bool = false
    public private(set) var name:String = ""

    public private(set) var hasBytes:Bool = false
    public private(set) var bytes:NSData = NSData()

    public private(set) var hasSize:Bool = false
    public private(set) var size:UInt32 = UInt32(0)

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
      if hasByProfileId {
        try output.writeString(2, value:byProfileId)
      }
      if hasOrganizationId {
        try output.writeString(3, value:organizationId)
      }
      if hasSourceUrl {
        try output.writeString(4, value:sourceUrl)
      }
      if hasContentType {
        try output.writeString(5, value:contentType)
      }
      if hasCreated {
        try output.writeString(6, value:created)
      }
      if hasName {
        try output.writeString(7, value:name)
      }
      if hasBytes {
        try output.writeData(8, value:bytes)
      }
      if hasSize {
        try output.writeUInt32(9, value:size)
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
      if hasByProfileId {
        serialize_size += byProfileId.computeStringSize(2)
      }
      if hasOrganizationId {
        serialize_size += organizationId.computeStringSize(3)
      }
      if hasSourceUrl {
        serialize_size += sourceUrl.computeStringSize(4)
      }
      if hasContentType {
        serialize_size += contentType.computeStringSize(5)
      }
      if hasCreated {
        serialize_size += created.computeStringSize(6)
      }
      if hasName {
        serialize_size += name.computeStringSize(7)
      }
      if hasBytes {
        serialize_size += bytes.computeDataSize(8)
      }
      if hasSize {
        serialize_size += size.computeUInt32Size(9)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.File.Containers.FileV1> {
      var mergedArray = Array<Services.File.Containers.FileV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.File.Containers.FileV1? {
      return try Services.File.Containers.FileV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.File.Containers.FileV1 {
      return try Services.File.Containers.FileV1.Builder().mergeFromData(data, extensionRegistry:Services.File.Containers.ContainersRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.FileV1 {
      return try Services.File.Containers.FileV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.File.Containers.FileV1 {
      return try Services.File.Containers.FileV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.FileV1 {
      return try Services.File.Containers.FileV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.File.Containers.FileV1 {
      return try Services.File.Containers.FileV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.FileV1 {
      return try Services.File.Containers.FileV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.File.Containers.FileV1.Builder {
      return Services.File.Containers.FileV1.classBuilder() as! Services.File.Containers.FileV1.Builder
    }
    public func getBuilder() -> Services.File.Containers.FileV1.Builder {
      return classBuilder() as! Services.File.Containers.FileV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.File.Containers.FileV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.File.Containers.FileV1.Builder()
    }
    public func toBuilder() throws -> Services.File.Containers.FileV1.Builder {
      return try Services.File.Containers.FileV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.File.Containers.FileV1) throws -> Services.File.Containers.FileV1.Builder {
      return try Services.File.Containers.FileV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasId {
        output += "\(indent) id: \(id) \n"
      }
      if hasByProfileId {
        output += "\(indent) byProfileId: \(byProfileId) \n"
      }
      if hasOrganizationId {
        output += "\(indent) organizationId: \(organizationId) \n"
      }
      if hasSourceUrl {
        output += "\(indent) sourceUrl: \(sourceUrl) \n"
      }
      if hasContentType {
        output += "\(indent) contentType: \(contentType) \n"
      }
      if hasCreated {
        output += "\(indent) created: \(created) \n"
      }
      if hasName {
        output += "\(indent) name: \(name) \n"
      }
      if hasBytes {
        output += "\(indent) bytes: \(bytes) \n"
      }
      if hasSize {
        output += "\(indent) size: \(size) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasId {
               hashCode = (hashCode &* 31) &+ id.hashValue
            }
            if hasByProfileId {
               hashCode = (hashCode &* 31) &+ byProfileId.hashValue
            }
            if hasOrganizationId {
               hashCode = (hashCode &* 31) &+ organizationId.hashValue
            }
            if hasSourceUrl {
               hashCode = (hashCode &* 31) &+ sourceUrl.hashValue
            }
            if hasContentType {
               hashCode = (hashCode &* 31) &+ contentType.hashValue
            }
            if hasCreated {
               hashCode = (hashCode &* 31) &+ created.hashValue
            }
            if hasName {
               hashCode = (hashCode &* 31) &+ name.hashValue
            }
            if hasBytes {
               hashCode = (hashCode &* 31) &+ bytes.hashValue
            }
            if hasSize {
               hashCode = (hashCode &* 31) &+ size.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.File.Containers.FileV1"
    }
    override public func className() -> String {
        return "Services.File.Containers.FileV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.File.Containers.FileV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.File.Containers.FileV1 = Services.File.Containers.FileV1()
      public func getMessage() -> Services.File.Containers.FileV1 {
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
      public func setId(value:String) -> Services.File.Containers.FileV1.Builder {
        self.id = value
        return self
      }
      public func clearId() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasId = false
           builderResult.id = ""
           return self
      }
      public var hasByProfileId:Bool {
           get {
                return builderResult.hasByProfileId
           }
      }
      public var byProfileId:String {
           get {
                return builderResult.byProfileId
           }
           set (value) {
               builderResult.hasByProfileId = true
               builderResult.byProfileId = value
           }
      }
      public func setByProfileId(value:String) -> Services.File.Containers.FileV1.Builder {
        self.byProfileId = value
        return self
      }
      public func clearByProfileId() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasByProfileId = false
           builderResult.byProfileId = ""
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
      public func setOrganizationId(value:String) -> Services.File.Containers.FileV1.Builder {
        self.organizationId = value
        return self
      }
      public func clearOrganizationId() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasOrganizationId = false
           builderResult.organizationId = ""
           return self
      }
      public var hasSourceUrl:Bool {
           get {
                return builderResult.hasSourceUrl
           }
      }
      public var sourceUrl:String {
           get {
                return builderResult.sourceUrl
           }
           set (value) {
               builderResult.hasSourceUrl = true
               builderResult.sourceUrl = value
           }
      }
      public func setSourceUrl(value:String) -> Services.File.Containers.FileV1.Builder {
        self.sourceUrl = value
        return self
      }
      public func clearSourceUrl() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasSourceUrl = false
           builderResult.sourceUrl = ""
           return self
      }
      public var hasContentType:Bool {
           get {
                return builderResult.hasContentType
           }
      }
      public var contentType:String {
           get {
                return builderResult.contentType
           }
           set (value) {
               builderResult.hasContentType = true
               builderResult.contentType = value
           }
      }
      public func setContentType(value:String) -> Services.File.Containers.FileV1.Builder {
        self.contentType = value
        return self
      }
      public func clearContentType() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasContentType = false
           builderResult.contentType = ""
           return self
      }
      public var hasCreated:Bool {
           get {
                return builderResult.hasCreated
           }
      }
      public var created:String {
           get {
                return builderResult.created
           }
           set (value) {
               builderResult.hasCreated = true
               builderResult.created = value
           }
      }
      public func setCreated(value:String) -> Services.File.Containers.FileV1.Builder {
        self.created = value
        return self
      }
      public func clearCreated() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasCreated = false
           builderResult.created = ""
           return self
      }
      public var hasName:Bool {
           get {
                return builderResult.hasName
           }
      }
      public var name:String {
           get {
                return builderResult.name
           }
           set (value) {
               builderResult.hasName = true
               builderResult.name = value
           }
      }
      public func setName(value:String) -> Services.File.Containers.FileV1.Builder {
        self.name = value
        return self
      }
      public func clearName() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasName = false
           builderResult.name = ""
           return self
      }
      public var hasBytes:Bool {
           get {
                return builderResult.hasBytes
           }
      }
      public var bytes:NSData {
           get {
                return builderResult.bytes
           }
           set (value) {
               builderResult.hasBytes = true
               builderResult.bytes = value
           }
      }
      public func setBytes(value:NSData) -> Services.File.Containers.FileV1.Builder {
        self.bytes = value
        return self
      }
      public func clearBytes() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasBytes = false
           builderResult.bytes = NSData()
           return self
      }
      public var hasSize:Bool {
           get {
                return builderResult.hasSize
           }
      }
      public var size:UInt32 {
           get {
                return builderResult.size
           }
           set (value) {
               builderResult.hasSize = true
               builderResult.size = value
           }
      }
      public func setSize(value:UInt32) -> Services.File.Containers.FileV1.Builder {
        self.size = value
        return self
      }
      public func clearSize() -> Services.File.Containers.FileV1.Builder{
           builderResult.hasSize = false
           builderResult.size = UInt32(0)
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.File.Containers.FileV1.Builder {
        builderResult = Services.File.Containers.FileV1()
        return self
      }
      public override func clone() throws -> Services.File.Containers.FileV1.Builder {
        return try Services.File.Containers.FileV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.File.Containers.FileV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.File.Containers.FileV1 {
        let returnMe:Services.File.Containers.FileV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.File.Containers.FileV1) throws -> Services.File.Containers.FileV1.Builder {
        if other == Services.File.Containers.FileV1() {
         return self
        }
        if other.hasId {
             id = other.id
        }
        if other.hasByProfileId {
             byProfileId = other.byProfileId
        }
        if other.hasOrganizationId {
             organizationId = other.organizationId
        }
        if other.hasSourceUrl {
             sourceUrl = other.sourceUrl
        }
        if other.hasContentType {
             contentType = other.contentType
        }
        if other.hasCreated {
             created = other.created
        }
        if other.hasName {
             name = other.name
        }
        if other.hasBytes {
             bytes = other.bytes
        }
        if other.hasSize {
             size = other.size
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.File.Containers.FileV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.File.Containers.FileV1.Builder {
        let unknownFieldsBuilder:UnknownFieldSet.Builder = try UnknownFieldSet.builderWithUnknownFields(self.unknownFields)
        while (true) {
          let tag = try input.readTag()
          switch tag {
          case 0: 
            self.unknownFields = try unknownFieldsBuilder.build()
            return self

          case 10 :
            id = try input.readString()

          case 18 :
            byProfileId = try input.readString()

          case 26 :
            organizationId = try input.readString()

          case 34 :
            sourceUrl = try input.readString()

          case 42 :
            contentType = try input.readString()

          case 50 :
            created = try input.readString()

          case 58 :
            name = try input.readString()

          case 66 :
            bytes = try input.readData()

          case 72 :
            size = try input.readUInt32()

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
