from invoke import task

@task
def status(ctx):
    ctx.run("git status")