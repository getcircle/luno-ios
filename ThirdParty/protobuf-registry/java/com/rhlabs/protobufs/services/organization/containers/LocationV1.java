// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/organization/containers.proto
package com.rhlabs.protobufs.services.organization.containers;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class LocationV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ID = "";
  public static final String DEFAULT_NAME = "";
  public static final String DEFAULT_ORGANIZATION_ID = "";
  public static final Integer DEFAULT_PROFILE_COUNT = 0;
  public static final String DEFAULT_IMAGE_URL = "";

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String id;

  @ProtoField(tag = 3, type = STRING)
  public final String name;

  @ProtoField(tag = 4)
  public final AddressV1 address;

  @ProtoField(tag = 5, type = STRING)
  public final String organization_id;

  @ProtoField(tag = 6, type = UINT32)
  public final Integer profile_count;

  @ProtoField(tag = 7, type = STRING)
  public final String image_url;

  public LocationV1(Integer version, String id, String name, AddressV1 address, String organization_id, Integer profile_count, String image_url) {
    this.version = version;
    this.id = id;
    this.name = name;
    this.address = address;
    this.organization_id = organization_id;
    this.profile_count = profile_count;
    this.image_url = image_url;
  }

  private LocationV1(Builder builder) {
    this(builder.version, builder.id, builder.name, builder.address, builder.organization_id, builder.profile_count, builder.image_url);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof LocationV1)) return false;
    LocationV1 o = (LocationV1) other;
    return equals(version, o.version)
        && equals(id, o.id)
        && equals(name, o.name)
        && equals(address, o.address)
        && equals(organization_id, o.organization_id)
        && equals(profile_count, o.profile_count)
        && equals(image_url, o.image_url);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (id != null ? id.hashCode() : 0);
      result = result * 37 + (name != null ? name.hashCode() : 0);
      result = result * 37 + (address != null ? address.hashCode() : 0);
      result = result * 37 + (organization_id != null ? organization_id.hashCode() : 0);
      result = result * 37 + (profile_count != null ? profile_count.hashCode() : 0);
      result = result * 37 + (image_url != null ? image_url.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<LocationV1> {

    public Integer version;
    public String id;
    public String name;
    public AddressV1 address;
    public String organization_id;
    public Integer profile_count;
    public String image_url;

    public Builder() {
    }

    public Builder(LocationV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.id = message.id;
      this.name = message.name;
      this.address = message.address;
      this.organization_id = message.organization_id;
      this.profile_count = message.profile_count;
      this.image_url = message.image_url;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder id(String id) {
      this.id = id;
      return this;
    }

    public Builder name(String name) {
      this.name = name;
      return this;
    }

    public Builder address(AddressV1 address) {
      this.address = address;
      return this;
    }

    public Builder organization_id(String organization_id) {
      this.organization_id = organization_id;
      return this;
    }

    public Builder profile_count(Integer profile_count) {
      this.profile_count = profile_count;
      return this;
    }

    public Builder image_url(String image_url) {
      this.image_url = image_url;
      return this;
    }

    @Override
    public LocationV1 build() {
      return new LocationV1(this);
    }
  }
}