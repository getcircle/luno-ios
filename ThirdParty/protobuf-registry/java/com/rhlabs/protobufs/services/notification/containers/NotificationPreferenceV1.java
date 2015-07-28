// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/notification/containers.proto
package com.rhlabs.protobufs.services.notification.containers;

import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.BOOL;
import static com.squareup.wire.Message.Datatype.ENUM;
import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;

public final class NotificationPreferenceV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_ID = "";
  public static final String DEFAULT_PROFILE_ID = "";
  public static final NotificationTypeV1.TypeIdV1 DEFAULT_NOTIFICATION_TYPE_ID = NotificationTypeV1.TypeIdV1.GOOGLE_GROUPS;
  public static final Boolean DEFAULT_SUBSCRIBED = false;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String id;

  @ProtoField(tag = 3, type = STRING)
  public final String profile_id;

  @ProtoField(tag = 4, type = ENUM)
  public final NotificationTypeV1.TypeIdV1 notification_type_id;

  @ProtoField(tag = 5, type = BOOL)
  public final Boolean subscribed;

  @ProtoField(tag = 6)
  public final NotificationTypeV1 notification_type;

  public NotificationPreferenceV1(Integer version, String id, String profile_id, NotificationTypeV1.TypeIdV1 notification_type_id, Boolean subscribed, NotificationTypeV1 notification_type) {
    this.version = version;
    this.id = id;
    this.profile_id = profile_id;
    this.notification_type_id = notification_type_id;
    this.subscribed = subscribed;
    this.notification_type = notification_type;
  }

  private NotificationPreferenceV1(Builder builder) {
    this(builder.version, builder.id, builder.profile_id, builder.notification_type_id, builder.subscribed, builder.notification_type);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof NotificationPreferenceV1)) return false;
    NotificationPreferenceV1 o = (NotificationPreferenceV1) other;
    return equals(version, o.version)
        && equals(id, o.id)
        && equals(profile_id, o.profile_id)
        && equals(notification_type_id, o.notification_type_id)
        && equals(subscribed, o.subscribed)
        && equals(notification_type, o.notification_type);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (id != null ? id.hashCode() : 0);
      result = result * 37 + (profile_id != null ? profile_id.hashCode() : 0);
      result = result * 37 + (notification_type_id != null ? notification_type_id.hashCode() : 0);
      result = result * 37 + (subscribed != null ? subscribed.hashCode() : 0);
      result = result * 37 + (notification_type != null ? notification_type.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<NotificationPreferenceV1> {

    public Integer version;
    public String id;
    public String profile_id;
    public NotificationTypeV1.TypeIdV1 notification_type_id;
    public Boolean subscribed;
    public NotificationTypeV1 notification_type;

    public Builder() {
    }

    public Builder(NotificationPreferenceV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.id = message.id;
      this.profile_id = message.profile_id;
      this.notification_type_id = message.notification_type_id;
      this.subscribed = message.subscribed;
      this.notification_type = message.notification_type;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder id(String id) {
      this.id = id;
      return this;
    }

    public Builder profile_id(String profile_id) {
      this.profile_id = profile_id;
      return this;
    }

    public Builder notification_type_id(NotificationTypeV1.TypeIdV1 notification_type_id) {
      this.notification_type_id = notification_type_id;
      return this;
    }

    public Builder subscribed(Boolean subscribed) {
      this.subscribed = subscribed;
      return this;
    }

    public Builder notification_type(NotificationTypeV1 notification_type) {
      this.notification_type = notification_type;
      return this;
    }

    @Override
    public NotificationPreferenceV1 build() {
      return new NotificationPreferenceV1(this);
    }
  }
}