FROM node:10.15.0 as build
RUN mkdir /usr/src/app
WORKDIR /usr/src/app
ENV PATH /usr/src/app/node_modules/.bin:$PATH
COPY package.json /usr/src/app/package.json
RUN npm install --silent
COPY . /usr/src/app
RUN npm install -g webpack
RUN webpack

FROM nginx:1.15.8-alpine-perl AS runtime
COPY --from=build /usr/src/app/dist /usr/share/nginx/html
EXPOSE 80
CMD ["nginx", "-g", "daemon off;"]