# ---- Base Image (Minimal & Trusted) ----
FROM python:3.12-slim AS runtime


# ---- Security: Disable root ----
RUN groupadd -r appuser && useradd -r -g appuser appuser


# ---- OS Hardening ----
RUN apt-get update \
&& apt-get install -y --no-install-recommends ca-certificates \
&& rm -rf /var/lib/apt/lists/*


# ---- App Directory ----
WORKDIR /app


# ---- Dependencies ----
COPY requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt


# ---- Application Code ----
COPY --chown=appuser:appuser . .


# ---- Switch User ----
USER appuser


# ---- Runtime ----
EXPOSE 8000
CMD ["python", "app.py"]
