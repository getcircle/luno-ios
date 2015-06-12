// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/organization/actions/enable_integration.proto
package com.rhlabs.protobufs.services.organization.actions.enable_integration;

import com.rhlabs.protobufs.services.organization.containers.integration.IntegrationV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.UINT32;

public final class EnableIntegrationRequestV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2)
  public final IntegrationV1 integration;

  public EnableIntegrationRequestV1(Integer version, IntegrationV1 integration) {
    this.version = version;
    this.integration = integration;
  }

  private EnableIntegrationRequestV1(Builder builder) {
    this(builder.version, builder.integration);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof EnableIntegrationRequestV1)) return false;
    EnableIntegrationRequestV1 o = (EnableIntegrationRequestV1) other;
    return equals(version, o.version)
        && equals(integration, o.integration);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (integration != null ? integration.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<EnableIntegrationRequestV1> {

    public Integer version;
    public IntegrationV1 integration;

    public Builder() {
    }

    public Builder(EnableIntegrationRequestV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.integration = message.integration;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder integration(IntegrationV1 integration) {
      this.integration = integration;
      return this;
    }

    @Override
    public EnableIntegrationRequestV1 build() {
      return new EnableIntegrationRequestV1(this);
    }
  }
}
