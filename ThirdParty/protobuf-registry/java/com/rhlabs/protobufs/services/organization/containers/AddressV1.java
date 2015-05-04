// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/organization/containers.proto
package com.rhlabs.protobufs.services.organization.containers;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class AddressV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ID = "";
  public static final String DEFAULT_ORGANIZATION_ID = "";
  public static final String DEFAULT_NAME = "";
  public static final String DEFAULT_ADDRESS_1 = "";
  public static final String DEFAULT_ADDRESS_2 = "";
  public static final String DEFAULT_CITY = "";
  public static final String DEFAULT_REGION = "";
  public static final String DEFAULT_POSTAL_CODE = "";
  public static final String DEFAULT_COUNTRY_CODE = "";
  public static final String DEFAULT_PROFILE_COUNT = "";
  public static final String DEFAULT_LATITUDE = "";
  public static final String DEFAULT_LONGITUDE = "";
  public static final String DEFAULT_TIMEZONE = "";

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String id;

  @ProtoField(tag = 3, type = STRING)
  public final String organization_id;

  @ProtoField(tag = 4, type = STRING)
  public final String name;

  @ProtoField(tag = 5, type = STRING)
  public final String address_1;

  @ProtoField(tag = 6, type = STRING)
  public final String address_2;

  @ProtoField(tag = 7, type = STRING)
  public final String city;

  @ProtoField(tag = 8, type = STRING)
  public final String region;

  @ProtoField(tag = 9, type = STRING)
  public final String postal_code;

  @ProtoField(tag = 10, type = STRING)
  public final String country_code;

  @ProtoField(tag = 11, type = STRING)
  public final String profile_count;

  @ProtoField(tag = 12, type = STRING)
  public final String latitude;

  @ProtoField(tag = 13, type = STRING)
  public final String longitude;

  @ProtoField(tag = 14, type = STRING)
  public final String timezone;

  public AddressV1(Integer version, String id, String organization_id, String name, String address_1, String address_2, String city, String region, String postal_code, String country_code, String profile_count, String latitude, String longitude, String timezone) {
    this.version = version;
    this.id = id;
    this.organization_id = organization_id;
    this.name = name;
    this.address_1 = address_1;
    this.address_2 = address_2;
    this.city = city;
    this.region = region;
    this.postal_code = postal_code;
    this.country_code = country_code;
    this.profile_count = profile_count;
    this.latitude = latitude;
    this.longitude = longitude;
    this.timezone = timezone;
  }

  private AddressV1(Builder builder) {
    this(builder.version, builder.id, builder.organization_id, builder.name, builder.address_1, builder.address_2, builder.city, builder.region, builder.postal_code, builder.country_code, builder.profile_count, builder.latitude, builder.longitude, builder.timezone);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof AddressV1)) return false;
    AddressV1 o = (AddressV1) other;
    return equals(version, o.version)
        && equals(id, o.id)
        && equals(organization_id, o.organization_id)
        && equals(name, o.name)
        && equals(address_1, o.address_1)
        && equals(address_2, o.address_2)
        && equals(city, o.city)
        && equals(region, o.region)
        && equals(postal_code, o.postal_code)
        && equals(country_code, o.country_code)
        && equals(profile_count, o.profile_count)
        && equals(latitude, o.latitude)
        && equals(longitude, o.longitude)
        && equals(timezone, o.timezone);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (id != null ? id.hashCode() : 0);
      result = result * 37 + (organization_id != null ? organization_id.hashCode() : 0);
      result = result * 37 + (name != null ? name.hashCode() : 0);
      result = result * 37 + (address_1 != null ? address_1.hashCode() : 0);
      result = result * 37 + (address_2 != null ? address_2.hashCode() : 0);
      result = result * 37 + (city != null ? city.hashCode() : 0);
      result = result * 37 + (region != null ? region.hashCode() : 0);
      result = result * 37 + (postal_code != null ? postal_code.hashCode() : 0);
      result = result * 37 + (country_code != null ? country_code.hashCode() : 0);
      result = result * 37 + (profile_count != null ? profile_count.hashCode() : 0);
      result = result * 37 + (latitude != null ? latitude.hashCode() : 0);
      result = result * 37 + (longitude != null ? longitude.hashCode() : 0);
      result = result * 37 + (timezone != null ? timezone.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<AddressV1> {

    public Integer version;
    public String id;
    public String organization_id;
    public String name;
    public String address_1;
    public String address_2;
    public String city;
    public String region;
    public String postal_code;
    public String country_code;
    public String profile_count;
    public String latitude;
    public String longitude;
    public String timezone;

    public Builder() {
    }

    public Builder(AddressV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.id = message.id;
      this.organization_id = message.organization_id;
      this.name = message.name;
      this.address_1 = message.address_1;
      this.address_2 = message.address_2;
      this.city = message.city;
      this.region = message.region;
      this.postal_code = message.postal_code;
      this.country_code = message.country_code;
      this.profile_count = message.profile_count;
      this.latitude = message.latitude;
      this.longitude = message.longitude;
      this.timezone = message.timezone;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder id(String id) {
      this.id = id;
      return this;
    }

    public Builder organization_id(String organization_id) {
      this.organization_id = organization_id;
      return this;
    }

    public Builder name(String name) {
      this.name = name;
      return this;
    }

    public Builder address_1(String address_1) {
      this.address_1 = address_1;
      return this;
    }

    public Builder address_2(String address_2) {
      this.address_2 = address_2;
      return this;
    }

    public Builder city(String city) {
      this.city = city;
      return this;
    }

    public Builder region(String region) {
      this.region = region;
      return this;
    }

    public Builder postal_code(String postal_code) {
      this.postal_code = postal_code;
      return this;
    }

    public Builder country_code(String country_code) {
      this.country_code = country_code;
      return this;
    }

    public Builder profile_count(String profile_count) {
      this.profile_count = profile_count;
      return this;
    }

    public Builder latitude(String latitude) {
      this.latitude = latitude;
      return this;
    }

    public Builder longitude(String longitude) {
      this.longitude = longitude;
      return this;
    }

    public Builder timezone(String timezone) {
      this.timezone = timezone;
      return this;
    }

    @Override
    public AddressV1 build() {
      return new AddressV1(this);
    }
  }
}
