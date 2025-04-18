# Use a lightweight official Python 3.9 image as the base
FROM python:3.9-slim

# Set the working directory inside the container
WORKDIR /app

# Copy requirements and install dependencies
COPY requirements.txt ./
RUN pip install --no-cache-dir -r requirements.txt

# Copy the rest of the application files into the container
COPY . .

# Expose the port the Flask app will listen on
EXPOSE 7877

# Define the default command to run the application
CMD ["python", "nmcontroller.py"]
