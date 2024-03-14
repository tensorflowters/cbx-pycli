from invoke import task

@task
def publish(ctx):
    ctx.run("git status")
    ctx.run("git add .")
    ctx.run("git commit -m 'commit message'")