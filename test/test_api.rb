require "test/unit"
require_relative '../lib/smart_init/main'

class TestService
  extend SmartInit
  initialize_with :attribute_1, :attribute_2
  is_callable

  def call
    [attribute_1, attribute_2]
  end
end

class TestServiceDefaults
  extend SmartInit
  initialize_with :attribute_1, attribute_2: "default_value_2", attribute_3: "default_value_3"
  is_callable

  def call
    [attribute_1, attribute_2, attribute_3]
  end
end

class TestHashIntegerDefaults
  extend SmartInit
  initialize_with :attribute_1, attribute_2: 2
  is_callable

  def call
    [attribute_1, attribute_2]
  end
end

class HashApiTest < Test::Unit::TestCase
  def test_keywords
    assert_equal TestService.call(attribute_1: "a", attribute_2: "b"), ["a", "b"]

    assert_raise ArgumentError do
      TestService.new(
        attribute_1: "a"
      )
    end
  end

  def test_keywords_defaults
    assert_equal TestServiceDefaults.call(attribute_1: "a"), ["a", "default_value_2", "default_value_3"]
    assert_equal TestServiceDefaults.call(attribute_1: "a", attribute_2: "b"), ["a", "b", "default_value_3"]
  end

  def test_integer_defaults
    assert_equal TestHashIntegerDefaults.call(attribute_1: 1), [1, 2]
  end

  def test_missing_attributes
    assert_raise ArgumentError do
      TestService.call(attribute_1: "a", invalid_attribute: "b")
    end
  end
end