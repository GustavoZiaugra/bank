defmodule BankWeb.Api.AccountControllerTest do
  use BankWeb.ConnCase

  describe "create/2" do
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
        |> post("/api/account/create", params)
        |> json_response(200)

      assert response["balance"] == "R$1,000.00"
      assert response["name"] == "Gustavo Ziaugra"
      assert response["email"] == "gustavo.ziaugra@uol.com.br"
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
        |> post("/api/account/create", params)
        |> json_response(422)

      assert response ==
               %{"errors" => %{"detail" => %{"email" => ["can't be blank"]}}}
    end
  end
end
