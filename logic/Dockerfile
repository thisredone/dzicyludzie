FROM ruby:2.6.5-slim-buster

ENV TZ Europe/Warsaw
WORKDIR /root/code
RUN touch firebase_acc.json ./

RUN apt update && apt install -y build-essential

COPY Gemfile Gemfile.lock ./

RUN bundle install --without development

COPY examples examples
COPY logic.rb .

CMD ["ruby", "logic.rb"]
