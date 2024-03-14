from invoke import task

@task
def build(ctx, compose_file: str = "docker-compose.yml", project: str = "echo $(pwd | awk -F/ '{print $NF}')", env: str = ".env"):
    ctx.run(f"docker compose -f {compose_file} -p {project} --env-file {env} build --no-cache")

@task
def start(ctx, compose_file: str = "docker-compose.yml", project: str = "echo $(pwd | awk -F/ '{print $NF}')", env: str = ".env"):
    ctx.run(f"docker compose -f {compose_file} -p {project} --env-file {env} up --build -d")

@task
def stop(ctx, compose_file: str = "docker-compose.yml", project: str = "echo $(pwd | awk -F/ '{print $NF}')", env: str = ".env"):
    ctx.run(f"docker compose -f {compose_file} -p {project} --env-file {env} stop")

@task
def remove(ctx, compose_file: str = "docker-compose.yml", project: str = "echo $(pwd | awk -F/ '{print $NF}')", env: str = ".env"):
    ctx.run(f"docker compose -f {compose_file} -p {project} --env-file {env} down -v --remove-orphans")

@task
def clean(ctx, compose_file: str = "docker-compose.yml", project: str = "echo $(pwd | awk -F/ '{print $NF}')", env: str = ".env"):
    ctx.run(f"docker compose -f {compose_file} -p {project} --env-file {env} down -v --remove-orphans")
    ctx.run(f"docker system prune -f")