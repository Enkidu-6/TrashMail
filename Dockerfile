# Start with the official MongoDB image
FROM mongo:latest

# Install Node.js and Git
RUN apt-get update && \
    apt-get install -y curl gnupg git && \
    curl -sL https://deb.nodesource.com/setup_18.x | bash - && \
    apt-get install -y nodejs

# Install yarn globally
RUN npm install -g yarn

# Install pm2 globally
RUN yarn global add pm2

# Copy in package.json files and run install to allow docker to cache them
COPY react/package.json /Trashmail/react/
COPY react/yarn.lock /Trashmail/react/
WORKDIR /Trashmail/react
RUN yarn install

COPY mailserver/package.json /Trashmail/mailserver/
COPY mailserver/yarn.lock /Trashmail/mailserver/
WORKDIR /Trashmail/mailserver
RUN yarn install

# Copy the rest of the application code
COPY . /Trashmail

WORKDIR /Trashmail/react
RUN yarn build 
RUN rm -rf ../mailserver/build/* && mkdir -p ../mailserver/build && cp -r build/* ../mailserver/build/

# Define mountable volume
VOLUME ["/Trashmail/mailserver/attachments"]

# Copy startup script
COPY docker_start.sh /docker_start.sh
RUN chmod +x /docker_start.sh

# Set the health check
COPY healthcheck.sh /healthcheck.sh
RUN chmod +x /healthcheck.sh

HEALTHCHECK --interval=30s --timeout=10s --start-period=5s --retries=3 \
  CMD /healthcheck.sh

# Set the command to start the application using the startup script
CMD ["/docker_start.sh"]
