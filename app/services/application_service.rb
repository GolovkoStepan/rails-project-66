# frozen_string_literal: true

class ApplicationService
  extend Dry::Initializer

  delegate :logger, to: Rails

  def self.call(...)
    new(...).call
  end

  def call
    raise NotImplementedError
  end
end
