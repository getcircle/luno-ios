// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/protobufs/services/feed/containers.proto
package com.rhlabs.protobufs.services.feed.containers;

import com.rhlabs.protobufs.services.note.containers.NoteV1;
import com.rhlabs.protobufs.services.organization.containers.AddressV1;
import com.rhlabs.protobufs.services.organization.containers.LocationV1;
import com.rhlabs.protobufs.services.organization.containers.TeamV1;
import com.rhlabs.protobufs.services.profile.containers.ProfileV1;
import com.rhlabs.protobufs.services.profile.containers.TagV1;
import com.squareup.wire.Message;
import com.squareup.wire.ProtoEnum;
import com.squareup.wire.ProtoField;
import java.util.Collections;
import java.util.List;

import static com.squareup.wire.Message.Datatype.ENUM;
import static com.squareup.wire.Message.Datatype.STRING;
import static com.squareup.wire.Message.Datatype.UINT32;
import static com.squareup.wire.Message.Label.REPEATED;

public final class CategoryV1 extends Message {
  private static final long serialVersionUID = 0L;

  public static final Integer DEFAULT_VERSION = 1;
  public static final String DEFAULT_TITLE = "";
  public static final String DEFAULT_CONTENT_KEY = "";
  public static final CategoryTypeV1 DEFAULT_CATEGORY_TYPE = CategoryTypeV1.DIRECT_REPORTS;
  public static final Integer DEFAULT_TOTAL_COUNT = 0;
  public static final List<ProfileV1> DEFAULT_PROFILES = Collections.emptyList();
  public static final List<AddressV1> DEFAULT_ADDRESSES = Collections.emptyList();
  public static final List<TagV1> DEFAULT_TAGS = Collections.emptyList();
  public static final List<TeamV1> DEFAULT_TEAMS = Collections.emptyList();
  public static final List<NoteV1> DEFAULT_NOTES = Collections.emptyList();
  public static final List<LocationV1> DEFAULT_LOCATIONS = Collections.emptyList();

  @ProtoField(tag = 1, type = UINT32)
  public final Integer version;

  @ProtoField(tag = 2, type = STRING)
  public final String title;

  @ProtoField(tag = 3, type = STRING)
  public final String content_key;

  @ProtoField(tag = 4, type = ENUM)
  public final CategoryTypeV1 category_type;

  @ProtoField(tag = 5, type = UINT32)
  public final Integer total_count;

  @ProtoField(tag = 6, label = REPEATED, messageType = ProfileV1.class)
  public final List<ProfileV1> profiles;

  @ProtoField(tag = 7, label = REPEATED, messageType = AddressV1.class)
  public final List<AddressV1> addresses;

  @ProtoField(tag = 8, label = REPEATED, messageType = TagV1.class)
  public final List<TagV1> tags;

  @ProtoField(tag = 9, label = REPEATED, messageType = TeamV1.class)
  public final List<TeamV1> teams;

  @ProtoField(tag = 10, label = REPEATED, messageType = NoteV1.class)
  public final List<NoteV1> notes;

  @ProtoField(tag = 11, label = REPEATED, messageType = LocationV1.class)
  public final List<LocationV1> locations;

  public CategoryV1(Integer version, String title, String content_key, CategoryTypeV1 category_type, Integer total_count, List<ProfileV1> profiles, List<AddressV1> addresses, List<TagV1> tags, List<TeamV1> teams, List<NoteV1> notes, List<LocationV1> locations) {
    this.version = version;
    this.title = title;
    this.content_key = content_key;
    this.category_type = category_type;
    this.total_count = total_count;
    this.profiles = immutableCopyOf(profiles);
    this.addresses = immutableCopyOf(addresses);
    this.tags = immutableCopyOf(tags);
    this.teams = immutableCopyOf(teams);
    this.notes = immutableCopyOf(notes);
    this.locations = immutableCopyOf(locations);
  }

  private CategoryV1(Builder builder) {
    this(builder.version, builder.title, builder.content_key, builder.category_type, builder.total_count, builder.profiles, builder.addresses, builder.tags, builder.teams, builder.notes, builder.locations);
    setBuilder(builder);
  }

  @Override
  public boolean equals(Object other) {
    if (other == this) return true;
    if (!(other instanceof CategoryV1)) return false;
    CategoryV1 o = (CategoryV1) other;
    return equals(version, o.version)
        && equals(title, o.title)
        && equals(content_key, o.content_key)
        && equals(category_type, o.category_type)
        && equals(total_count, o.total_count)
        && equals(profiles, o.profiles)
        && equals(addresses, o.addresses)
        && equals(tags, o.tags)
        && equals(teams, o.teams)
        && equals(notes, o.notes)
        && equals(locations, o.locations);
  }

  @Override
  public int hashCode() {
    int result = hashCode;
    if (result == 0) {
      result = version != null ? version.hashCode() : 0;
      result = result * 37 + (title != null ? title.hashCode() : 0);
      result = result * 37 + (content_key != null ? content_key.hashCode() : 0);
      result = result * 37 + (category_type != null ? category_type.hashCode() : 0);
      result = result * 37 + (total_count != null ? total_count.hashCode() : 0);
      result = result * 37 + (profiles != null ? profiles.hashCode() : 1);
      result = result * 37 + (addresses != null ? addresses.hashCode() : 1);
      result = result * 37 + (tags != null ? tags.hashCode() : 1);
      result = result * 37 + (teams != null ? teams.hashCode() : 1);
      result = result * 37 + (notes != null ? notes.hashCode() : 1);
      result = result * 37 + (locations != null ? locations.hashCode() : 1);
      hashCode = result;
    }
    return result;
  }

  public static final class Builder extends Message.Builder<CategoryV1> {

    public Integer version;
    public String title;
    public String content_key;
    public CategoryTypeV1 category_type;
    public Integer total_count;
    public List<ProfileV1> profiles;
    public List<AddressV1> addresses;
    public List<TagV1> tags;
    public List<TeamV1> teams;
    public List<NoteV1> notes;
    public List<LocationV1> locations;

    public Builder() {
    }

    public Builder(CategoryV1 message) {
      super(message);
      if (message == null) return;
      this.version = message.version;
      this.title = message.title;
      this.content_key = message.content_key;
      this.category_type = message.category_type;
      this.total_count = message.total_count;
      this.profiles = copyOf(message.profiles);
      this.addresses = copyOf(message.addresses);
      this.tags = copyOf(message.tags);
      this.teams = copyOf(message.teams);
      this.notes = copyOf(message.notes);
      this.locations = copyOf(message.locations);
    }

    public Builder version(Integer version) {
      this.version = version;
      return this;
    }

    public Builder title(String title) {
      this.title = title;
      return this;
    }

    public Builder content_key(String content_key) {
      this.content_key = content_key;
      return this;
    }

    public Builder category_type(CategoryTypeV1 category_type) {
      this.category_type = category_type;
      return this;
    }

    public Builder total_count(Integer total_count) {
      this.total_count = total_count;
      return this;
    }

    public Builder profiles(List<ProfileV1> profiles) {
      this.profiles = checkForNulls(profiles);
      return this;
    }

    public Builder addresses(List<AddressV1> addresses) {
      this.addresses = checkForNulls(addresses);
      return this;
    }

    public Builder tags(List<TagV1> tags) {
      this.tags = checkForNulls(tags);
      return this;
    }

    public Builder teams(List<TeamV1> teams) {
      this.teams = checkForNulls(teams);
      return this;
    }

    public Builder notes(List<NoteV1> notes) {
      this.notes = checkForNulls(notes);
      return this;
    }

    public Builder locations(List<LocationV1> locations) {
      this.locations = checkForNulls(locations);
      return this;
    }

    @Override
    public CategoryV1 build() {
      return new CategoryV1(this);
    }
  }

  public enum CategoryTypeV1
      implements ProtoEnum {
    DIRECT_REPORTS(1),
    ANNIVERSARIES(2),
    BIRTHDAYS(3),
    LOCATIONS(4),
    INTERESTS(5),
    PEERS(6),
    NEW_HIRES(7),
    DEPARTMENTS(8),
    EXECUTIVES(9),
    ORGANIZATION(10),
    NOTES(11),
    SKILLS(12);

    private final int value;

    private CategoryTypeV1(int value) {
      this.value = value;
    }

    @Override
    public int getValue() {
      return value;
    }
  }
}
