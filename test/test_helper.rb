require "bundler/setup"
require "active_support/test_case"
require "active_support/testing/stream"
require "mocha/minitest"
require "amazon_kamal"

class ActiveSupport::TestCase
  include ActiveSupport::Testing::Stream

  private

  def stdouted
    capture(:stdout) { yield }.strip
  end
end
