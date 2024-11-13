FROM ruby:2.7.7

ENV RAILS_ROOT /var/www/app
ENV RAILS_ENV 'development'
ENV RACK_ENV 'development'

# Instale dependências do sistema, incluindo Node.js e PostgreSQL client, que são comuns para aplicações Rails.
RUN apt-get update -qq && apt-get install -y nodejs postgresql-client

# Crie e defina o diretório de trabalho
WORKDIR /app

# Copie o Gemfile e o Gemfile.lock para o container e instale as dependências, é algo nessesário para trabalhar com ruby
COPY Gemfile Gemfile.lock ./
RUN bundle install

# Copie todo o código da aplicação para o container
COPY . .

# Exponha a porta usada pela aplicação (exemplo: 3000 para Rails)
EXPOSE 3000

# Configurar um ponto de entrada para contornar possíveis problemas de cache
COPY entrypoint.sh /usr/bin/
RUN chmod +x /usr/bin/entrypoint.sh
ENTRYPOINT ["entrypoint.sh"]

# Comando para iniciar o servidor (ajuste conforme o framework Ruby utilizado)
CMD ["rails", "server", "-b", "0.0.0.0"]
