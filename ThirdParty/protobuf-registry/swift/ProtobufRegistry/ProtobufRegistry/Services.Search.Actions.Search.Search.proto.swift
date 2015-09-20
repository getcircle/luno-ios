// Generated by the protocol buffer compiler.  DO NOT EDIT!
// Source file search.proto

import Foundation
import ProtocolBuffers


public extension Services{ public struct Search { public struct Actions { public struct Search { }}}}

public func == (lhs: Services.Search.Actions.Search.RequestV1, rhs: Services.Search.Actions.Search.RequestV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.hasQuery == rhs.hasQuery) && (!lhs.hasQuery || lhs.query == rhs.query)
  fieldCheck = fieldCheck && (lhs.hasCategory == rhs.hasCategory) && (!lhs.hasCategory || lhs.category == rhs.category)
  fieldCheck = fieldCheck && (lhs.hasAttribute == rhs.hasAttribute) && (!lhs.hasAttribute || lhs.attribute == rhs.attribute)
  fieldCheck = fieldCheck && (lhs.hasAttributeValue == rhs.hasAttributeValue) && (!lhs.hasAttributeValue || lhs.attributeValue == rhs.attributeValue)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public func == (lhs: Services.Search.Actions.Search.ResponseV1, rhs: Services.Search.Actions.Search.ResponseV1) -> Bool {
  if (lhs === rhs) {
    return true
  }
  var fieldCheck:Bool = (lhs.hashValue == rhs.hashValue)
  fieldCheck = fieldCheck && (lhs.hasVersion == rhs.hasVersion) && (!lhs.hasVersion || lhs.version == rhs.version)
  fieldCheck = fieldCheck && (lhs.results == rhs.results)
  fieldCheck = (fieldCheck && (lhs.unknownFields == rhs.unknownFields))
  return fieldCheck
}

public extension Services.Search.Actions.Search {
  public struct SearchRoot {
    public static var sharedInstance : SearchRoot {
     struct Static {
         static let instance : SearchRoot = SearchRoot()
     }
     return Static.instance
    }
    public var extensionRegistry:ExtensionRegistry

    init() {
      extensionRegistry = ExtensionRegistry()
      registerAllExtensions(extensionRegistry)
      Services.Search.Containers.ContainersRoot.sharedInstance.registerAllExtensions(extensionRegistry)
      Services.Search.Containers.Search.SearchRoot.sharedInstance.registerAllExtensions(extensionRegistry)
    }
    public func registerAllExtensions(registry:ExtensionRegistry) {
    }
  }

  final public class RequestV1 : GeneratedMessage, GeneratedMessageProtocol {
    public private(set) var hasVersion:Bool = false
    public private(set) var version:UInt32 = UInt32(1)

    public private(set) var hasQuery:Bool = false
    public private(set) var query:String = ""

    public private(set) var category:Services.Search.Containers.Search.CategoryV1 = Services.Search.Containers.Search.CategoryV1.Profiles
    public private(set) var hasCategory:Bool = false
    public private(set) var attribute:Services.Search.Containers.Search.AttributeV1 = Services.Search.Containers.Search.AttributeV1.LocationId
    public private(set) var hasAttribute:Bool = false
    public private(set) var hasAttributeValue:Bool = false
    public private(set) var attributeValue:String = ""

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
      if hasQuery {
        try output.writeString(2, value:query)
      }
      if hasCategory {
        try output.writeEnum(3, value:category.rawValue)
      }
      if hasAttribute {
        try output.writeEnum(4, value:attribute.rawValue)
      }
      if hasAttributeValue {
        try output.writeString(5, value:attributeValue)
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
      if hasQuery {
        serialize_size += query.computeStringSize(2)
      }
      if (hasCategory) {
        serialize_size += category.rawValue.computeEnumSize(3)
      }
      if (hasAttribute) {
        serialize_size += attribute.rawValue.computeEnumSize(4)
      }
      if hasAttributeValue {
        serialize_size += attributeValue.computeStringSize(5)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Search.Actions.Search.RequestV1> {
      var mergedArray = Array<Services.Search.Actions.Search.RequestV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Search.Actions.Search.RequestV1? {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Search.Actions.Search.RequestV1 {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFromData(data, extensionRegistry:Services.Search.Actions.Search.SearchRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.RequestV1 {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Search.Actions.Search.RequestV1 {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.RequestV1 {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Search.Actions.Search.RequestV1 {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.RequestV1 {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Search.Actions.Search.RequestV1.Builder {
      return Services.Search.Actions.Search.RequestV1.classBuilder() as! Services.Search.Actions.Search.RequestV1.Builder
    }
    public func getBuilder() -> Services.Search.Actions.Search.RequestV1.Builder {
      return classBuilder() as! Services.Search.Actions.Search.RequestV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Search.Actions.Search.RequestV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Search.Actions.Search.RequestV1.Builder()
    }
    public func toBuilder() throws -> Services.Search.Actions.Search.RequestV1.Builder {
      return try Services.Search.Actions.Search.RequestV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Search.Actions.Search.RequestV1) throws -> Services.Search.Actions.Search.RequestV1.Builder {
      return try Services.Search.Actions.Search.RequestV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      if hasQuery {
        output += "\(indent) query: \(query) \n"
      }
      if (hasCategory) {
        output += "\(indent) category: \(category.rawValue)\n"
      }
      if (hasAttribute) {
        output += "\(indent) attribute: \(attribute.rawValue)\n"
      }
      if hasAttributeValue {
        output += "\(indent) attributeValue: \(attributeValue) \n"
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            if hasQuery {
               hashCode = (hashCode &* 31) &+ query.hashValue
            }
            if hasCategory {
               hashCode = (hashCode &* 31) &+ Int(category.rawValue)
            }
            if hasAttribute {
               hashCode = (hashCode &* 31) &+ Int(attribute.rawValue)
            }
            if hasAttributeValue {
               hashCode = (hashCode &* 31) &+ attributeValue.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Search.Actions.Search.RequestV1"
    }
    override public func className() -> String {
        return "Services.Search.Actions.Search.RequestV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Search.Actions.Search.RequestV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Search.Actions.Search.RequestV1 = Services.Search.Actions.Search.RequestV1()
      public func getMessage() -> Services.Search.Actions.Search.RequestV1 {
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
      public func setVersion(value:UInt32) -> Services.Search.Actions.Search.RequestV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Search.Actions.Search.RequestV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var hasQuery:Bool {
           get {
                return builderResult.hasQuery
           }
      }
      public var query:String {
           get {
                return builderResult.query
           }
           set (value) {
               builderResult.hasQuery = true
               builderResult.query = value
           }
      }
      public func setQuery(value:String) -> Services.Search.Actions.Search.RequestV1.Builder {
        self.query = value
        return self
      }
      public func clearQuery() -> Services.Search.Actions.Search.RequestV1.Builder{
           builderResult.hasQuery = false
           builderResult.query = ""
           return self
      }
        public var hasCategory:Bool{
            get {
                return builderResult.hasCategory
            }
        }
        public var category:Services.Search.Containers.Search.CategoryV1 {
            get {
                return builderResult.category
            }
            set (value) {
                builderResult.hasCategory = true
                builderResult.category = value
            }
        }
        public func setCategory(value:Services.Search.Containers.Search.CategoryV1) -> Services.Search.Actions.Search.RequestV1.Builder {
          self.category = value
          return self
        }
        public func clearCategory() -> Services.Search.Actions.Search.RequestV1.Builder {
           builderResult.hasCategory = false
           builderResult.category = .Profiles
           return self
        }
        public var hasAttribute:Bool{
            get {
                return builderResult.hasAttribute
            }
        }
        public var attribute:Services.Search.Containers.Search.AttributeV1 {
            get {
                return builderResult.attribute
            }
            set (value) {
                builderResult.hasAttribute = true
                builderResult.attribute = value
            }
        }
        public func setAttribute(value:Services.Search.Containers.Search.AttributeV1) -> Services.Search.Actions.Search.RequestV1.Builder {
          self.attribute = value
          return self
        }
        public func clearAttribute() -> Services.Search.Actions.Search.RequestV1.Builder {
           builderResult.hasAttribute = false
           builderResult.attribute = .LocationId
           return self
        }
      public var hasAttributeValue:Bool {
           get {
                return builderResult.hasAttributeValue
           }
      }
      public var attributeValue:String {
           get {
                return builderResult.attributeValue
           }
           set (value) {
               builderResult.hasAttributeValue = true
               builderResult.attributeValue = value
           }
      }
      public func setAttributeValue(value:String) -> Services.Search.Actions.Search.RequestV1.Builder {
        self.attributeValue = value
        return self
      }
      public func clearAttributeValue() -> Services.Search.Actions.Search.RequestV1.Builder{
           builderResult.hasAttributeValue = false
           builderResult.attributeValue = ""
           return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Search.Actions.Search.RequestV1.Builder {
        builderResult = Services.Search.Actions.Search.RequestV1()
        return self
      }
      public override func clone() throws -> Services.Search.Actions.Search.RequestV1.Builder {
        return try Services.Search.Actions.Search.RequestV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Search.Actions.Search.RequestV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Search.Actions.Search.RequestV1 {
        let returnMe:Services.Search.Actions.Search.RequestV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Search.Actions.Search.RequestV1) throws -> Services.Search.Actions.Search.RequestV1.Builder {
        if other == Services.Search.Actions.Search.RequestV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if other.hasQuery {
             query = other.query
        }
        if other.hasCategory {
             category = other.category
        }
        if other.hasAttribute {
             attribute = other.attribute
        }
        if other.hasAttributeValue {
             attributeValue = other.attributeValue
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Search.Actions.Search.RequestV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.RequestV1.Builder {
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
            query = try input.readString()

          case 24 :
            let valueIntcategory = try input.readEnum()
            if let enumscategory = Services.Search.Containers.Search.CategoryV1(rawValue:valueIntcategory){
                 category = enumscategory
            } else {
                 try unknownFieldsBuilder.mergeVarintField(3, value:Int64(valueIntcategory))
            }

          case 32 :
            let valueIntattribute = try input.readEnum()
            if let enumsattribute = Services.Search.Containers.Search.AttributeV1(rawValue:valueIntattribute){
                 attribute = enumsattribute
            } else {
                 try unknownFieldsBuilder.mergeVarintField(4, value:Int64(valueIntattribute))
            }

          case 42 :
            attributeValue = try input.readString()

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

    public private(set) var results:Array<Services.Search.Containers.SearchResultV1>  = Array<Services.Search.Containers.SearchResultV1>()
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
      for oneElementresults in results {
          try output.writeMessage(2, value:oneElementresults)
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
      for oneElementresults in results {
          serialize_size += oneElementresults.computeMessageSize(2)
      }
      serialize_size += unknownFields.serializedSize()
      memoizedSerializedSize = serialize_size
      return serialize_size
    }
    public class func parseArrayDelimitedFromInputStream(input:NSInputStream) throws -> Array<Services.Search.Actions.Search.ResponseV1> {
      var mergedArray = Array<Services.Search.Actions.Search.ResponseV1>()
      while let value = try parseFromDelimitedFromInputStream(input) {
        mergedArray += [value]
      }
      return mergedArray
    }
    public class func parseFromDelimitedFromInputStream(input:NSInputStream) throws -> Services.Search.Actions.Search.ResponseV1? {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeDelimitedFromInputStream(input)?.build()
    }
    public class func parseFromData(data:NSData) throws -> Services.Search.Actions.Search.ResponseV1 {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFromData(data, extensionRegistry:Services.Search.Actions.Search.SearchRoot.sharedInstance.extensionRegistry).build()
    }
    public class func parseFromData(data:NSData, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.ResponseV1 {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFromData(data, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromInputStream(input:NSInputStream) throws -> Services.Search.Actions.Search.ResponseV1 {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFromInputStream(input).build()
    }
    public class func parseFromInputStream(input:NSInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.ResponseV1 {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFromInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream) throws -> Services.Search.Actions.Search.ResponseV1 {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFromCodedInputStream(input).build()
    }
    public class func parseFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.ResponseV1 {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFromCodedInputStream(input, extensionRegistry:extensionRegistry).build()
    }
    public class func getBuilder() -> Services.Search.Actions.Search.ResponseV1.Builder {
      return Services.Search.Actions.Search.ResponseV1.classBuilder() as! Services.Search.Actions.Search.ResponseV1.Builder
    }
    public func getBuilder() -> Services.Search.Actions.Search.ResponseV1.Builder {
      return classBuilder() as! Services.Search.Actions.Search.ResponseV1.Builder
    }
    public override class func classBuilder() -> MessageBuilder {
      return Services.Search.Actions.Search.ResponseV1.Builder()
    }
    public override func classBuilder() -> MessageBuilder {
      return Services.Search.Actions.Search.ResponseV1.Builder()
    }
    public func toBuilder() throws -> Services.Search.Actions.Search.ResponseV1.Builder {
      return try Services.Search.Actions.Search.ResponseV1.builderWithPrototype(self)
    }
    public class func builderWithPrototype(prototype:Services.Search.Actions.Search.ResponseV1) throws -> Services.Search.Actions.Search.ResponseV1.Builder {
      return try Services.Search.Actions.Search.ResponseV1.Builder().mergeFrom(prototype)
    }
    override public func writeDescriptionTo(inout output:String, indent:String) throws {
      if hasVersion {
        output += "\(indent) version: \(version) \n"
      }
      var resultsElementIndex:Int = 0
      for oneElementresults in results {
          output += "\(indent) results[\(resultsElementIndex)] {\n"
          try oneElementresults.writeDescriptionTo(&output, indent:"\(indent)  ")
          output += "\(indent)}\n"
          resultsElementIndex++
      }
      unknownFields.writeDescriptionTo(&output, indent:indent)
    }
    override public var hashValue:Int {
        get {
            var hashCode:Int = 7
            if hasVersion {
               hashCode = (hashCode &* 31) &+ version.hashValue
            }
            for oneElementresults in results {
                hashCode = (hashCode &* 31) &+ oneElementresults.hashValue
            }
            hashCode = (hashCode &* 31) &+  unknownFields.hashValue
            return hashCode
        }
    }


    //Meta information declaration start

    override public class func className() -> String {
        return "Services.Search.Actions.Search.ResponseV1"
    }
    override public func className() -> String {
        return "Services.Search.Actions.Search.ResponseV1"
    }
    override public func classMetaType() -> GeneratedMessage.Type {
        return Services.Search.Actions.Search.ResponseV1.self
    }
    //Meta information declaration end

    final public class Builder : GeneratedMessageBuilder {
      private var builderResult:Services.Search.Actions.Search.ResponseV1 = Services.Search.Actions.Search.ResponseV1()
      public func getMessage() -> Services.Search.Actions.Search.ResponseV1 {
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
      public func setVersion(value:UInt32) -> Services.Search.Actions.Search.ResponseV1.Builder {
        self.version = value
        return self
      }
      public func clearVersion() -> Services.Search.Actions.Search.ResponseV1.Builder{
           builderResult.hasVersion = false
           builderResult.version = UInt32(1)
           return self
      }
      public var results:Array<Services.Search.Containers.SearchResultV1> {
           get {
               return builderResult.results
           }
           set (value) {
               builderResult.results = value
           }
      }
      public func setResults(value:Array<Services.Search.Containers.SearchResultV1>) -> Services.Search.Actions.Search.ResponseV1.Builder {
        self.results = value
        return self
      }
      public func clearResults() -> Services.Search.Actions.Search.ResponseV1.Builder {
        builderResult.results.removeAll(keepCapacity: false)
        return self
      }
      override public var internalGetResult:GeneratedMessage {
           get {
              return builderResult
           }
      }
      public override func clear() -> Services.Search.Actions.Search.ResponseV1.Builder {
        builderResult = Services.Search.Actions.Search.ResponseV1()
        return self
      }
      public override func clone() throws -> Services.Search.Actions.Search.ResponseV1.Builder {
        return try Services.Search.Actions.Search.ResponseV1.builderWithPrototype(builderResult)
      }
      public override func build() throws -> Services.Search.Actions.Search.ResponseV1 {
           try checkInitialized()
           return buildPartial()
      }
      public func buildPartial() -> Services.Search.Actions.Search.ResponseV1 {
        let returnMe:Services.Search.Actions.Search.ResponseV1 = builderResult
        return returnMe
      }
      public func mergeFrom(other:Services.Search.Actions.Search.ResponseV1) throws -> Services.Search.Actions.Search.ResponseV1.Builder {
        if other == Services.Search.Actions.Search.ResponseV1() {
         return self
        }
        if other.hasVersion {
             version = other.version
        }
        if !other.results.isEmpty  {
           builderResult.results += other.results
        }
        try mergeUnknownFields(other.unknownFields)
        return self
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream) throws -> Services.Search.Actions.Search.ResponseV1.Builder {
           return try mergeFromCodedInputStream(input, extensionRegistry:ExtensionRegistry())
      }
      public override func mergeFromCodedInputStream(input:CodedInputStream, extensionRegistry:ExtensionRegistry) throws -> Services.Search.Actions.Search.ResponseV1.Builder {
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
            let subBuilder = Services.Search.Containers.SearchResultV1.Builder()
            try input.readMessage(subBuilder,extensionRegistry:extensionRegistry)
            results += [subBuilder.buildPartial()]

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