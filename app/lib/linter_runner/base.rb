# frozen_string_literal: true

module LinterRunner
  class Base
    Result = Struct.new(:data, :status)

    attr_reader :repository_path

    delegate :logger, to: Rails

    # @param [String] repository_path
    def initialize(repository_path)
      @repository_path = repository_path
    end

    # @return [Result]
    def run
      stdout, exit_status = exec_command

      Result.new(
        data: remap_command_result(stdout),
        status: exit_status.exitstatus
      )
    end

    private

    # @return [String]
    def command
      raise NotImplementedError
    end

    # @return [Array<String>]
    def exec_command
      logger.info("Execute command: #{command}")

      Open3.popen3(command) do |_, stdout, _, wait_thr|
        [stdout.read, wait_thr.value]
      end
    end

    # @param [String] stdout
    def remap_command_result(_stdout)
      raise NotImplementedError
    end
  end
end
