// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/resume/actions/create_company.proto
package com.rhlabs.protobufs.services.resume.actions.create_company;

import com.rhlabs.protobufs.services.resume.containers.CompanyV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoField;

import static com.squareup.wire.Message.Datatype.UINT32;

public final class CreateCompanyRequestV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2)
  public final CompanyV1 company;

  public CreateCompanyRequestV1(Integer version, CompanyV1 company) {
    this.version = version;
    this.company = company;
  }

  private CreateCompanyRequestV1(Builder builder) {
    this(builder.version, builder.company);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof CreateCompanyRequestV1)) return false;
    CreateCompanyRequestV1 o = (CreateCompanyRequestV1) other;
    return equals(version, o.version)
        && equals(company, o.company);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (company != null ? company.hashCode() : 0);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<CreateCompanyRequestV1> {

    public Integer version;
    public CompanyV1 company;

    public Builder() {
    }

    public Builder(CreateCompanyRequestV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.company = message.company;
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder company(CompanyV1 company) {
      this.company = company;
      return this;
    }

    @Override
    public CreateCompanyRequestV1 build() {
      return new CreateCompanyRequestV1(this);
    }
  }
}