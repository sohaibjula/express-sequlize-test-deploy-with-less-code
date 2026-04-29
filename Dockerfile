FROM node:20-alpine

WORKDIR /app

COPY package*.json ./
RUN npm install --production

COPY dist-obfuscated ./dist

CMD ["node", "dist/app.js"]