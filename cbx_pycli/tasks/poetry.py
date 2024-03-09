from invoke import task

@task
def install(ctx):
    ctx.run("poetry list")