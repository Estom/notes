FROM node:20-alpine
RUN npm install -g docsify-cli@latest
WORKDIR /docs
COPY . .
EXPOSE 3000
CMD ["docsify", "serve", ".", "--port", "3000"]