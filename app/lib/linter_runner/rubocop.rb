# frozen_string_literal: true

module LinterRunner
  class Rubocop < Base
    RUBOCOP_CONFIG_PATH = Rails.root.join('lib/linters_configs/rubocop.yml')

    private

    # @return [String]
    def command
      "rubocop --config #{RUBOCOP_CONFIG_PATH} --format json #{repository_path}"
    end

    # @return [Array<Hash>]
    def remap_command_result(stdout)
      JSON.parse(stdout)['files'].map do |file|
        next if file['offenses'].empty?

        {
          file_path: trim_file_path(file['path']),
          offenses: file['offenses'].map do |offense|
            {
              message: offense['message'],
              rule_name: offense['cop_name'],
              line: offense.dig('location', 'start_line'),
              column: offense.dig('location', 'start_column')
            }
          end
        }
      end.compact
    end

    def repository_full_name
      @repository_full_name ||= repository_path.to_s.split('/').last(2).join('/')
    end

    def trim_file_path(file_path)
      file_path.sub(%r{.*#{repository_full_name}/}, '')
    end
  end
end
