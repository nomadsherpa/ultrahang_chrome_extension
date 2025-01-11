defmodule JumpStart.VideosTest do
  use JumpStart.DataCase

  alias JumpStart.Videos

  describe "videos" do
    alias JumpStart.Videos.Video

    import JumpStart.VideosFixtures

    @invalid_attrs %{title: nil, yt_id: nil, published_at: nil, transcript: nil, start_time: nil}

    test "list_videos/0 returns all videos" do
      video = video_fixture()
      assert Videos.list_videos() == [video]
    end

    test "get_video!/1 returns the video with given id" do
      video = video_fixture()
      assert Videos.get_video!(video.id) == video
    end

    test "create_video/1 with valid data creates a video" do
      valid_attrs = %{
        title: "some title",
        yt_id: "some yt_id",
        published_at: ~U[2025-01-10 11:43:00Z],
        transcript: "some transcript",
        start_time: 42
      }

      assert {:ok, %Video{} = video} = Videos.create_video(valid_attrs)
      assert video.title == "some title"
      assert video.yt_id == "some yt_id"
      assert video.published_at == ~U[2025-01-10 11:43:00Z]
      assert video.transcript == "some transcript"
      assert video.start_time == 42
    end

    test "create_video/1 with invalid data returns error changeset" do
      assert {:error, %Ecto.Changeset{}} = Videos.create_video(@invalid_attrs)
    end

    test "update_video/2 with valid data updates the video" do
      video = video_fixture()

      update_attrs = %{
        title: "some updated title",
        yt_id: "some updated yt_id",
        published_at: ~U[2025-01-11 11:43:00Z],
        transcript: "some updated transcript",
        start_time: 43
      }

      assert {:ok, %Video{} = video} = Videos.update_video(video, update_attrs)
      assert video.title == "some updated title"
      assert video.yt_id == "some updated yt_id"
      assert video.published_at == ~U[2025-01-11 11:43:00Z]
      assert video.transcript == "some updated transcript"
      assert video.start_time == 43
    end

    test "update_video/2 with invalid data returns error changeset" do
      video = video_fixture()
      assert {:error, %Ecto.Changeset{}} = Videos.update_video(video, @invalid_attrs)
      assert video == Videos.get_video!(video.id)
    end

    test "delete_video/1 deletes the video" do
      video = video_fixture()
      assert {:ok, %Video{}} = Videos.delete_video(video)
      assert_raise Ecto.NoResultsError, fn -> Videos.get_video!(video.id) end
    end

    test "change_video/1 returns a video changeset" do
      video = video_fixture()
      assert %Ecto.Changeset{} = Videos.change_video(video)
    end
  end
end
