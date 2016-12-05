from invoke import (
    run,
    task,
)

from . import common

LANGUAGE = 'java'


@task
def clean():
    print 'cleaning %s...' % (LANGUAGE,)
    with common.base_directory():
        run("rm -rf %(language)s && mkdir %(language)s" % {'language': LANGUAGE})


@task(default=True)
def compile():
    print 'compiling %s...' % (LANGUAGE,)
    with common.base_directory():
        compiler = 'java -jar ~/open_source/wire/wire-compiler/target/wire-compiler-1.8.0-SNAPSHOT-jar-with-dependencies.jar'
        # wire auto adds the source directory path
        filters = " sed 's/src\///' | "
        common.compile('java_out', LANGUAGE, compiler=compiler, filters=filters)
