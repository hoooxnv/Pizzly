FROM node:alpine
RUN apk --no-cache add ca-certificates postgresql-client
RUN mkdir /home/node/app && chown -R node:node /home/node/app
WORKDIR /home/node/app

COPY ./package.json ./
COPY ./yarn.lock ./
RUN yarn install --unsafe-perm --production=true --prefer-offline && yarn cache clean

COPY --chown=node:node dist ./dist
COPY --chown=node:node views ./views
COPY --chown=node:node wait-for-postgres.sh .
RUN chmod +x wait-for-postgres.sh

USER node
EXPOSE 8080

#CMD ["node", "dist/src"]
CMD ["./wait-for-postgres.sh", "node", "dist/src"]


