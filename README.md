# Sistema de Contas bancárias
![](https://github.com/magnumfonseca/sistema_de_contas_bancarias/workflows/CI/badge.svg)

-   Simples sistema de conta bancárias em Ruby on Rails
-   Rails 6 API com poucas depenências
-   Container Docker para que setup do ambiente seja facilitado.


## Dependencias

### JWT
Uma implementação ruby do padrão RFC 7519 OAuth JSON Web Token (JWT). ([repositório](https://github.com/jwt/ruby-jwt))

Utilizada para criar JWT para autenticaçaão da API.


## Instalação
```bash
git clone https://github.com/magnumfonseca/sistema_de_contas_bancarias.git
cd sistema_de_contas_bancarias
bundle
rails s
```

## Docker

run:
```bash
docker-compose run web rake db:create db:migrate
docker-compose up
```

## API
### Criar Conta
```bash
curl -H 'Content-Type: application/json' -d '{ "account": {"name": "account_name", "balance": "123.99"} }' -X POST 'http://localhost:3000/api/accounts'
```
### Transferência
```bash
curl -H 'Content-Type: application/json' -d '{"source_account_id": "id_da_conta_origem", "destination_account_id": "id_da_conta_destino", "amount": "9.99",}' -H "Authorization: Bearer <ACCESS_TOKEN>" -X POST 'http://localhost:3000/api/transfers'
```
### Saldo
```bash
curl -H 'Content-Type: application/json' -H "Authorization: Bearer <ACCESS_TOKEN>" -X GET 'http://localhost:3000/api/accounts/<ACCOUNT_ID>/balance'
```

