FROM python:3.10 as base

WORKDIR /app

COPY pyproject.toml .
COPY requirements.txt .

RUN pip install . && rm pyproject.toml requirements.txt

ENV PYTHONPATH=/app

FROM base as github_app

ADD pr_agent pr_agent

CMD ["python", "-m", "gunicorn", "-k", "uvicorn.workers.UvicornWorker", "-c", "pr_agent/servers/gunicorn_config.py", "--forwarded-allow-ips", "*", "pr_agent.servers.github_app:app"]
