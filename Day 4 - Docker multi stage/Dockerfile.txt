FROM node:14-alpine AS builder
WORKDIR /app
COPY package*.json ./
RUN --mount=type=cache,target=/root/.npm \
    npm install
COPY . .
RUN npm run build 

FROM node:14-alpine AS production
WORKDIR /app
COPY --from=builder /app . 
RUN adduser -D user && chown -R user:user /app
USER user
EXPOSE 3000
CMD ["npm", "start"]
HEALTHCHECK --interval=30s --timeout=30s --start-period=5s --retries=3 CMD [ "node", "healthcheck.js" ]

