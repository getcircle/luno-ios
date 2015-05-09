// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/google/protobuf/descriptor.proto
package com.google.protobuf;

import com.squareup.wire.ExtendableMessage;
import com.squareup.wire.Extension;
import com.squareup.wire.ProtoField;
import java.util.Collections;
import java.util.List;

import static com.squareup.wire.Message.Datatype.BOOL;
import static com.squareup.wire.Message.Label.REPEATED;

public final class ServiceOptions extends ExtendableMessage<ServiceOptions> {
  private static final long serialVersionUID = 0L;

  public static final Boolean DEFAULT_DEPRECATED = false;
  public static final List<UninterpretedOption> DEFAULT_UNINTERPRETED_OPTION = Collections.emptyList();

  /**
   * Note:  Field numbers 1 through 32 are reserved for Google's internal RPC
   *   framework.  We apologize for hoarding these numbers to ourselves, but
   *   we were already using them long before we decided to release Protocol
   *   Buffers.
   * Is this service deprecated?
   * Depending on the target platform, this can emit Deprecated annotations
   * for the service, or it will be completely ignored; in the very least,
   * this is a formalization for deprecating services.
   */
  @ProtoField(tag = 33, type = BOOL)
  public final Boolean deprecated;

  /**
   * The parser stores options it doesn't recognize here. See above.
   */
  @ProtoField(tag = 999, label = REPEATED, messageType = UninterpretedOption.class)
  public final List<UninterpretedOption> uninterpreted_option;

  public ServiceOptions(Boolean deprecated, List<UninterpretedOption> uninterpreted_option) {
    this.deprecated = deprecated;
    this.uninterpreted_option = immutableCopyOf(uninterpreted_option);
  }

  private ServiceOptions(Builder builder) {
    this(builder.deprecated, builder.uninterpreted_option);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof ServiceOptions)) return false;
    ServiceOptions o = (ServiceOptions) other;
    if (!extensionsEqual(o)) return false;
    return equals(deprecated, o.deprecated)
        && equals(uninterpreted_option, o.uninterpreted_option);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = extensionsHashCode();
      result = result * 37 + (deprecated != null ? deprecated.hashCode() : 0);
      result = result * 37 + (uninterpreted_option != null ? uninterpreted_option.hashCode() : 1);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends ExtendableBuilder<ServiceOptions> {

    public Boolean deprecated;
    public List<UninterpretedOption> uninterpreted_option;

    public Builder() {
    }

    public Builder(ServiceOptions message) {
      super(message);
      if (message == null) return;
      this.deprecated = message.deprecated;
      this.uninterpreted_option = copyOf(message.uninterpreted_option);
    }

    /**
     * Note:  Field numbers 1 through 32 are reserved for Google's internal RPC
     *   framework.  We apologize for hoarding these numbers to ourselves, but
     *   we were already using them long before we decided to release Protocol
     *   Buffers.
     * Is this service deprecated?
     * Depending on the target platform, this can emit Deprecated annotations
     * for the service, or it will be completely ignored; in the very least,
     * this is a formalization for deprecating services.
     */
    public Builder deprecated(Boolean deprecated) {
      this.deprecated = deprecated;
      return this;
    }

    /**
     * The parser stores options it doesn't recognize here. See above.
     */
    public Builder uninterpreted_option(List<UninterpretedOption> uninterpreted_option) {
      this.uninterpreted_option = checkForNulls(uninterpreted_option);
      return this;
    }

    @Override
    public <E> Builder setExtension(Extension<ServiceOptions, E> extension, E value) {
      super.setExtension(extension, value);
      return this;
    }

    @Override
    public ServiceOptions build() {
      return new ServiceOptions(this);
    }
  }
}