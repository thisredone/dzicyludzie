FROM ruby:2.6.5-slim-buster

ENV TZ Europe/Warsaw
WORKDIR /root/code

COPY Gemfile Gemfile.lock ./
COPY /examples ./
COPY logic.rb ./

RUN touch firebase_acc.json ./
RUN apt update && apt install -y build-essential && \
    bundle install --without development 

CMD ["ruby", "logic.rb"]
 
