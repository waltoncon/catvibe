# dependency prep stage
FROM endeveit/docker-jq AS dependency-stage
COPY package.json /tmp
RUN jq '{ dependencies, devDependencies, peerDependencies, scripts: (.scripts | { postinstall }) }' < /tmp/package.json > /tmp/deps.json

# build stage
FROM node:lts-alpine as build-stage
WORKDIR /app
COPY --from=dependency-stage /tmp/deps.json ./package.json
COPY yarn.lock ./
RUN yarn install
COPY . .
RUN yarn build

# production stage
FROM nginx:stable-alpine as production-stage
COPY --from=build-stage /app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]