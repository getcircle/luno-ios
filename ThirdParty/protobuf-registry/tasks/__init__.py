from invoke import (
    Collection,
    task,
)

from . import (
    go,
    java,
    python,
    release,
    rewrite,
    swift,
)


@task(post=[python.compile, swift.compile])
def compile():
    print 'compiling protobufs...'


@task(pre=[compile], post=[release.release], aliases=('release',))
def full_release():
    pass


ns = Collection()
ns.add_collection(go)
ns.add_collection(java)
ns.add_collection(python)
ns.add_collection(release)
ns.add_collection(swift)
ns.add_collection(rewrite)

ns.add_task(compile)
ns.add_task(full_release)
