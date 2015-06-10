# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/notification/containers.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf.internal import enum_type_wrapper
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/notification/containers.proto',
  package='services.notification.containers',
  serialized_pb=_b('\n0protobufs/services/notification/containers.proto\x12 services.notification.containers\"\xde\x02\n\x13NotificationTokenV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x0f\n\x07user_id\x18\x02 \x01(\t\x12\x11\n\tdevice_id\x18\x03 \x01(\t\x12\x16\n\x0eprovider_token\x18\x04 \x01(\t\x12R\n\x08provider\x18\x05 \x01(\x0e\x32@.services.notification.containers.NotificationTokenV1.ProviderV1\x12\x63\n\x11provider_platform\x18\x06 \x01(\x0e\x32H.services.notification.containers.NotificationTokenV1.ProviderPlatformV1\"\x15\n\nProviderV1\x12\x07\n\x03SNS\x10\x00\"\'\n\x12ProviderPlatformV1\x12\x08\n\x04\x41PNS\x10\x00\x12\x07\n\x03GCM\x10\x01\"\x90\x02\n\x18NotificationPreferenceV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x12\n\nprofile_id\x18\x03 \x01(\t\x12[\n\x14notification_type_id\x18\x04 \x01(\x0e\x32=.services.notification.containers.NotificationTypeV1.TypeIdV1\x12\x12\n\nsubscribed\x18\x05 \x01(\x08\x12O\n\x11notification_type\x18\x06 \x01(\x0b\x32\x34.services.notification.containers.NotificationTypeV1\"\xcc\x01\n\x12NotificationTypeV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12I\n\x02id\x18\x02 \x01(\x0e\x32=.services.notification.containers.NotificationTypeV1.TypeIdV1\x12\x13\n\x0b\x64\x65scription\x18\x03 \x01(\t\x12\x0e\n\x06opt_in\x18\x04 \x01(\x08\x12\x13\n\x0bmobile_push\x18\x05 \x01(\x08\"\x1d\n\x08TypeIdV1\x12\x11\n\rGOOGLE_GROUPS\x10\x00\"\xe6\x02\n\x0eNotificationV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12[\n\x14notification_type_id\x18\x02 \x01(\x0e\x32=.services.notification.containers.NotificationTypeV1.TypeIdV1\x12h\n\x18group_membership_request\x18\x03 \x01(\x0b\x32\x46.services.notification.containers.GroupMembershipRequestNotificationV1\x12y\n!group_membership_request_response\x18\x04 \x01(\x0b\x32N.services.notification.containers.GroupMembershipRequestResponseNotificationV1\"k\n$GroupMembershipRequestNotificationV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x1c\n\x14requester_profile_id\x18\x02 \x01(\t\x12\x11\n\tgroup_key\x18\x03 \x01(\t\"\x89\x01\n,GroupMembershipRequestResponseNotificationV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12 \n\x18group_manager_profile_id\x18\x02 \x01(\t\x12\x10\n\x08\x61pproved\x18\x03 \x01(\x08\x12\x11\n\tgroup_key\x18\x04 \x01(\t*(\n\x15NotificationChannelV1\x12\x0f\n\x0bMOBILE_PUSH\x10\x00\x42\x37\n5com.rhlabs.protobufs.services.notification.containers')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)

_NOTIFICATIONCHANNELV1 = _descriptor.EnumDescriptor(
  name='NotificationChannelV1',
  full_name='services.notification.containers.NotificationChannelV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='MOBILE_PUSH', index=0, number=0,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=1531,
  serialized_end=1571,
)
_sym_db.RegisterEnumDescriptor(_NOTIFICATIONCHANNELV1)

NotificationChannelV1 = enum_type_wrapper.EnumTypeWrapper(_NOTIFICATIONCHANNELV1)
MOBILE_PUSH = 0


_NOTIFICATIONTOKENV1_PROVIDERV1 = _descriptor.EnumDescriptor(
  name='ProviderV1',
  full_name='services.notification.containers.NotificationTokenV1.ProviderV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='SNS', index=0, number=0,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=375,
  serialized_end=396,
)
_sym_db.RegisterEnumDescriptor(_NOTIFICATIONTOKENV1_PROVIDERV1)

_NOTIFICATIONTOKENV1_PROVIDERPLATFORMV1 = _descriptor.EnumDescriptor(
  name='ProviderPlatformV1',
  full_name='services.notification.containers.NotificationTokenV1.ProviderPlatformV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='APNS', index=0, number=0,
      options=None,
      type=None),
    _descriptor.EnumValueDescriptor(
      name='GCM', index=1, number=1,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=398,
  serialized_end=437,
)
_sym_db.RegisterEnumDescriptor(_NOTIFICATIONTOKENV1_PROVIDERPLATFORMV1)

_NOTIFICATIONTYPEV1_TYPEIDV1 = _descriptor.EnumDescriptor(
  name='TypeIdV1',
  full_name='services.notification.containers.NotificationTypeV1.TypeIdV1',
  filename=None,
  file=DESCRIPTOR,
  values=[
    _descriptor.EnumValueDescriptor(
      name='GOOGLE_GROUPS', index=0, number=0,
      options=None,
      type=None),
  ],
  containing_type=None,
  options=None,
  serialized_start=890,
  serialized_end=919,
)
_sym_db.RegisterEnumDescriptor(_NOTIFICATIONTYPEV1_TYPEIDV1)


_NOTIFICATIONTOKENV1 = _descriptor.Descriptor(
  name='NotificationTokenV1',
  full_name='services.notification.containers.NotificationTokenV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.notification.containers.NotificationTokenV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='user_id', full_name='services.notification.containers.NotificationTokenV1.user_id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='device_id', full_name='services.notification.containers.NotificationTokenV1.device_id', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='provider_token', full_name='services.notification.containers.NotificationTokenV1.provider_token', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='provider', full_name='services.notification.containers.NotificationTokenV1.provider', index=4,
      number=5, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='provider_platform', full_name='services.notification.containers.NotificationTokenV1.provider_platform', index=5,
      number=6, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _NOTIFICATIONTOKENV1_PROVIDERV1,
    _NOTIFICATIONTOKENV1_PROVIDERPLATFORMV1,
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=87,
  serialized_end=437,
)


_NOTIFICATIONPREFERENCEV1 = _descriptor.Descriptor(
  name='NotificationPreferenceV1',
  full_name='services.notification.containers.NotificationPreferenceV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.notification.containers.NotificationPreferenceV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.notification.containers.NotificationPreferenceV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='profile_id', full_name='services.notification.containers.NotificationPreferenceV1.profile_id', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='notification_type_id', full_name='services.notification.containers.NotificationPreferenceV1.notification_type_id', index=3,
      number=4, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='subscribed', full_name='services.notification.containers.NotificationPreferenceV1.subscribed', index=4,
      number=5, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='notification_type', full_name='services.notification.containers.NotificationPreferenceV1.notification_type', index=5,
      number=6, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=440,
  serialized_end=712,
)


_NOTIFICATIONTYPEV1 = _descriptor.Descriptor(
  name='NotificationTypeV1',
  full_name='services.notification.containers.NotificationTypeV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.notification.containers.NotificationTypeV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.notification.containers.NotificationTypeV1.id', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='description', full_name='services.notification.containers.NotificationTypeV1.description', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='opt_in', full_name='services.notification.containers.NotificationTypeV1.opt_in', index=3,
      number=4, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='mobile_push', full_name='services.notification.containers.NotificationTypeV1.mobile_push', index=4,
      number=5, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
    _NOTIFICATIONTYPEV1_TYPEIDV1,
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=715,
  serialized_end=919,
)


_NOTIFICATIONV1 = _descriptor.Descriptor(
  name='NotificationV1',
  full_name='services.notification.containers.NotificationV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.notification.containers.NotificationV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='notification_type_id', full_name='services.notification.containers.NotificationV1.notification_type_id', index=1,
      number=2, type=14, cpp_type=8, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group_membership_request', full_name='services.notification.containers.NotificationV1.group_membership_request', index=2,
      number=3, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group_membership_request_response', full_name='services.notification.containers.NotificationV1.group_membership_request_response', index=3,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=922,
  serialized_end=1280,
)


_GROUPMEMBERSHIPREQUESTNOTIFICATIONV1 = _descriptor.Descriptor(
  name='GroupMembershipRequestNotificationV1',
  full_name='services.notification.containers.GroupMembershipRequestNotificationV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.notification.containers.GroupMembershipRequestNotificationV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='requester_profile_id', full_name='services.notification.containers.GroupMembershipRequestNotificationV1.requester_profile_id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group_key', full_name='services.notification.containers.GroupMembershipRequestNotificationV1.group_key', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1282,
  serialized_end=1389,
)


_GROUPMEMBERSHIPREQUESTRESPONSENOTIFICATIONV1 = _descriptor.Descriptor(
  name='GroupMembershipRequestResponseNotificationV1',
  full_name='services.notification.containers.GroupMembershipRequestResponseNotificationV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.notification.containers.GroupMembershipRequestResponseNotificationV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group_manager_profile_id', full_name='services.notification.containers.GroupMembershipRequestResponseNotificationV1.group_manager_profile_id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='approved', full_name='services.notification.containers.GroupMembershipRequestResponseNotificationV1.approved', index=2,
      number=3, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='group_key', full_name='services.notification.containers.GroupMembershipRequestResponseNotificationV1.group_key', index=3,
      number=4, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
  ],
  extensions=[
  ],
  nested_types=[],
  enum_types=[
  ],
  options=None,
  is_extendable=False,
  extension_ranges=[],
  oneofs=[
  ],
  serialized_start=1392,
  serialized_end=1529,
)

_NOTIFICATIONTOKENV1.fields_by_name['provider'].enum_type = _NOTIFICATIONTOKENV1_PROVIDERV1
_NOTIFICATIONTOKENV1.fields_by_name['provider_platform'].enum_type = _NOTIFICATIONTOKENV1_PROVIDERPLATFORMV1
_NOTIFICATIONTOKENV1_PROVIDERV1.containing_type = _NOTIFICATIONTOKENV1
_NOTIFICATIONTOKENV1_PROVIDERPLATFORMV1.containing_type = _NOTIFICATIONTOKENV1
_NOTIFICATIONPREFERENCEV1.fields_by_name['notification_type_id'].enum_type = _NOTIFICATIONTYPEV1_TYPEIDV1
_NOTIFICATIONPREFERENCEV1.fields_by_name['notification_type'].message_type = _NOTIFICATIONTYPEV1
_NOTIFICATIONTYPEV1.fields_by_name['id'].enum_type = _NOTIFICATIONTYPEV1_TYPEIDV1
_NOTIFICATIONTYPEV1_TYPEIDV1.containing_type = _NOTIFICATIONTYPEV1
_NOTIFICATIONV1.fields_by_name['notification_type_id'].enum_type = _NOTIFICATIONTYPEV1_TYPEIDV1
_NOTIFICATIONV1.fields_by_name['group_membership_request'].message_type = _GROUPMEMBERSHIPREQUESTNOTIFICATIONV1
_NOTIFICATIONV1.fields_by_name['group_membership_request_response'].message_type = _GROUPMEMBERSHIPREQUESTRESPONSENOTIFICATIONV1
DESCRIPTOR.message_types_by_name['NotificationTokenV1'] = _NOTIFICATIONTOKENV1
DESCRIPTOR.message_types_by_name['NotificationPreferenceV1'] = _NOTIFICATIONPREFERENCEV1
DESCRIPTOR.message_types_by_name['NotificationTypeV1'] = _NOTIFICATIONTYPEV1
DESCRIPTOR.message_types_by_name['NotificationV1'] = _NOTIFICATIONV1
DESCRIPTOR.message_types_by_name['GroupMembershipRequestNotificationV1'] = _GROUPMEMBERSHIPREQUESTNOTIFICATIONV1
DESCRIPTOR.message_types_by_name['GroupMembershipRequestResponseNotificationV1'] = _GROUPMEMBERSHIPREQUESTRESPONSENOTIFICATIONV1
DESCRIPTOR.enum_types_by_name['NotificationChannelV1'] = _NOTIFICATIONCHANNELV1

NotificationTokenV1 = _reflection.GeneratedProtocolMessageType('NotificationTokenV1', (_message.Message,), dict(
  DESCRIPTOR = _NOTIFICATIONTOKENV1,
  __module__ = 'protobufs.services.notification.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.notification.containers.NotificationTokenV1)
  ))
_sym_db.RegisterMessage(NotificationTokenV1)

NotificationPreferenceV1 = _reflection.GeneratedProtocolMessageType('NotificationPreferenceV1', (_message.Message,), dict(
  DESCRIPTOR = _NOTIFICATIONPREFERENCEV1,
  __module__ = 'protobufs.services.notification.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.notification.containers.NotificationPreferenceV1)
  ))
_sym_db.RegisterMessage(NotificationPreferenceV1)

NotificationTypeV1 = _reflection.GeneratedProtocolMessageType('NotificationTypeV1', (_message.Message,), dict(
  DESCRIPTOR = _NOTIFICATIONTYPEV1,
  __module__ = 'protobufs.services.notification.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.notification.containers.NotificationTypeV1)
  ))
_sym_db.RegisterMessage(NotificationTypeV1)

NotificationV1 = _reflection.GeneratedProtocolMessageType('NotificationV1', (_message.Message,), dict(
  DESCRIPTOR = _NOTIFICATIONV1,
  __module__ = 'protobufs.services.notification.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.notification.containers.NotificationV1)
  ))
_sym_db.RegisterMessage(NotificationV1)

GroupMembershipRequestNotificationV1 = _reflection.GeneratedProtocolMessageType('GroupMembershipRequestNotificationV1', (_message.Message,), dict(
  DESCRIPTOR = _GROUPMEMBERSHIPREQUESTNOTIFICATIONV1,
  __module__ = 'protobufs.services.notification.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.notification.containers.GroupMembershipRequestNotificationV1)
  ))
_sym_db.RegisterMessage(GroupMembershipRequestNotificationV1)

GroupMembershipRequestResponseNotificationV1 = _reflection.GeneratedProtocolMessageType('GroupMembershipRequestResponseNotificationV1', (_message.Message,), dict(
  DESCRIPTOR = _GROUPMEMBERSHIPREQUESTRESPONSENOTIFICATIONV1,
  __module__ = 'protobufs.services.notification.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.notification.containers.GroupMembershipRequestResponseNotificationV1)
  ))
_sym_db.RegisterMessage(GroupMembershipRequestResponseNotificationV1)


DESCRIPTOR.has_options = True
DESCRIPTOR._options = _descriptor._ParseOptions(descriptor_pb2.FileOptions(), _b('\n5com.rhlabs.protobufs.services.notification.containers'))
# @@protoc_insertion_point(module_scope)