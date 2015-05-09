// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/organization/containers.proto
package com.rhlabs.protobufs.services.organization.containers;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class OrganizationV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ID = "";
  public static final String DEFAULT_NAME = "";
  public static final String DEFAULT_DOMAIN = "";
  public static final String DEFAULT_IMAGE_URL = "";

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String id;

  @ProtoField(tag = 3, type = STRING)
  public final String name;

  @ProtoField(tag = 4, type = STRING)
  public final String domain;

  @ProtoField(tag = 5, type = STRING)
  public final String image_url;

  @ProtoField(tag = 6)
  public final ColorV1 tint_color;

  public OrganizationV1(Integer version, String id, String name, String domain, String image_url, ColorV1 tint_color) {
    this.version = version;
    this.id = id;
    this.name = name;
    this.domain = domain;
    this.image_url = image_url;
    this.tint_color = tint_color;
  }

  private OrganizationV1(Builder builder) {
    this(builder.version, builder.id, builder.name, builder.domain, builder.image_url, builder.tint_color);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof OrganizationV1)) return false;
    OrganizationV1 o = (OrganizationV1) other;
    return equals(version, o.version)
        && equals(id, o.id)
        && equals(name, o.name)
        && equals(domain, o.domain)
        && equals(image_url, o.image_url)
        && equals(tint_color, o.tint_color);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (id != null ? id.hashCode() : 0);
      result = result * 37 + (name != null ? name.hashCode() : 0);
      result = result * 37 + (domain != null ? domain.hashCode() : 0);
      result = result * 37 + (image_url != null ? image_url.hashCode() : 0);
      result = result * 37 + (tint_color != null ? tint_color.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<OrganizationV1> {

    public Integer version;
    public String id;
    public String name;
    public String domain;
    public String image_url;
    public ColorV1 tint_color;

    public Builder() {
    }

    public Builder(OrganizationV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.id = message.id;
      this.name = message.name;
      this.domain = message.domain;
      this.image_url = message.image_url;
      this.tint_color = message.tint_color;
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

    public Builder domain(String domain) {
      this.domain = domain;
      return this;
    }

    public Builder image_url(String image_url) {
      this.image_url = image_url;
      return this;
    }

    public Builder tint_color(ColorV1 tint_color) {
      this.tint_color = tint_color;
      return this;
    }

    @Override
    public OrganizationV1 build() {
      return new OrganizationV1(this);
    }
  }
}