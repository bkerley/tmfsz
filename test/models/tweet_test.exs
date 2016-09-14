defmodule Tmfsz.TweetTest do
  use Tmfsz.ModelCase

  alias Tmfsz.Tweet

  @valid_attrs %{body: %{}, caption: "some content", created_at: %{day: 17, hour: 14, min: 0, month: 4, sec: 0, year: 2010}, default_imae_file_name: "some content", id_number: "120.5", id_str: "some content", text: "some content"}
  @invalid_attrs %{}

  test "changeset with valid attributes" do
    changeset = Tweet.changeset(%Tweet{}, @valid_attrs)
    assert changeset.valid?
  end

  test "changeset with invalid attributes" do
    changeset = Tweet.changeset(%Tweet{}, @invalid_attrs)
    refute changeset.valid?
  end
end
