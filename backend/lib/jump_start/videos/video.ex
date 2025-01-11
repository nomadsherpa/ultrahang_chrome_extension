defmodule JumpStart.Videos.Video do
  use Ecto.Schema
  import Ecto.Changeset

  schema "videos" do
    field :yt_id, :string
    field :title, :string
    field :published_at, :utc_datetime

    field :transcript, :string
    field :start_time, :integer

    timestamps(type: :utc_datetime)
  end

  @doc false
  def changeset(video, attrs) do
    video
    |> cast(attrs, [:yt_id, :title, :published_at, :transcript, :start_time])
    |> validate_required([:yt_id, :title, :published_at])
  end
end
