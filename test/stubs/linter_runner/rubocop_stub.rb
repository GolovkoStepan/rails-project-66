# frozen_string_literal: true

module LinterRunner
  class RubocopStub
    Result = Struct.new(:data, :status)

    attr_reader :repository_path

    delegate :logger, to: Rails

    attr_accessor :raise_on_run,
                  :run_result_data,
                  :run_result_status,
                  :error_message

    # @param [String] repository_path
    def initialize(repository_path)
      @repository_path   = repository_path
      @raise_on_run      = false
      @error_message     = 'error'
      @run_result_data   = []
      @run_result_status = 0
    end

    def run
      raise(StandardError, error_message) if raise_on_run

      Result.new(data: run_result_data, status: run_result_status)
    end
  end
end
