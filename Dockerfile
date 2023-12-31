FROM ruby:2.7

RUN apt-get update -qq && apt-get install -y \
  build-essential \
  libpq-dev \
  tesseract-ocr

WORKDIR /app
COPY . /app

RUN bundle install
