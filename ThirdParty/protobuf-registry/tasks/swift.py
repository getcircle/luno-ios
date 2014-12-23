from contextlib import contextmanager
import os
from invoke import run, task
from . import common

LANGUAGE_DIRECTORY = 'swift/ProtobufRegistry/ProtobufRegistry'


@contextmanager
def swift_directory():
    current_path = os.getcwd()
    target_path = os.path.join(
        os.path.dirname(os.path.abspath(os.path.join(__file__, '../'))),
        LANGUAGE_DIRECTORY,
    )
    os.chdir(target_path)
    yield
    os.chdir(current_path)


@task
def clean():
    print 'cleaning swift...'
    with swift_directory():
        run("find . -name '*.swift*' | xargs rm")


@task(default=True)
def compile():
    print 'compiling swift...'
    with common.base_directory():
        common.compile(
            'swift_out',
            '%s/' % (LANGUAGE_DIRECTORY,),
            filters='grep -v ThirdParty | ',
        )
