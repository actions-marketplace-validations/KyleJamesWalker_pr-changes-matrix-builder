FROM python:3.10-slim

RUN apt update && apt install -y \
    curl \
    gpg \
  && ( \
       curl -fsSL https://cli.github.com/packages/githubcli-archive-keyring.gpg | \
       gpg --dearmor -o /usr/share/keyrings/githubcli-archive-keyring.gpg ) \
  && ( \
       echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/githubcli-archive-keyring.gpg] https://cli.github.com/packages stable main" | \
       tee /etc/apt/sources.list.d/github-cli.list > /dev/null \
  ) \
  && apt update && apt install -y gh \
  && rm -rf /var/lib/apt/lists/*

WORKDIR /code

COPY setup.py setup.cfg /code/
RUN pip install -e "."
RUN pip check

COPY pr_changes/ /code/pr_changes

CMD pr_changes
