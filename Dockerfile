# Use Ubuntu 20.04 as the base image
FROM ubuntu:20.04

# Set environment variables to avoid interactive prompts during package installation
ENV DEBIAN_FRONTEND=noninteractive

RUN apt-get update; apt-get clean

# Install xvfb and other stuff.
RUN apt-get install -y xvfb fluxbox wget wmctrl gnupg2

# Set the Chrome repo.
RUN wget -q -O - https://dl-ssl.google.com/linux/linux_signing_key.pub | apt-key add - \
    && echo "deb http://dl.google.com/linux/chrome/deb/ stable main" >> /etc/apt/sources.list.d/google.list

# Install Chrome.
RUN apt-get update && apt-get -y install google-chrome-stable

RUN apt-get update && \
    apt-get install -y \
    curl \
    g++ \
    make \
    cmake \
    unzip \
    libcurl4-openssl-dev \
    python3.8 \
    python3-pip \
    && apt-get clean


# Install AWS Lambda Python Runtime Interface Client
RUN pip3 install awslambdaric

# Add Lambda Runtime Interface Emulator
ADD https://github.com/aws/aws-lambda-runtime-interface-emulator/releases/latest/download/aws-lambda-rie /usr/local/bin/aws-lambda-rie
RUN chmod 755 /usr/local/bin/aws-lambda-rie

# Copy the bootstrap script
COPY bootstrap.sh /bootstrap.sh
RUN chmod 755 /bootstrap.sh

# Set the working directory
WORKDIR /var/task

# Copy the function code
COPY app/* /var/task/

# Set the entrypoint to the bootstrap script
ENTRYPOINT [ "/bootstrap.sh" ]

# Set the default command to the function handler
CMD [ "app.handler" ]