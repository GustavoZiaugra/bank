defmodule BankWeb.Api.Report.TransactionControllerTest do
  use BankWeb.ConnCase
  alias Bank.Fixtures

  def call_fixtures do
    Fixtures.Transactions.transaction(:withdraw)
    Fixtures.Transactions.transaction(:transfer)
    :ok
  end

  describe "index/2" do
    test "report by_day", %{
      conn: conn
    } do
      params =
        %{
          "report" => %{
            "type" => "by_day"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/report/transactions", params)
        |> json_response(200)

      assert response["amount"] == "R$0.00"
      assert response["transactions"] == []
    end

    test "report by_month", %{
      conn: conn
    } do
      params =
        %{
          "report" => %{
            "type" => "by_month"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/report/transactions", params)
        |> json_response(200)

      assert response["amount"] == "R$0.00"
      assert response["transactions"] == []
    end

    test "report by_year", %{
      conn: conn
    } do
      params =
        %{
          "report" => %{
            "type" => "by_year"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/report/transactions", params)
        |> json_response(200)

      assert response["amount"] == "R$0.00"
      assert response["transactions"] == []
    end

    test "report total", %{
      conn: conn
    } do
      params =
        %{
          "report" => %{
            "type" => "total"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/report/transactions", params)
        |> json_response(200)

      assert response["amount"] == "R$0.00"
      assert response["transactions"] == []
    end

    test "report with data", %{
      conn: conn
    } do
      _fixtures = call_fixtures()

      params =
        %{
          "report" => %{
            "type" => "total"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/report/transactions", params)
        |> json_response(200)

      assert response["amount"] == "R$200.00"
      assert response["transactions"] |> Enum.count() == 2
    end

    test "report random", %{
      conn: conn
    } do
      params =
        %{
          "report" => %{
            "type" => "random"
          }
        }
        |> Jason.encode!()

      response =
        conn
        |> Plug.Conn.put_req_header("content-type", "application/json")
        |> post("/api/report/transactions", params)
        |> json_response(400)

      assert response == %{"errors" => %{"detail" => "Bad Request"}}
    end
  end
end
