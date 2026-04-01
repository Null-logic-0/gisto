alias Gisto.Repo
alias Gisto.Accounts.User
alias Gisto.Gists.Gist
alias Gisto.Accounts.Scope

# -----------------------------
# Users
# -----------------------------
user1 =
  %User{}
  |> User.registration_changeset(%{
    email: "test@example.com",
    username: "Null_logic_0",
    password: "password12345"
  })
  |> User.confirm_changeset()
  |> Repo.insert!()

user2 =
  %User{}
  |> User.registration_changeset(%{
    email: "john@example.com",
    username: "johndoe-1",
    password: "password12345"
  })
  |> User.confirm_changeset()
  |> Repo.insert!()

user3 =
  %User{}
  |> User.registration_changeset(%{
    email: "alice@example.com",
    username: "alice",
    password: "password12345"
  })
  |> User.confirm_changeset()
  |> Repo.insert!()

user4 =
  %User{}
  |> User.registration_changeset(%{
    email: "bob@example.com",
    username: "bob",
    password: "password12345"
  })
  |> User.confirm_changeset()
  |> Repo.insert!()

scope1 = %Scope{user: user1}
scope2 = %Scope{user: user2}
scope3 = %Scope{user: user3}

# -----------------------------
# Gists
# -----------------------------
%Gist{}
|> Gist.changeset(
  %{
    file_name: "hello_world.ex",
    description: "Hello World in Elixir",
    markup_text: "IO.puts(\"Hello, world!\")"
  },
  scope1
)
|> Repo.insert!()

%Gist{}
|> Gist.changeset(
  %{
    file_name: "math_utils.ex",
    description: "Basic math functions",
    markup_text: "defmodule MathUtils do\n  def add(a, b), do: a + b\nend"
  },
  scope2
)
|> Repo.insert!()

%Gist{}
|> Gist.changeset(
  %{
    file_name: "strings.ex",
    description: "String utilities",
    markup_text: "defmodule StringUtils do\n  def shout(s), do: String.upcase(s)\nend"
  },
  scope3
)
|> Repo.insert!()

IO.puts("✅ Seeds inserted successfully!")
