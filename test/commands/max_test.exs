defmodule Integration.MaxTest do
  use Cog.CommandCase, command_module: Cog.Commands.Max

  test "basic max" do
    inv_id = "basic_max"
    memory_accum(inv_id, %{"a" => 1})
    memory_accum(inv_id, %{"a" => 3})

    response = new_req(invocation_id: inv_id, cog_env: %{"a" => 2})
               |> send_req()
               |> unwrap()

    assert(response == %{a: 3})
  end

  test "max by simple key" do
    inv_id = "simple_key_max"
    memory_accum(inv_id, %{"a" => 1})
    memory_accum(inv_id, %{"a" => 3})

    response = new_req(invocation_id: inv_id, cog_env: %{"a" => 2}, args: ["a"])
               |> send_req()
               |> unwrap()

    assert(response == %{a: 3})
  end

  test "max by complex key" do
    inv_id = "complex_key_max"
    memory_accum(inv_id, %{"a" => %{"b" => 1}})
    memory_accum(inv_id, %{"a" => %{"b" => 3}})

    response = new_req(invocation_id: inv_id, cog_env: %{"a" => %{"b" => 2}}, args: ["a.b"])
               |> send_req()
               |> unwrap()

    assert(response == %{a: %{b: 3}})
  end

  test "max by incorrect key" do
    inv_id = "complex_key_max"
    memory_accum(inv_id, %{"a" => %{"b" => 1}})
    memory_accum(inv_id, %{"a" => %{"b" => 3}})

    error = new_req(invocation_id: inv_id, cog_env: %{"a" => %{"b" => 2}}, args: ["c.d"])
            |> send_req()
            |> unwrap_error()

    assert(error == "The path provided does not exist")
  end
end
