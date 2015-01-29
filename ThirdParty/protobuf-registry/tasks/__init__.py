from invoke import (
    Collection,
    run,
    task,
)

from . import (
    python,
    release,
    swift,
)


@task(post=[python.compile, swift.compile])
def compile():
    print 'compiling protobufs...'


@task(pre=[compile], post=[release.release], aliases=('release',))
def full_release():
    pass


@task
def develop():
    run('git clone git@github.com:getcircle/protobuf-soa.git src/service_protobufs')


ns = Collection()
ns.add_collection(python)
ns.add_collection(release)
ns.add_collection(swift)

ns.add_task(compile)
ns.add_task(full_release)
ns.add_task(develop)
