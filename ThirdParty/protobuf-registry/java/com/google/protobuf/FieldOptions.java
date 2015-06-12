// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/google/protobuf/descriptor.proto
package com.google.protobuf;

import com.squareup.wire.ExtendableMessage;
import com.squareup.wire.Extension;
import com.squareup.wire.ProtoEnum;
import com.squareup.wire.ProtoField;
import java.util.Collections;
import java.util.List;

import static com.squareup.wire.Message.Datatype.BOOL;
import static com.squareup.wire.Message.Datatype.ENUM;
import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Label.REPEATED;

public final class FieldOptions extends ExtendableMessage<FieldOptions> {
  private static final long serialVersionUID = 0L;

  public static final CType DEFAULT_CTYPE = CType.STRING;
  public static final Boolean DEFAULT_PACKED = false;
  public static final Boolean DEFAULT_LAZY = false;
  public static final Boolean DEFAULT_DEPRECATED = false;
  public static final String DEFAULT_EXPERIMENTAL_MAP_KEY = "";
  public static final Boolean DEFAULT_WEAK = false;
  public static final List<UninterpretedOption> DEFAULT_UNINTERPRETED_OPTION = Collections.emptyList();

  /**
   * The ctype option instructs the C++ code generator to use a different
   * representation of the field than it normally would.  See the specific
   * options below.  This option is not yet implemented in the open source
   * release -- sorry, we'll try to include it in a future version!
   */
  @ProtoField(tag = 1, type = ENUM)
  public final CType ctype;

  /**
   * The packed option can be enabled for repeated primitive fields to enable
   * a more efficient representation on the wire. Rather than repeatedly
   * writing the tag and type for each element, the entire array is encoded as
   * a single length-delimited blob.
   */
  @ProtoField(tag = 2, type = BOOL)
  public final Boolean packed;

  /**
   * Should this field be parsed lazily?  Lazy applies only to message-type
   * fields.  It means that when the outer message is initially parsed, the
   * inner message's contents will not be parsed but instead stored in encoded
   * form.  The inner message will actually be parsed when it is first accessed.
   *
   * This is only a hint.  Implementations are free to choose whether to use
   * eager or lazy parsing regardless of the value of this option.  However,
   * setting this option true suggests that the protocol author believes that
   * using lazy parsing on this field is worth the additional bookkeeping
   * overhead typically needed to implement it.
   *
   * This option does not affect the public interface of any generated code;
   * all method signatures remain the same.  Furthermore, thread-safety of the
   * interface is not affected by this option; const methods remain safe to
   * call from multiple threads concurrently, while non-const methods continue
   * to require exclusive access.
   *
   *
   * Note that implementations may choose not to check required fields within
   * a lazy sub-message.  That is, calling IsInitialized() on the outher message
   * may return true even if the inner message has missing required fields.
   * This is necessary because otherwise the inner message would have to be
   * parsed in order to perform the check, defeating the purpose of lazy
   * parsing.  An implementation which chooses not to check required fields
   * must be consistent about it.  That is, for any particular sub-message, the
   * implementation must either *always* check its required fields, or *never*
   * check its required fields, regardless of whether or not the message has
   * been parsed.
   */
  @ProtoField(tag = 5, type = BOOL)
  public final Boolean lazy;

  /**
   * Is this field deprecated?
   * Depending on the target platform, this can emit Deprecated annotations
   * for accessors, or it will be completely ignored; in the very least, this
   * is a formalization for deprecating fields.
   */
  @ProtoField(tag = 3, type = BOOL)
  public final Boolean deprecated;

  /**
   * EXPERIMENTAL.  DO NOT USE.
   * For "map" fields, the name of the field in the enclosed type that
   * is the key for this map.  For example, suppose we have:
   *   message Item {
   *     required string name = 1;
   *     required string value = 2;
   *   }
   *   message Config {
   *     repeated Item items = 1 [experimental_map_key="name"];
   *   }
   * In this situation, the map key for Item will be set to "name".
   * TODO: Fully-implement this, then remove the "experimental_" prefix.
   */
  @ProtoField(tag = 9, type = STRING)
  public final String experimental_map_key;

  /**
   * For Google-internal migration only. Do not use.
   */
  @ProtoField(tag = 10, type = BOOL)
  public final Boolean weak;

  /**
   * The parser stores options it doesn't recognize here. See above.
   */
  @ProtoField(tag = 999, label = REPEATED, messageType = UninterpretedOption.class)
  public final List<UninterpretedOption> uninterpreted_option;

  public FieldOptions(CType ctype, Boolean packed, Boolean lazy, Boolean deprecated, String experimental_map_key, Boolean weak, List<UninterpretedOption> uninterpreted_option) {
    this.ctype = ctype;
    this.packed = packed;
    this.lazy = lazy;
    this.deprecated = deprecated;
    this.experimental_map_key = experimental_map_key;
    this.weak = weak;
    this.uninterpreted_option = immutableCopyOf(uninterpreted_option);
  }

  private FieldOptions(Builder builder) {
    this(builder.ctype, builder.packed, builder.lazy, builder.deprecated, builder.experimental_map_key, builder.weak, builder.uninterpreted_option);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof FieldOptions)) return false;
    FieldOptions o = (FieldOptions) other;
    if (!extensionsEqual(o)) return false;
    return equals(ctype, o.ctype)
        && equals(packed, o.packed)
        && equals(lazy, o.lazy)
        && equals(deprecated, o.deprecated)
        && equals(experimental_map_key, o.experimental_map_key)
        && equals(weak, o.weak)
        && equals(uninterpreted_option, o.uninterpreted_option);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = extensionsHashCode();
      result = result * 37 + (ctype != null ? ctype.hashCode() : 0);
      result = result * 37 + (packed != null ? packed.hashCode() : 0);
      result = result * 37 + (lazy != null ? lazy.hashCode() : 0);
      result = result * 37 + (deprecated != null ? deprecated.hashCode() : 0);
      result = result * 37 + (experimental_map_key != null ? experimental_map_key.hashCode() : 0);
      result = result * 37 + (weak != null ? weak.hashCode() : 0);
      result = result * 37 + (uninterpreted_option != null ? uninterpreted_option.hashCode() : 1);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends ExtendableBuilder<FieldOptions> {

    public CType ctype;
    public Boolean packed;
    public Boolean lazy;
    public Boolean deprecated;
    public String experimental_map_key;
    public Boolean weak;
    public List<UninterpretedOption> uninterpreted_option;

    public Builder() {
    }

    public Builder(FieldOptions message) {
      super(message);
      if (message == null) return;
      this.ctype = message.ctype;
      this.packed = message.packed;
      this.lazy = message.lazy;
      this.deprecated = message.deprecated;
      this.experimental_map_key = message.experimental_map_key;
      this.weak = message.weak;
      this.uninterpreted_option = copyOf(message.uninterpreted_option);
    }

    /**
     * The ctype option instructs the C++ code generator to use a different
     * representation of the field than it normally would.  See the specific
     * options below.  This option is not yet implemented in the open source
     * release -- sorry, we'll try to include it in a future version!
     */
    public Builder ctype(CType ctype) {
      this.ctype = ctype;
      return this;
    }

    /**
     * The packed option can be enabled for repeated primitive fields to enable
     * a more efficient representation on the wire. Rather than repeatedly
     * writing the tag and type for each element, the entire array is encoded as
     * a single length-delimited blob.
     */
    public Builder packed(Boolean packed) {
      this.packed = packed;
      return this;
    }

    /**
     * Should this field be parsed lazily?  Lazy applies only to message-type
     * fields.  It means that when the outer message is initially parsed, the
     * inner message's contents will not be parsed but instead stored in encoded
     * form.  The inner message will actually be parsed when it is first accessed.
     *
     * This is only a hint.  Implementations are free to choose whether to use
     * eager or lazy parsing regardless of the value of this option.  However,
     * setting this option true suggests that the protocol author believes that
     * using lazy parsing on this field is worth the additional bookkeeping
     * overhead typically needed to implement it.
     *
     * This option does not affect the public interface of any generated code;
     * all method signatures remain the same.  Furthermore, thread-safety of the
     * interface is not affected by this option; const methods remain safe to
     * call from multiple threads concurrently, while non-const methods continue
     * to require exclusive access.
     *
     *
     * Note that implementations may choose not to check required fields within
     * a lazy sub-message.  That is, calling IsInitialized() on the outher message
     * may return true even if the inner message has missing required fields.
     * This is necessary because otherwise the inner message would have to be
     * parsed in order to perform the check, defeating the purpose of lazy
     * parsing.  An implementation which chooses not to check required fields
     * must be consistent about it.  That is, for any particular sub-message, the
     * implementation must either *always* check its required fields, or *never*
     * check its required fields, regardless of whether or not the message has
     * been parsed.
     */
    public Builder lazy(Boolean lazy) {
      this.lazy = lazy;
      return this;
    }

    /**
     * Is this field deprecated?
     * Depending on the target platform, this can emit Deprecated annotations
     * for accessors, or it will be completely ignored; in the very least, this
     * is a formalization for deprecating fields.
     */
    public Builder deprecated(Boolean deprecated) {
      this.deprecated = deprecated;
      return this;
    }

    /**
     * EXPERIMENTAL.  DO NOT USE.
     * For "map" fields, the name of the field in the enclosed type that
     * is the key for this map.  For example, suppose we have:
     *   message Item {
     *     required string name = 1;
     *     required string value = 2;
     *   }
     *   message Config {
     *     repeated Item items = 1 [experimental_map_key="name"];
     *   }
     * In this situation, the map key for Item will be set to "name".
     * TODO: Fully-implement this, then remove the "experimental_" prefix.
     */
    public Builder experimental_map_key(String experimental_map_key) {
      this.experimental_map_key = experimental_map_key;
      return this;
    }

    /**
     * For Google-internal migration only. Do not use.
     */
    public Builder weak(Boolean weak) {
      this.weak = weak;
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
    public <E> Builder setExtension(Extension<FieldOptions, E> extension, E value) {
      super.setExtension(extension, value);
      return this;
    }

    @Override
    public FieldOptions build() {
      return new FieldOptions(this);
    }
  }

  public enum CType
      implements ProtoEnum {
    /**
     * Default mode.
     */
    STRING(0),
    CORD(1),
    STRING_PIECE(2);

    private final int value;

    CType(int value) {
      this.value = value;
    }

    @Override
    public int getValue() {
      return value;
    }
  }
}
