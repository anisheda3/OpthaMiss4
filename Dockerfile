# ---------- FRONTEND BUILD ----------
FROM node:18 AS frontend-builder

WORKDIR /app/frontend

COPY frontend/package*.json ./
RUN npm install

COPY frontend/ .
RUN npm run build


# ---------- BACKEND ----------
FROM python:3.10

# create user
RUN useradd -m -u 1000 user

# Add .local/bin to PATH for pip-installed scripts
USER user
ENV PATH="/home/user/.local/bin:$PATH"
# Prevent Python from buffering stdout/stderr
ENV PYTHONUNBUFFERED=1

WORKDIR /app

# install python deps
COPY --chown=user backend/requirements.txt .
RUN pip install --no-cache-dir --user -r requirements.txt

# copy backend code first (without large files)
COPY --chown=user backend/main.py .
COPY --chown=user backend/model.py .
COPY --chown=user backend/train.py .
COPY --chown=user backend/requirements.txt .
COPY --chown=user backend/runtime.txt .
COPY --chown=user backend/render-build.sh .

# Copy model checkpoint - use the one in backend/ directory
COPY --chown=user backend/best.pth ./best.pth

# Copy model checkpoint directory (needed for Docker path resolution)
COPY --chown=user experiments/ ./experiments/

# copy frontend build
COPY --from=frontend-builder /app/frontend/dist ./static

# expose port
EXPOSE 10000

CMD ["uvicorn", "main:app", "--host", "0.0.0.0", "--port", "10000"]