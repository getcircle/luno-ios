// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/google/protobuf/descriptor.proto
package com.google.protobuf;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.INT32;
import static com.squareup.wire.Message.Datatype.STRING;

/**
 * Describes a value within an enum.
 */
public final class EnumValueDescriptorProto extends Message {
  private static final long serialVersionUID = 0L;

  public static final String DEFAULT_NAME = "";
  public static final Integer DEFAULT_NUMBER = 0;

  @ProtoField(tag = 1, type = STRING)
  public final String name;

  @ProtoField(tag = 2, type = INT32)
  public final Integer number;

  @ProtoField(tag = 3)
  public final EnumValueOptions options;

  public EnumValueDescriptorProto(String name, Integer number, EnumValueOptions options) {
    this.name = name;
    this.number = number;
    this.options = options;
  }

  private EnumValueDescriptorProto(Builder builder) {
    this(builder.name, builder.number, builder.options);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof EnumValueDescriptorProto)) return false;
    EnumValueDescriptorProto o = (EnumValueDescriptorProto) other;
    return equals(name, o.name)
        && equals(number, o.number)
        && equals(options, o.options);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = name != null ? name.hashCode() : 0;
      result = result * 37 + (number != null ? number.hashCode() : 0);
      result = result * 37 + (options != null ? options.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<EnumValueDescriptorProto> {

    public String name;
    public Integer number;
    public EnumValueOptions options;

    public Builder() {
    }

    public Builder(EnumValueDescriptorProto message) {
      super(message);
      if (message == null) return;
      this.name = message.name;
      this.number = message.number;
      this.options = message.options;
    }

    public Builder name(String name) {
      this.name = name;
      return this;
    }

    public Builder number(Integer number) {
      this.number = number;
      return this;
    }

    public Builder options(EnumValueOptions options) {
      this.options = options;
      return this;
    }

    @Override
    public EnumValueDescriptorProto build() {
      return new EnumValueDescriptorProto(this);
    }
  }
}
