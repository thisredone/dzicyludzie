FROM ruby:2.5-alpine3.8

ENV TZ Europe/Warsaw
WORKDIR /root/code

COPY Gemfile Gemfile.lock ./
COPY /examples ./
COPY logic.rb ./

RUN touch firebase_acc.json ./
RUN apk add --virtual build_deps build-base && \
    bundle install --without development && \
    apk del build_deps && \
    rm -f /var/cache/apk/*

CMD ["ruby", "logic.rb"]
 