// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/user/actions/authenticate_user.proto
package com.rhlabs.protobufs.services.user.actions.authenticate_user;

import com.rhlabs.protobufs.services.user.containers.token.ClientTypeV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoEnum;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.ENUM;
import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class AuthenticateUserRequestV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final AuthBackendV1 DEFAULT_BACKEND = AuthBackendV1.INTERNAL;
  public static final ClientTypeV1 DEFAULT_CLIENT_TYPE = ClientTypeV1.IOS;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = ENUM)
  public final AuthBackendV1 backend;

  @ProtoField(tag = 3)
  public final CredentialsV1 credentials;

  @ProtoField(tag = 4, type = ENUM)
  public final ClientTypeV1 client_type;

  public AuthenticateUserRequestV1(Integer version, AuthBackendV1 backend, CredentialsV1 credentials, ClientTypeV1 client_type) {
    this.version = version;
    this.backend = backend;
    this.credentials = credentials;
    this.client_type = client_type;
  }

  private AuthenticateUserRequestV1(Builder builder) {
    this(builder.version, builder.backend, builder.credentials, builder.client_type);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof AuthenticateUserRequestV1)) return false;
    AuthenticateUserRequestV1 o = (AuthenticateUserRequestV1) other;
    return equals(version, o.version)
        && equals(backend, o.backend)
        && equals(credentials, o.credentials)
        && equals(client_type, o.client_type);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (backend != null ? backend.hashCode() : 0);
      result = result * 37 + (credentials != null ? credentials.hashCode() : 0);
      result = result * 37 + (client_type != null ? client_type.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<AuthenticateUserRequestV1> {

    public Integer version;
    public AuthBackendV1 backend;
    public CredentialsV1 credentials;
    public ClientTypeV1 client_type;

    public Builder() {
    }

    public Builder(AuthenticateUserRequestV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.backend = message.backend;
      this.credentials = message.credentials;
      this.client_type = message.client_type;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder backend(AuthBackendV1 backend) {
      this.backend = backend;
      return this;
    }

    public Builder credentials(CredentialsV1 credentials) {
      this.credentials = credentials;
      return this;
    }

    public Builder client_type(ClientTypeV1 client_type) {
      this.client_type = client_type;
      return this;
    }

    @Override
    public AuthenticateUserRequestV1 build() {
      return new AuthenticateUserRequestV1(this);
    }
  }

  public enum AuthBackendV1
      implements ProtoEnum {
    INTERNAL(0),
    GOOGLE(1);

    private final int value;

    private AuthBackendV1(int value) {
      this.value = value;
    }

    @Override
    public int getValue() {
      return value;
    }
  }

  public static final class CredentialsV1 extends Message {
    private static final long serialVersionUID = 0L;

    public static final Integer DEFAULT_VERSION = 1;
    public static final String DEFAULT_KEY = "";
    public static final String DEFAULT_SECRET = "";

    @ProtoField(tag = 1, type = UINT32)
    public final Integer version;

    @ProtoField(tag = 2, type = STRING)
    public final String key;

    @ProtoField(tag = 3, type = STRING)
    public final String secret;

    public CredentialsV1(Integer version, String key, String secret) {
      this.version = version;
      this.key = key;
      this.secret = secret;
    }

    private CredentialsV1(Builder builder) {
      this(builder.version, builder.key, builder.secret);
      setBuilder(builder);
    }

    @Override
    public boolean equals(Object other) {
      if (other == this) return true;
      if (!(other instanceof CredentialsV1)) return false;
      CredentialsV1 o = (CredentialsV1) other;
      return equals(version, o.version)
          && equals(key, o.key)
          && equals(secret, o.secret);
    }

    @Override
    public int hashCode() {
      int result = hashCode;
      if (result == 0) {
        result = version != null ? version.hashCode() : 0;
        result = result * 37 + (key != null ? key.hashCode() : 0);
        result = result * 37 + (secret != null ? secret.hashCode() : 0);
        hashCode = result;
      }
      return result;
    }

    public static final class Builder extends Message.Builder<CredentialsV1> {

      public Integer version;
      public String key;
      public String secret;

      public Builder() {
      }

      public Builder(CredentialsV1 message) {
        super(message);
        if (message == null) return;
        this.version = message.version;
        this.key = message.key;
        this.secret = message.secret;
      }

      public Builder version(Integer version) {
        this.version = version;
        return this;
      }

      public Builder key(String key) {
        this.key = key;
        return this;
      }

      public Builder secret(String secret) {
        this.secret = secret;
        return this;
      }

      @Override
      public CredentialsV1 build() {
        return new CredentialsV1(this);
      }
    }
  }
}