# Use the official Ubuntu base image
FROM ubuntu:latest

# Set the maintainer label
LABEL maintainer="your_name <your_email>"

# Install essential packages and dependencies
RUN apt-get update && apt-get install -y \
    python3-pip \
    python3-dev \
    python3-venv \
    build-essential \
    libsndfile1 \
    libsm6 \
    libxext6 \
    libxrender-dev \
    git \
    curl \
    gnupg \
    ca-certificates \
    software-properties-common \
    && apt-get clean

# Add NVIDIA's official package repository for CUDA 12.6
RUN curl -fsSL https://developer.download.nvidia.com/compute/cuda/repos/ubuntu2004/x86_64/cuda-keyring_1.0-1_all.deb -o /tmp/cuda-keyring.deb && \
    dpkg -i /tmp/cuda-keyring.deb && \
    rm /tmp/cuda-keyring.deb && \
    apt-get update && \
    apt-get install -y cuda-toolkit-12-6 && \
    apt-get clean

# Set the working directory
WORKDIR /app

# Create and activate a virtual environment for Python
RUN python3 -m venv /venv
ENV PATH="/venv/bin:$PATH"

# Copy the requirements.txt file
COPY requirements0.txt .
COPY requirements1.txt .
COPY requirements2.txt .
COPY requirements3.txt .

# Install Python dependencies into the virtual environment
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements0.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements1.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements2.txt
RUN pip install --no-cache-dir --upgrade pip && \
    pip install --no-cache-dir -r requirements3.txt

# Copy the rest of the application files
COPY . .

# Set the entrypoint to run the application
CMD ["python", "main.py", "--listen=0.0.0.0", "--port=8188"]
