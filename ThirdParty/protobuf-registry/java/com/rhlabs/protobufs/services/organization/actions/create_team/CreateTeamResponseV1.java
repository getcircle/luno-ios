// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/organization/actions/create_team.proto
package com.rhlabs.protobufs.services.organization.actions.create_team;

import com.rhlabs.protobufs.services.organization.containers.TeamV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.UINT32;

public final class CreateTeamResponseV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2)
  public final TeamV1 team;

  public CreateTeamResponseV1(Integer version, TeamV1 team) {
    this.version = version;
    this.team = team;
  }

  private CreateTeamResponseV1(Builder builder) {
    this(builder.version, builder.team);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof CreateTeamResponseV1)) return false;
    CreateTeamResponseV1 o = (CreateTeamResponseV1) other;
    return equals(version, o.version)
        && equals(team, o.team);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (team != null ? team.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<CreateTeamResponseV1> {

    public Integer version;
    public TeamV1 team;

    public Builder() {
    }

    public Builder(CreateTeamResponseV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.team = message.team;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder team(TeamV1 team) {
      this.team = team;
      return this;
    }

    @Override
    public CreateTeamResponseV1 build() {
      return new CreateTeamResponseV1(this);
    }
  }
}