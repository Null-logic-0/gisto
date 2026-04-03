alias Gisto.Repo
alias Gisto.Accounts.User
alias Gisto.Accounts.Scope
alias Gisto.Gists.Gist

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

# -----------------------------
# Scopes
# -----------------------------
scope1 = %Scope{user: user1}
scope2 = %Scope{user: user2}
scope3 = %Scope{user: user3}
scope4 = %Scope{user: user4}

scopes = [scope1, scope2, scope3, scope4]

# -----------------------------
# Initial Gists
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
    markup_text: """
    defmodule MathUtils do
      def add(a, b), do: a + b
    end
    """
  },
  scope2
)
|> Repo.insert!()

%Gist{}
|> Gist.changeset(
  %{
    file_name: "strings.ex",
    description: "String utilities",
    markup_text: """
    defmodule StringUtils do
      def shout(s), do: String.upcase(s)
    end
    """
  },
  scope3
)
|> Repo.insert!()

# -----------------------------
# 20 Additional Gists
# -----------------------------
descriptions = [
  "Utility functions",
  "Learning Elixir",
  "Phoenix example",
  "Random experiments",
  "Code snippets"
]

for i <- 1..20 do
  scope = Enum.at(scopes, rem(i, length(scopes)))

  %Gist{}
  |> Gist.changeset(
    %{
      file_name: "example_#{i}.ex",
      description: Enum.random(descriptions),
      markup_text: """
      defmodule Example#{i} do
        def run do
          IO.puts("This is gist #{i}")
        end
      end
      """
    },
    scope
  )
  |> Repo.insert!()
end

IO.puts("✅ Seeds inserted successfully with 20 extra gists!")
