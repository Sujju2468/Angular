# Use the official Node.js image as a build stage
FROM node:18 AS build

# Set the working directory
WORKDIR /app

# Copy package.json and package-lock.json
COPY package*.json ./

# Install dependencies
RUN npm install

# Copy the rest of the application code
COPY . .

# Build the Angular app
RUN npm run build --prod

# Use a lightweight server for serving the Angular app
FROM nginx:alpine

# Copy built artifacts from the build stage to nginx
COPY --from=build /app/dist/angular-conduit /usr/share/nginx/html

# Expose the default port for nginx
EXPOSE 80

# Start nginx server
CMD ["nginx", "-g", "daemon off;"]
