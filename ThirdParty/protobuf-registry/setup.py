import os
import re

from setuptools import (
    find_packages,
    setup,
)

version_re = re.compile(r"__version__\s*=\s*['\"](.*?)['\"]")


def get_version():
    base = os.path.abspath(os.path.dirname(__file__))
    with open(os.path.join(base, 'python/protobufs/__init__.py')) as initf:
        for line in initf:
            m = version_re.match(line.strip())
            if not m:
                continue
            return m.groups()[0]

requirements = [
    'protobuf-soa>=0.1.1',
    'protobuf==2.6.1',
]

setup(
    name='protobufs',
    package_dir={'': 'python'},
    version=get_version(),
    description='python SOA service',
    packages=find_packages('python', exclude=[
        "*.tests",
        "*.tests.*",
        "tests.*",
        "tests",
    ]),
    install_requires=requirements,
    dependency_links=[
        'git+ssh://git@github.com/getcircle/protobuf-soa.git#egg=protobuf-soa-0.1.1',
    ],
)
