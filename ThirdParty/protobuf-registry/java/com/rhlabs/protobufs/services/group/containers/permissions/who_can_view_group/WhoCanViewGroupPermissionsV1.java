// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/group/containers/permissions/who_can_view_group.proto
package com.rhlabs.protobufs.services.group.containers.permissions.who_can_view_group;

import com.squareup.wire.ProtoEnum;

public enum WhoCanViewGroupPermissionsV1
    implements ProtoEnum {
  ANYONE(0),
  ALL_IN_DOMAIN(1),
  ALL_MEMBERS(2),
  ALL_MANAGERS(3);

  private final int value;

  WhoCanViewGroupPermissionsV1(int value) {
    this.value = value;
  }

  @Override
  public int getValue() {
    return value;
  }
}
