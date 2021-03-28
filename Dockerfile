FROM ruby:2.5.3

RUN apt-get update && apt-get install -y netcat

# Copy the application code
COPY . /app
# Change to the application's dir
WORKDIR /app
# Install gems
RUN bundle check || bundle install

ENTRYPOINT ["./entrypoints/docker-entrypoint.sh"]