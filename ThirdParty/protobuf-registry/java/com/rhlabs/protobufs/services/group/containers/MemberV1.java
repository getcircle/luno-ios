// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/group/containers.proto
package com.rhlabs.protobufs.services.group.containers;

import com.rhlabs.protobufs.services.profile.containers.ProfileV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.ENUM;
import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class MemberV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ID = "";
  public static final RoleV1 DEFAULT_ROLE = RoleV1.OWNER;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String id;

  @ProtoField(tag = 3)
  public final ProfileV1 profile;

  @ProtoField(tag = 4, type = ENUM)
  public final RoleV1 role;

  public MemberV1(Integer version, String id, ProfileV1 profile, RoleV1 role) {
    this.version = version;
    this.id = id;
    this.profile = profile;
    this.role = role;
  }

  private MemberV1(Builder builder) {
    this(builder.version, builder.id, builder.profile, builder.role);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof MemberV1)) return false;
    MemberV1 o = (MemberV1) other;
    return equals(version, o.version)
        && equals(id, o.id)
        && equals(profile, o.profile)
        && equals(role, o.role);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (id != null ? id.hashCode() : 0);
      result = result * 37 + (profile != null ? profile.hashCode() : 0);
      result = result * 37 + (role != null ? role.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<MemberV1> {

    public Integer version;
    public String id;
    public ProfileV1 profile;
    public RoleV1 role;

    public Builder() {
    }

    public Builder(MemberV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.id = message.id;
      this.profile = message.profile;
      this.role = message.role;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder id(String id) {
      this.id = id;
      return this;
    }

    public Builder profile(ProfileV1 profile) {
      this.profile = profile;
      return this;
    }

    public Builder role(RoleV1 role) {
      this.role = role;
      return this;
    }

    @Override
    public MemberV1 build() {
      return new MemberV1(this);
    }
  }
}
