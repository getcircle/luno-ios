// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/user/actions/authenticate_user.proto
package com.rhlabs.protobufs.services.user.actions.authenticate_user;

import com.rhlabs.protobufs.services.user.containers.UserV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.BOOL;
import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class AuthenticateUserResponseV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_TOKEN = "";
  public static final Boolean DEFAULT_NEW_USER = false;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2)
  public final UserV1 user;

  @ProtoField(tag = 3, type = STRING)
  public final String token;

  @ProtoField(tag = 4, type = BOOL)
  public final Boolean new_user;

  public AuthenticateUserResponseV1(Integer version, UserV1 user, String token, Boolean new_user) {
    this.version = version;
    this.user = user;
    this.token = token;
    this.new_user = new_user;
  }

  private AuthenticateUserResponseV1(Builder builder) {
    this(builder.version, builder.user, builder.token, builder.new_user);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof AuthenticateUserResponseV1)) return false;
    AuthenticateUserResponseV1 o = (AuthenticateUserResponseV1) other;
    return equals(version, o.version)
        && equals(user, o.user)
        && equals(token, o.token)
        && equals(new_user, o.new_user);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (user != null ? user.hashCode() : 0);
      result = result * 37 + (token != null ? token.hashCode() : 0);
      result = result * 37 + (new_user != null ? new_user.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<AuthenticateUserResponseV1> {

    public Integer version;
    public UserV1 user;
    public String token;
    public Boolean new_user;

    public Builder() {
    }

    public Builder(AuthenticateUserResponseV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.user = message.user;
      this.token = message.token;
      this.new_user = message.new_user;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder user(UserV1 user) {
      this.user = user;
      return this;
    }

    public Builder token(String token) {
      this.token = token;
      return this;
    }

    public Builder new_user(Boolean new_user) {
      this.new_user = new_user;
      return this;
    }

    @Override
    public AuthenticateUserResponseV1 build() {
      return new AuthenticateUserResponseV1(this);
    }
  }
}