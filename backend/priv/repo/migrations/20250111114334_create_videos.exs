defmodule JumpStart.Repo.Migrations.CreateVideos do
  use Ecto.Migration

  def change do
    create table(:videos) do
      add :yt_id, :string
      add :title, :string
      add :published_at, :utc_datetime

      add :transcript, :text
      add :start_time, :integer

      timestamps(type: :utc_datetime)
    end

    create index(:videos, [:yt_id])
  end
end
