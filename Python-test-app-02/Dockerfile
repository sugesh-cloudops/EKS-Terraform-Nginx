# ---- Stage 1: Build stage ----
    FROM python:3.9-slim AS builder

    # Prevents .pyc files and ensures logs are immediately flushed
    ENV PYTHONDONTWRITEBYTECODE=1 \
        PYTHONUNBUFFERED=1
    
    # Install build dependencies
    RUN apt-get update && apt-get install -y --no-install-recommends \
        build-essential \
        && rm -rf /var/lib/apt/lists/*
    
    # Set working directory
    WORKDIR /install
    
    # Install Python dependencies into a temp location
    RUN pip install --no-cache-dir flask --target=/install
    
    # ---- Stage 2: Final stage ----
    FROM python:3.9-slim
    
    # Add a non-root user
    RUN useradd -m appuser
    
    # Create working directory
    WORKDIR /app
    
    # Copy only the necessary files from the builder stage
    COPY --from=builder /install /usr/local/lib/python3.9/site-packages/
    COPY app.py .
    
    # Change to non-root user
    USER appuser
    
    # Expose the port
    EXPOSE 8080
    
    # Start the application
    CMD ["python", "app.py"]