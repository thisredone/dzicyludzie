FROM node:alpine

WORKDIR /root/code
RUN touch firebase_acc.json

COPY package.json .
RUN yarn --pure-lockfile

COPY index.coffee .

CMD ["./node_modules/.bin/coffee", "."]
