# Generated by the protocol buffer compiler.  DO NOT EDIT!
# source: protobufs/services/resume/containers.proto

import sys
_b=sys.version_info[0]<3 and (lambda x:x) or (lambda x:x.encode('latin1'))
from google.protobuf import descriptor as _descriptor
from google.protobuf import message as _message
from google.protobuf import reflection as _reflection
from google.protobuf import symbol_database as _symbol_database
from google.protobuf import descriptor_pb2
# @@protoc_insertion_point(imports)

_sym_db = _symbol_database.Default()




DESCRIPTOR = _descriptor.FileDescriptor(
  name='protobufs/services/resume/containers.proto',
  package='services.resume.containers',
  serialized_pb=_b('\n*protobufs/services/resume/containers.proto\x12\x1aservices.resume.containers\"Q\n\x11\x41pproximateDateV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x0c\n\x04year\x18\x02 \x01(\r\x12\r\n\x05month\x18\x03 \x01(\r\x12\x0b\n\x03\x64\x61y\x18\x04 \x01(\r\"\xa7\x01\n\x08ResumeV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\x0f\n\x07user_id\x18\x02 \x01(\t\x12;\n\neducations\x18\x03 \x03(\x0b\x32\'.services.resume.containers.EducationV1\x12\x39\n\tpositions\x18\x04 \x03(\x0b\x32&.services.resume.containers.PositionV1\"\xa2\x02\n\x0b\x45\x64ucationV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x13\n\x0bschool_name\x18\x03 \x01(\t\x12\x41\n\nstart_date\x18\x04 \x01(\x0b\x32-.services.resume.containers.ApproximateDateV1\x12?\n\x08\x65nd_date\x18\x05 \x01(\x0b\x32-.services.resume.containers.ApproximateDateV1\x12\r\n\x05notes\x18\x06 \x01(\t\x12\x0f\n\x07user_id\x18\x07 \x01(\t\x12\x12\n\nactivities\x18\x08 \x01(\t\x12\x16\n\x0e\x66ield_of_study\x18\t \x01(\t\x12\x0e\n\x06\x64\x65gree\x18\n \x01(\t\"\xad\x02\n\nPositionV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\r\n\x05title\x18\x03 \x01(\t\x12\x41\n\nstart_date\x18\x04 \x01(\x0b\x32-.services.resume.containers.ApproximateDateV1\x12?\n\x08\x65nd_date\x18\x05 \x01(\x0b\x32-.services.resume.containers.ApproximateDateV1\x12\x0f\n\x07summary\x18\x06 \x01(\t\x12\x36\n\x07\x63ompany\x18\x07 \x01(\x0b\x32%.services.resume.containers.CompanyV1\x12\x0f\n\x07user_id\x18\x08 \x01(\t\x12\x12\n\nis_current\x18\t \x01(\x08\"N\n\tCompanyV1\x12\x12\n\x07version\x18\x01 \x01(\r:\x01\x31\x12\n\n\x02id\x18\x02 \x01(\t\x12\x0c\n\x04name\x18\x03 \x01(\t\x12\x13\n\x0blinkedin_id\x18\x04 \x01(\t')
)
_sym_db.RegisterFileDescriptor(DESCRIPTOR)




_APPROXIMATEDATEV1 = _descriptor.Descriptor(
  name='ApproximateDateV1',
  full_name='services.resume.containers.ApproximateDateV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.resume.containers.ApproximateDateV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='year', full_name='services.resume.containers.ApproximateDateV1.year', index=1,
      number=2, type=13, cpp_type=3, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='month', full_name='services.resume.containers.ApproximateDateV1.month', index=2,
      number=3, type=13, cpp_type=3, label=1,
      has_default_value=False, default_value=0,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='day', full_name='services.resume.containers.ApproximateDateV1.day', index=3,
      number=4, type=13, cpp_type=3, label=1,
      has_default_value=False, default_value=0,
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
  serialized_start=74,
  serialized_end=155,
)


_RESUMEV1 = _descriptor.Descriptor(
  name='ResumeV1',
  full_name='services.resume.containers.ResumeV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.resume.containers.ResumeV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='user_id', full_name='services.resume.containers.ResumeV1.user_id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='educations', full_name='services.resume.containers.ResumeV1.educations', index=2,
      number=3, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='positions', full_name='services.resume.containers.ResumeV1.positions', index=3,
      number=4, type=11, cpp_type=10, label=3,
      has_default_value=False, default_value=[],
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
  serialized_start=158,
  serialized_end=325,
)


_EDUCATIONV1 = _descriptor.Descriptor(
  name='EducationV1',
  full_name='services.resume.containers.EducationV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.resume.containers.EducationV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.resume.containers.EducationV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='school_name', full_name='services.resume.containers.EducationV1.school_name', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='start_date', full_name='services.resume.containers.EducationV1.start_date', index=3,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='end_date', full_name='services.resume.containers.EducationV1.end_date', index=4,
      number=5, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='notes', full_name='services.resume.containers.EducationV1.notes', index=5,
      number=6, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='user_id', full_name='services.resume.containers.EducationV1.user_id', index=6,
      number=7, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='activities', full_name='services.resume.containers.EducationV1.activities', index=7,
      number=8, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='field_of_study', full_name='services.resume.containers.EducationV1.field_of_study', index=8,
      number=9, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='degree', full_name='services.resume.containers.EducationV1.degree', index=9,
      number=10, type=9, cpp_type=9, label=1,
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
  serialized_start=328,
  serialized_end=618,
)


_POSITIONV1 = _descriptor.Descriptor(
  name='PositionV1',
  full_name='services.resume.containers.PositionV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.resume.containers.PositionV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.resume.containers.PositionV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='title', full_name='services.resume.containers.PositionV1.title', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='start_date', full_name='services.resume.containers.PositionV1.start_date', index=3,
      number=4, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='end_date', full_name='services.resume.containers.PositionV1.end_date', index=4,
      number=5, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='summary', full_name='services.resume.containers.PositionV1.summary', index=5,
      number=6, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='company', full_name='services.resume.containers.PositionV1.company', index=6,
      number=7, type=11, cpp_type=10, label=1,
      has_default_value=False, default_value=None,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='user_id', full_name='services.resume.containers.PositionV1.user_id', index=7,
      number=8, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='is_current', full_name='services.resume.containers.PositionV1.is_current', index=8,
      number=9, type=8, cpp_type=7, label=1,
      has_default_value=False, default_value=False,
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
  serialized_start=621,
  serialized_end=922,
)


_COMPANYV1 = _descriptor.Descriptor(
  name='CompanyV1',
  full_name='services.resume.containers.CompanyV1',
  filename=None,
  file=DESCRIPTOR,
  containing_type=None,
  fields=[
    _descriptor.FieldDescriptor(
      name='version', full_name='services.resume.containers.CompanyV1.version', index=0,
      number=1, type=13, cpp_type=3, label=1,
      has_default_value=True, default_value=1,
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='id', full_name='services.resume.containers.CompanyV1.id', index=1,
      number=2, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='name', full_name='services.resume.containers.CompanyV1.name', index=2,
      number=3, type=9, cpp_type=9, label=1,
      has_default_value=False, default_value=_b("").decode('utf-8'),
      message_type=None, enum_type=None, containing_type=None,
      is_extension=False, extension_scope=None,
      options=None),
    _descriptor.FieldDescriptor(
      name='linkedin_id', full_name='services.resume.containers.CompanyV1.linkedin_id', index=3,
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
  serialized_start=924,
  serialized_end=1002,
)

_RESUMEV1.fields_by_name['educations'].message_type = _EDUCATIONV1
_RESUMEV1.fields_by_name['positions'].message_type = _POSITIONV1
_EDUCATIONV1.fields_by_name['start_date'].message_type = _APPROXIMATEDATEV1
_EDUCATIONV1.fields_by_name['end_date'].message_type = _APPROXIMATEDATEV1
_POSITIONV1.fields_by_name['start_date'].message_type = _APPROXIMATEDATEV1
_POSITIONV1.fields_by_name['end_date'].message_type = _APPROXIMATEDATEV1
_POSITIONV1.fields_by_name['company'].message_type = _COMPANYV1
DESCRIPTOR.message_types_by_name['ApproximateDateV1'] = _APPROXIMATEDATEV1
DESCRIPTOR.message_types_by_name['ResumeV1'] = _RESUMEV1
DESCRIPTOR.message_types_by_name['EducationV1'] = _EDUCATIONV1
DESCRIPTOR.message_types_by_name['PositionV1'] = _POSITIONV1
DESCRIPTOR.message_types_by_name['CompanyV1'] = _COMPANYV1

ApproximateDateV1 = _reflection.GeneratedProtocolMessageType('ApproximateDateV1', (_message.Message,), dict(
  DESCRIPTOR = _APPROXIMATEDATEV1,
  __module__ = 'protobufs.services.resume.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.resume.containers.ApproximateDateV1)
  ))
_sym_db.RegisterMessage(ApproximateDateV1)

ResumeV1 = _reflection.GeneratedProtocolMessageType('ResumeV1', (_message.Message,), dict(
  DESCRIPTOR = _RESUMEV1,
  __module__ = 'protobufs.services.resume.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.resume.containers.ResumeV1)
  ))
_sym_db.RegisterMessage(ResumeV1)

EducationV1 = _reflection.GeneratedProtocolMessageType('EducationV1', (_message.Message,), dict(
  DESCRIPTOR = _EDUCATIONV1,
  __module__ = 'protobufs.services.resume.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.resume.containers.EducationV1)
  ))
_sym_db.RegisterMessage(EducationV1)

PositionV1 = _reflection.GeneratedProtocolMessageType('PositionV1', (_message.Message,), dict(
  DESCRIPTOR = _POSITIONV1,
  __module__ = 'protobufs.services.resume.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.resume.containers.PositionV1)
  ))
_sym_db.RegisterMessage(PositionV1)

CompanyV1 = _reflection.GeneratedProtocolMessageType('CompanyV1', (_message.Message,), dict(
  DESCRIPTOR = _COMPANYV1,
  __module__ = 'protobufs.services.resume.containers_pb2'
  # @@protoc_insertion_point(class_scope:services.resume.containers.CompanyV1)
  ))
_sym_db.RegisterMessage(CompanyV1)


# @@protoc_insertion_point(module_scope)