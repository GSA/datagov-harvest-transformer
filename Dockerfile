FROM ruby:3.2.5

RUN apt-get update -q 

ADD . ./mdtranslator

WORKDIR /mdtranslator

RUN bundle install

RUN rails g scaffold translate file:binary reader:string writer:string
RUN rails db:migrate RAILS_ENV=development

EXPOSE 3000

CMD ["rails", "server", "-b", "0.0.0.0", "-p", "3000"]