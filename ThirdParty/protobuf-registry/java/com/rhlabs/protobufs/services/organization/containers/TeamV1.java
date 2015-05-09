// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/organization/containers.proto
package com.rhlabs.protobufs.services.organization.containers;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;
import java.util.Collections;
import java.util.List;

import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;
import static com.squareup.wire.Message.Label.REPEATED;

public final class TeamV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ID = "";
  public static final String DEFAULT_NAME = "";
  public static final String DEFAULT_OWNER_ID = "";
  public static final String DEFAULT_ORGANIZATION_ID = "";
  public static final List<PathPartV1> DEFAULT_PATH = Collections.emptyList();
  public static final String DEFAULT_DEPARTMENT = "";
  public static final Integer DEFAULT_PROFILE_COUNT = 0;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String id;

  @ProtoField(tag = 3, type = STRING)
  public final String name;

  @ProtoField(tag = 4, type = STRING)
  public final String owner_id;

  @ProtoField(tag = 5, type = STRING)
  public final String organization_id;

  @ProtoField(tag = 6, label = REPEATED, messageType = PathPartV1.class)
  public final List<PathPartV1> path;

  @ProtoField(tag = 7, type = STRING)
  public final String department;

  @ProtoField(tag = 8, type = UINT32)
  public final Integer profile_count;

  @ProtoField(tag = 9)
  public final ColorV1 color;

  public TeamV1(Integer version, String id, String name, String owner_id, String organization_id, List<PathPartV1> path, String department, Integer profile_count, ColorV1 color) {
    this.version = version;
    this.id = id;
    this.name = name;
    this.owner_id = owner_id;
    this.organization_id = organization_id;
    this.path = immutableCopyOf(path);
    this.department = department;
    this.profile_count = profile_count;
    this.color = color;
  }

  private TeamV1(Builder builder) {
    this(builder.version, builder.id, builder.name, builder.owner_id, builder.organization_id, builder.path, builder.department, builder.profile_count, builder.color);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof TeamV1)) return false;
    TeamV1 o = (TeamV1) other;
    return equals(version, o.version)
        && equals(id, o.id)
        && equals(name, o.name)
        && equals(owner_id, o.owner_id)
        && equals(organization_id, o.organization_id)
        && equals(path, o.path)
        && equals(department, o.department)
        && equals(profile_count, o.profile_count)
        && equals(color, o.color);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (id != null ? id.hashCode() : 0);
      result = result * 37 + (name != null ? name.hashCode() : 0);
      result = result * 37 + (owner_id != null ? owner_id.hashCode() : 0);
      result = result * 37 + (organization_id != null ? organization_id.hashCode() : 0);
      result = result * 37 + (path != null ? path.hashCode() : 1);
      result = result * 37 + (department != null ? department.hashCode() : 0);
      result = result * 37 + (profile_count != null ? profile_count.hashCode() : 0);
      result = result * 37 + (color != null ? color.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<TeamV1> {

    public Integer version;
    public String id;
    public String name;
    public String owner_id;
    public String organization_id;
    public List<PathPartV1> path;
    public String department;
    public Integer profile_count;
    public ColorV1 color;

    public Builder() {
    }

    public Builder(TeamV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.id = message.id;
      this.name = message.name;
      this.owner_id = message.owner_id;
      this.organization_id = message.organization_id;
      this.path = copyOf(message.path);
      this.department = message.department;
      this.profile_count = message.profile_count;
      this.color = message.color;
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

    public Builder owner_id(String owner_id) {
      this.owner_id = owner_id;
      return this;
    }

    public Builder organization_id(String organization_id) {
      this.organization_id = organization_id;
      return this;
    }

    public Builder path(List<PathPartV1> path) {
      this.path = checkForNulls(path);
      return this;
    }

    public Builder department(String department) {
      this.department = department;
      return this;
    }

    public Builder profile_count(Integer profile_count) {
      this.profile_count = profile_count;
      return this;
    }

    public Builder color(ColorV1 color) {
      this.color = color;
      return this;
    }

    @Override
    public TeamV1 build() {
      return new TeamV1(this);
    }
  }
}