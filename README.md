# Bank

Bank is a Phoenix application responsible for making transactions between accounts involving withdraw and transfer operations.

## Installation

### Using Docker

You need to change this following configuration into config/dev.exs:

From:
```
config :bank, Bank.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_dev",
  hostname: "localhost",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

To:
```
config :bank, Bank.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_dev",
  hostname: "postgres",
  show_sensitive_data_on_connection_error: true,
  pool_size: 10
```

Also change into config/test.exs:

From:
```
config :bank, Bank.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_test",
  hostname: "localhost",
  pool: Ecto.Adapters.SQL.Sandbox
```

To:
```
config :bank, Bank.Repo,
  username: "postgres",
  password: "postgres",
  database: "bank_test",
  hostname: "postgres",
  pool: Ecto.Adapters.SQL.Sandbox
```

Then run:
```bash
docker-compose up --build
```

### Without Docker
1. Clone this repository
```
git clone https://github.com/GustavoZiaugra/bank
```
2. Install **Elixir** version **1.9.4** (Oficial documentation).
```
https://elixir-lang.org/install.html
```
3. Install **Erlang** version **22.0.7** (Oficial documentation).
```
https://erlang.org/doc/installation_guide/INSTALL.html
```

4. Move to the repository directory
```
cd bank
```

5. Install dependencies
```
mix deps.get
```

6. Create a database
```
mix ecto.setup
```

7. Run Server
```
mix phx.server
```

8. Access via port 4000
```
localhost:4000
```

## Running Tests
Into the repository directory

### With Docker

After following the steps above to run the application with Docker, run:

```
docker exec -it bank_web_1 bash
```

Then, inside the container run:
```
MIX_ENV=test mix test
```

### Without Docker

```
mix test
```
## Documentation

### Without authentication.

### Endpoint:
```
POST /api/account/sign_up
```

#### Params:

```
      {
        "account" =>
        {
          "name" => name,
          "email" => email,
          "password" => password
        }
      }
```

### Response

#### 200
```
%{
  "balance" => "R$1,000.00",
  "email" => "gustavo.ziaugra@uol.com.br",
  "id" => "01c1c990-b750-42a4-9707-f12040da3f22",
  "jwt" => "token",
  "name" => "Gustavo Ziaugra"
}
```


#### 422
```
{"errors" => {"detail" => {"email" => ["can't be blank"]}}}
```

### Endpoint:
```
POST /api/account/sign_in
```

#### Params:

```
      {
        "account" =>
        {
          "email" => email,
          "password" => password
        }
      }
```

### Response

#### 200
```
{
  "jwt" => "token"
}
```
#### 401
```
{"errors" => %{"detail" => "Unauthorized"}}
```


### Basic Auth Endpoint

For these endpoints, you should auth with Basic Auth.

#### Default Credentials:
| username | bank |
|----------:|-----:|
| **password** | **password** |

### Endpoint:
```
POST /api/report/transactions
```

#### Params:
type could be this following options:
1. "by_day" -> Returns only transactions and amount from the current day.
2. "by_month" -> Returns only transactions and amount from the current month.
3. "by_year" -> Returns only transactions and amount from current year.
4. "total" -> Returns transactions and amount with no date scope.

```
{
  {
    "report" => {"type" => type}
  }
}
```

### Response

#### 200
```
{"amount" => "R$0.00", "transactions" => []}
```

#### 400
```
{"errors" => %{"detail" => "Bad Request"}}
```

### Bearer Authentication (JWT Token)
For these endpoints, you should pass an account token to make a request.

### Endpoint:
```
POST /api/transaction/create
```

#### Params:
1. operation_type -> Only accept "transfer" or "withdraw" as values.
2. amount -> Amount of operation in cents.
3. receiver_id -> Only when operation_type is transfer.

##### Transfer:
```
      {
        "transaction" =>
        {
          "operation_type" => "transfer",
          "amount" => 100000,
          "receiver_id" => "Random.uuid"
        }
      }
```

##### Withdraw:
```
      {
        "transaction" =>
        {
          "operation_type" => "withdraw",
          "amount" => 100000,
        }
      }
```

### Response

#### 200 (Transfer)
```
{
  "amount" => "R$100.00",
  "id" => "ce5318bf-4e24-4aee-b47b-6c1741927838",
  "inserted_at" => "2020-01-24T15:17:21",
  "operation_type" => "transfer",
  "payer_id" => "79845ea3-c18e-418b-8f7a-0f342c5389ba",
  "receiver_id" => "79845ea3-c18e-418b-8f7a-0f342c538123"
}
```

#### 200 (Withdraw)
```
{
  "amount" => "R$100.00",
  "id" => "097816d7-f421-4960-95bc-5fefc04164a9",
  "inserted_at" => "2020-01-24T15:18:15",
  "operation_type" => "withdraw",
  "payer_id" => "79845ea3-c18e-418b-8f7a-0f342c5389ba",
  "receiver_id" => nil
}
```

#### 422
```
"errors" => {"detail" => {"balance" => ["amount cannot be negative"]}}
```

## Deploy

Application available at:
```
https://bank-ex-show.herokuapp.com
```

## Contributing
Pull requests are welcome. For major changes, please open an issue first to discuss what you would like to change.

Please make sure to update the tests as appropriate.
