# frozen_string_literal: true

class GithubRepositoryStub
  attr_reader :params

  delegate :[], to: :params

  # @param params [Hash]
  def initialize(params)
    @params = params.with_indifferent_access
  end

  %i[id name full_name language clone_url ssh_url].each do |method|
    define_method(method, -> { params[method] })
  end
end
