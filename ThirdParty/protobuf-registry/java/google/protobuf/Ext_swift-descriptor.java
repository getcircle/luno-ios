// Code generated by Wire protocol buffer compiler, do not edit.
// Source file: ./src/google/protobuf/swift-descriptor.proto
package google.protobuf;

import com.google.protobuf.FileOptions;
import com.squareup.wire.Extension;

public final class Ext_swift-descriptor {

  private Ext_swift-descriptor() {
  }

  public static final Extension<FileOptions , google.protobuf.SwiftFileOptions> swift_file_options = Extension
      .messageExtending(google.protobuf.SwiftFileOptions.class, FileOptions.class)
      .setName("google.protobuf.swift_file_options")
      .setTag(5092014)
      .buildOptional();
}