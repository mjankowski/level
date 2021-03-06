defmodule Level.Spaces.SpaceTest do
  use Level.DataCase, async: true

  alias Level.Schemas.Space

  describe "slug_format/0" do
    test "matches lowercase alphanumeric and dash chars" do
      assert Regex.match?(Space.slug_format(), "level")
      assert Regex.match?(Space.slug_format(), "level-inc")
    end

    test "does not match whitespace" do
      refute Regex.match?(Space.slug_format(), "level inc")
    end

    test "does not match leading or trailing dashes" do
      refute Regex.match?(Space.slug_format(), "level-")
      refute Regex.match?(Space.slug_format(), "-level")
    end

    test "does not match special chars" do
      refute Regex.match?(Space.slug_format(), "level$")
    end
  end

  describe "Phoenix.Param.to_param implementation" do
    test "returns the slug" do
      space = %Space{id: 123, slug: "foo"}
      assert Phoenix.Param.to_param(space) == "foo"
    end
  end
end
