defmodule BankWeb.Api.AccountControllerTest do
  use BankWeb.ConnCase
  alias Bank.Fixtures

  describe "sign_up/2" do
    test "create a new account", %{
      conn: conn
    } do
      params =
        %{
          "account" => %{
            "name" => "Gustavo Ziaugra",
            "email" => "gustavo.ziaugra@uol.com.br",
            "password" => "gustavo123"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/account/sign_up", params)
        |> json_response(200)

      assert response["balance"] == "R$1,000.00"
      assert response["name"] == "Gustavo Ziaugra"
      assert response["email"] == "gustavo.ziaugra@uol.com.br"
      assert Map.has_key?(response, "jwt") == true
      assert Map.has_key?(response, "id") == true
    end

    test "should not create a new account with invalid params", %{
      conn: conn
    } do
      params =
        %{
          "account" => %{
            "name" => "Gustavo Ziaugra",
            "password" => "gustavo123"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/account/sign_up", params)
        |> json_response(422)

      assert response ==
               %{"errors" => %{"detail" => %{"email" => ["can't be blank"]}}}
    end
  end

  describe "sign_in/2" do
    test "should return a token when credentials are valid", %{
      conn: conn
    } do
      _account = Fixtures.Accounts.account(:joe)

      params =
        %{
          "account" => %{
            "email" => "joe@armistrong.com.br",
            "password" => "1234567"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/account/sign_in", params)
        |> json_response(200)

      assert Map.has_key?(response, "jwt") == true
    end

    test "should return unauthorized when credentials are invalid", %{
      conn: conn
    } do
      _account = Fixtures.Accounts.account(:joe)

      params =
        %{
          "account" => %{
            "email" => "joe@armistrong.com.br",
            "password" => "hiedronyes"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/account/sign_in", params)
        |> json_response(401)

      assert response == %{"errors" => %{"detail" => "Unauthorized"}}
    end
  end
end
