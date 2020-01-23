defmodule BankWeb.Api.TransactionControllerTest do
  use BankWeb.ConnCase
  alias Bank.Fixtures
  alias Bank.Fixtures
  alias Bank.Guardian

  defp using_token_auth(conn, account) do
    {:ok, token, _} = Guardian.encode_and_sign(account, %{}, token_type: :access)

    conn
    |> put_req_header("authorization", "bearer: " <> token)
  end

  describe "create/2" do
    test "create a new transaction(transfer)", %{
      conn: conn
    } do
      joe = Fixtures.Accounts.account(:joe)
      maria = Fixtures.Accounts.account(:maria)

      params =
        %{
          "transaction" => %{
            "operation_type" => "transfer",
            "amount" => 100 * 100,
            "receiver_id" => maria.id
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> using_token_auth(joe)
        |> post("/api/transaction/create", params)
        |> json_response(200)

      assert response["amount"] == "R$100.00"
      assert response["operation_type"] == "transfer"
      assert Map.has_key?(response, "payer_id") == true
      assert Map.has_key?(response, "id") == true
      assert Map.has_key?(response, "receiver_id") == true
      assert Map.has_key?(response, "inserted_at") == true
    end

    test "create a new transaction(withdraw)", %{
      conn: conn
    } do
      joe = Fixtures.Accounts.account(:joe)

      params =
        %{
          "transaction" => %{
            "operation_type" => "withdraw",
            "amount" => 100 * 100
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> using_token_auth(joe)
        |> post("/api/transaction/create", params)
        |> json_response(200)

      assert response["amount"] == "R$100.00"
      assert response["operation_type"] == "withdraw"
      assert Map.has_key?(response, "payer_id") == true
      assert Map.has_key?(response, "id") == true
      assert Map.has_key?(response, "inserted_at") == true
    end

    test "when params is invalid", %{conn: conn} do
      joe = Fixtures.Accounts.account(:joe)
      maria = Fixtures.Accounts.account(:maria)

      params =
        %{
          "transaction" => %{
            "operation_type" => "transfer",
            "amount" => -500_000,
            "receiver_id" => maria.id
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> using_token_auth(joe)
        |> post("/api/transaction/create", params)
        |> json_response(422)

      assert response == %{
               "errors" => %{"detail" => %{"balance" => ["amount cannot be negative"]}}
             }
    end
  end
end
