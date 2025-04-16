# frozen_string_literal: true

module LinterRunner
  class EslintTest < ActiveSupport::TestCase
    def setup
      @repository_path = Rails.root.join('tmp/test_repo')
      @eslint          = Eslint.new(@repository_path)
      FileUtils.mkdir_p(@repository_path)
    end

    def teardown
      FileUtils.rm_rf(@repository_path)
    end

    def test_command_returns_correct_eslint_command
      expected_command =
        "yarn --silent eslint -c #{Rails.root.join('lib/linters_configs/eslint.mjs')} -f json #{@repository_path}"

      assert { expected_command == @eslint.send(:command) }
    end

    def test_remap_command_result_parses_valid_json
      sample_output = [
        {
          'filePath' => '/tmp/test_repo/app/javascript/components/Button.js',
          'messages' => [
            {
              'message' => "'console.log' is not allowed.",
              'ruleId' => 'no-console',
              'line' => 3,
              'column' => 5
            }
          ]
        }
      ].to_json

      expected_result = [
        {
          file_path: 'app/javascript/components/Button.js',
          offenses: [
            {
              message: "'console.log' is not allowed.",
              rule_name: 'no-console',
              line: 3,
              column: 5
            }
          ]
        }
      ]

      assert { expected_result == @eslint.send(:remap_command_result, sample_output) }
    end

    def test_remap_command_result_skips_files_without_messages
      sample_output = [
        {
          'filePath' => '/tmp/test_repo/app/javascript/components/Button.js',
          'messages' => []
        },
        {
          'filePath' => '/tmp/test_repo/app/javascript/components/Input.js',
          'messages' => [
            {
              'message' => 'Unexpected var, use let or const instead.',
              'ruleId' => 'no-var',
              'line' => 2,
              'column' => 1
            }
          ]
        }
      ].to_json

      expected_result = [
        {
          file_path: 'app/javascript/components/Input.js',
          offenses: [
            {
              message: 'Unexpected var, use let or const instead.',
              rule_name: 'no-var',
              line: 2,
              column: 1
            }
          ]
        }
      ]

      assert { expected_result == @eslint.send(:remap_command_result, sample_output) }
    end

    def test_repository_full_name_extracts_last_two_directories
      @eslint.instance_variable_set(
        :@repository_path, Pathname.new('/tmp/some/path/to/repo/owner/project')
      )

      assert { @eslint.send(:repository_full_name) == 'owner/project' }
    end

    def test_trim_file_path_removes_repository_part
      @eslint.instance_variable_set(
        :@repository_path, Pathname.new('/tmp/some/path/to/repo/owner/project')
      )

      assert { @eslint.send(:trim_file_path, '/tmp/some/path/to/repo/owner/project/app/javascript/index.js') == 'app/javascript/index.js' }
    end
  end
end
