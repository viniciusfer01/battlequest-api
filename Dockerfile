# Use the official Ruby image as a base.
FROM ruby:3.3.2

# Set environment variables for the container.
ENV LANG C.UTF-8
ENV RAILS_LOG_TO_STDOUT=true \
    BUNDLE_PATH=/bundle

# Install essential system dependencies.
# Replaced postgresql-client with libsqlite3-dev.
RUN apt-get update -qq && apt-get install -y --no-install-recommends \
    build-essential \
    libsqlite3-dev \
    nodejs \
    npm

# Set the working directory inside the container.
WORKDIR /app

# Copy your Gemfile and Gemfile.lock to the container.
COPY Gemfile Gemfile.lock ./

# Install your application's gems.
RUN bundle install

# The entrypoint script is executed when the container starts.
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Expose port 3000 to allow access to the Rails server.
EXPOSE 3000

# The main command to run when the container starts.
CMD ["rails", "server", "-b", "0.0.0.0"]
