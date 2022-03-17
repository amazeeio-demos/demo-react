FROM uselagoon/node-16-builder:latest as builder
COPY package.json package-lock.json /app/
RUN npm install

FROM uselagoon/node-16:latest
COPY --from=builder /app/node_modules /app/node_modules
COPY ./ /app/

# The API is not very resilient to sudden mariadb restarts which can happen when the api and mariadb are starting
# at the same time. So we have a small entrypoint which waits for mariadb to be fully ready.
COPY wait-for-mariadb.sh /lagoon/entrypoints/99-wait-for-mariadb.sh

WORKDIR /app/api
ENV WEBROOT=/app/api
EXPOSE 3001

CMD ["npm", "run", "start"]