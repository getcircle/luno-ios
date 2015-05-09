// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/feed/actions/get_organization_feed.proto
package com.rhlabs.protobufs.services.feed.actions.get_organization_feed;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class GetOrganizationFeedRequestV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ORGANIZATION_ID = "";

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  /**
   * TODO: this should just use the token that was provided
   */
  @ProtoField(tag = 2, type = STRING)
  public final String organization_id;

  public GetOrganizationFeedRequestV1(Integer version, String organization_id) {
    this.version = version;
    this.organization_id = organization_id;
  }

  private GetOrganizationFeedRequestV1(Builder builder) {
    this(builder.version, builder.organization_id);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof GetOrganizationFeedRequestV1)) return false;
    GetOrganizationFeedRequestV1 o = (GetOrganizationFeedRequestV1) other;
    return equals(version, o.version)
        && equals(organization_id, o.organization_id);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (organization_id != null ? organization_id.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<GetOrganizationFeedRequestV1> {

    public Integer version;
    public String organization_id;

    public Builder() {
    }

    public Builder(GetOrganizationFeedRequestV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.organization_id = message.organization_id;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    /**
     * TODO: this should just use the token that was provided
     */
    public Builder organization_id(String organization_id) {
      this.organization_id = organization_id;
      return this;
    }

    @Override
    public GetOrganizationFeedRequestV1 build() {
      return new GetOrganizationFeedRequestV1(this);
    }
  }
}