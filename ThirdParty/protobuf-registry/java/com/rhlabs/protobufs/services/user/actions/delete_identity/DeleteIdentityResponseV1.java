// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/user/actions/delete_identity.proto
package com.rhlabs.protobufs.services.user.actions.delete_identity;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.UINT32;

public final class DeleteIdentityResponseV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  public DeleteIdentityResponseV1(Integer version) {
    this.version = version;
  }

  private DeleteIdentityResponseV1(Builder builder) {
    this(builder.version);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof DeleteIdentityResponseV1)) return false;
    return equals(version, ((DeleteIdentityResponseV1) other).version);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    return result != 0 ? result : (hashCode = version != null ? version.hashCode() : 0);
  }

  public static final class Builder extends Message.Builder<DeleteIdentityResponseV1> {

    public Integer version;

    public Builder() {
    }

    public Builder(DeleteIdentityResponseV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    @Override
    public DeleteIdentityResponseV1 build() {
      return new DeleteIdentityResponseV1(this);
    }
  }
}