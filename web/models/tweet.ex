defmodule Tmfsz.Tweet do
  use Tmfsz.Web, :model

  schema "tweets" do
    field :id_str, :string
    field :id_number, :decimal
    field :text, :string
    field :body, :map
    field :created_at, Ecto.DateTime
    field :default_imae_file_name, :string
    field :caption, :string

    timestamps()
  end

  @doc """
  Builds a changeset based on the `struct` and `params`.
  """
  def changeset(struct, params \\ %{}) do
    struct
    |> cast(params, [:id_str, :id_number, :text, :body, :created_at, :default_imae_file_name, :caption])
    |> validate_required([:id_str, :id_number, :text, :body, :created_at, :default_imae_file_name, :caption])
  end
end
