FROM ruby:2.5-alpine3.8

ENV TZ Europe/Warsaw

COPY Gemfile Gemfile.lock ./
COPY /examples ./
COPY logic.rb ./

RUN touch firebase_acc.json ./
RUN bundle install

CMD ["ruby", "logic.rb"]
 