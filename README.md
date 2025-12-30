# Simple Python Name Display App

A simple Python Flask web application that displays a name, running in a Docker container.

## Features
- Displays a name in a beautiful web interface
- Runs in a Docker container
- Easy to build and deploy

## Prerequisites
- Docker installed on your system
- Basic knowledge of terminal/command line

## Project Structure
```
.
├── app.py              # Main Python application
├── requirements.txt    # Python dependencies
├── Dockerfile         # Docker configuration
└── README.md          # This file
```

## How to Build and Run

### 1. Build the Docker Image
```bash
docker build -t name-display-app .
```

### 2. Run the Docker Container
```bash
docker run -p 5000:5000 name-display-app
```

### 3. Access the Application
Open your web browser and navigate to:
```
http://localhost:5000
```

You should see a beautiful page displaying the name "Bob" with a message indicating it's running in a Docker container.

## Customization

To change the displayed name, edit the `app.py` file and modify this line:
```python
name = "Bob"  # Change "Bob" to any name you want
```

Then rebuild the Docker image and run it again.

## Stopping the Container

Press `Ctrl+C` in the terminal where the container is running, or use:
```bash
docker ps  # Find the container ID
docker stop <container-id>
```

## Additional Docker Commands

### Run container in detached mode (background)
```bash
docker run -d -p 5000:5000 --name my-name-app name-display-app
```

### View running containers
```bash
docker ps
```

### View container logs
```bash
docker logs my-name-app
```

### Stop and remove container
```bash
docker stop my-name-app
docker rm my-name-app
```

### Remove the image
```bash
docker rmi name-display-app
```

## Technologies Used
- Python 3.11
- Flask 3.0.0
- Docker

## License
Free to use and modify!