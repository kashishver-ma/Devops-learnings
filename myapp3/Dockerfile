# Step 1: Use Node.js base image
FROM node:18

# Step 2: Set working directory
WORKDIR /app

# Step 3: Copy package.json and install dependencies
COPY package*.json ./
RUN npm install

# Step 4: Copy the rest of the project files
COPY . .

# Step 5: Build Next.js app
# (Here .env.production will be used if it exists during build)
RUN npm run build

# Step 6: Expose port 3000
EXPOSE 3000

# Step 7: Start Next.js app
CMD ["npm", "start"]
