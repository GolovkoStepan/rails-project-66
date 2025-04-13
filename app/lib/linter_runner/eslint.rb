# frozen_string_literal: true

module LinterRunner
  class Eslint < Base
    ESLINT_CONFIG_PATH = Rails.root.join('lib/linters_configs/eslint.mjs')

    private

    # @return [String]
    def command
      "yarn --silent eslint -c #{ESLINT_CONFIG_PATH} -f json #{repository_path}"
    end

    # @return [Array<Hash>]
    def remap_command_result(stdout)
      JSON.parse(stdout).map do |file_info|
        next if file_info['messages'].empty?

        {
          file_path: trim_file_path(file_info['filePath']),
          offenses: file_info['messages'].map do |message|
            {
              message: message['message'],
              rule_name: message['ruleId'],
              line: message['line'],
              column: message['column']
            }
          end
        }
      end.compact
    end

    # @return [String]
    def repository_full_name
      @repository_full_name ||= repository_path.to_s.split('/').last(2).join('/')
    end

    # @return [String]
    def trim_file_path(file_path)
      file_path.sub(%r{.*#{repository_full_name}/}, '')
    end
  end
end
