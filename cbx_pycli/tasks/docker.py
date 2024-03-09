from invoke import task

@task
def build(ctx):
    ctx.run("docker ps")