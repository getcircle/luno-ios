from contextlib import contextmanager
import os

from invoke import (
    run,
    task,
)

from . import common

PYTHON_DIRECTORY = 'python'
PACKAGE_NAME = 'protobufs'


@contextmanager
def python_directory():
    current_path = os.getcwd()
    target_path = os.path.join(
        os.path.dirname(os.path.abspath(os.path.join(__file__, '../'))),
        PYTHON_DIRECTORY,
    )
    os.chdir(target_path)
    yield
    os.chdir(current_path)


@task(aliases=['init'])
def ensure_init_exists():
    with python_directory():
        for root, dirs, files in os.walk(PACKAGE_NAME):
            if '__init__.py' not in files:
                path = os.path.join(root, '__init__.py')
                open(path, 'a').close()


@task
def clean():
    print 'cleaning python...'
    with python_directory():
        run("find %s -name '*.py*' | xargs rm" % (PACKAGE_NAME,))


@task(post=[ensure_init_exists], default=True)
def compile():
    print 'compiling python...'
    with common.base_directory():
        common.compile('python_out', 'python/')
