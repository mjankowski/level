defmodule Level.Events do
  @moduledoc """
  This module encapsulates behavior for publishing messages to listeners
  (such as Absinthe GraphQL subscriptions).
  """

  alias Level.Schemas.Group
  alias Level.Schemas.Post
  alias Level.Schemas.Reply
  alias Level.Schemas.Space
  alias Level.Schemas.SpaceUser

  # Space

  def space_updated(id, %Space{} = space) do
    publish_to_space(id, :space_updated, %{space: space})
  end

  def space_user_updated(id, %SpaceUser{} = space_user) do
    publish_to_space(id, :space_user_updated, %{space_user: space_user})
  end

  # Space user

  def group_bookmarked(id, %Group{} = group) do
    publish_to_space_user(id, :group_bookmarked, %{group: group})
  end

  def group_unbookmarked(id, %Group{} = group) do
    publish_to_space_user(id, :group_unbookmarked, %{group: group})
  end

  def posts_subscribed(id, posts) do
    publish_to_space_user(id, :posts_subscribed, %{posts: posts})
  end

  def posts_unsubscribed(id, posts) do
    publish_to_space_user(id, :posts_unsubscribed, %{posts: posts})
  end

  def posts_marked_as_unread(id, posts) do
    publish_to_space_user(id, :posts_marked_as_unread, %{posts: posts})
  end

  def posts_marked_as_read(id, posts) do
    publish_to_space_user(id, :posts_marked_as_read, %{posts: posts})
  end

  def posts_dismissed(id, posts) do
    publish_to_space_user(id, :posts_dismissed, %{posts: posts})
  end

  def user_mentioned(id, %Post{} = post) do
    publish_to_space_user(id, :user_mentioned, %{post: post})
  end

  def mentions_dismissed(id, %Post{} = post) do
    publish_to_space_user(id, :mentions_dismissed, %{post: post})
  end

  def replies_viewed(id, replies) do
    publish_to_space_user(id, :replies_viewed, %{replies: replies})
  end

  # Group

  def post_created(id, %Post{} = post) do
    publish_to_group(id, :post_created, %{post: post})
  end

  def group_membership_updated(id, {%Group{} = group, group_user}) do
    publish_to_group(id, :group_membership_updated, %{group: group, membership: group_user})
  end

  def group_updated(id, %Group{} = group) do
    publish_to_group(id, :group_updated, %{group: group})
  end

  # Post

  def post_updated(%Post{} = post) do
    publish_to_post(post.id, :post_updated, %{post: post})
  end

  def reply_created(id, %Reply{} = reply) do
    publish_to_post(id, :reply_created, %{reply: reply})
  end

  def reply_updated(id, %Reply{} = reply) do
    publish_to_post(id, :reply_updated, %{reply: reply})
  end

  def post_closed(id, %Post{} = post) do
    publish_to_post(id, :post_closed, %{post: post})
  end

  def post_reopened(id, %Post{} = post) do
    publish_to_post(id, :post_reopened, %{post: post})
  end

  # Internal

  defp publish_to_space(id, type, data) do
    do_publish(Map.merge(data, %{type: type}), space_subscription: id)
  end

  defp publish_to_space_user(id, type, data) do
    do_publish(Map.merge(data, %{type: type}), space_user_subscription: id)
  end

  defp publish_to_group(id, type, data) do
    do_publish(Map.merge(data, %{type: type}), group_subscription: id)
  end

  defp publish_to_post(id, type, data) do
    do_publish(Map.merge(data, %{type: type}), post_subscription: id)
  end

  defp do_publish(payload, topics) do
    Absinthe.Subscription.publish(LevelWeb.Endpoint, payload, topics)
  end
end
