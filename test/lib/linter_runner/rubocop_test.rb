# frozen_string_literal: true

module LinterRunner
  class RubocopTest < ActiveSupport::TestCase
    def setup
      @repository_path = Rails.root.join('tmp/test_repo')
      @rubocop         = Rubocop.new(@repository_path)
      FileUtils.mkdir_p(@repository_path)
    end

    def teardown
      FileUtils.rm_rf(@repository_path)
    end

    def test_command_returns_correct_rubocop_command
      expected_command =
        "rubocop --config #{Rails.root.join('lib/linters_configs/rubocop.yml')} --format json #{@repository_path}"

      assert_equal expected_command, @rubocop.send(:command)
    end

    def test_remap_command_result_parses_valid_json
      sample_output = {
        'files' => [
          {
            'path' => '/tmp/test_repo/app/models/user.rb',
            'offenses' => [
              {
                'message' => 'Avoid using `puts`.',
                'cop_name' => 'Rails/Output',
                'location' => { 'start_line' => 5, 'start_column' => 3 }
              }
            ]
          }
        ]
      }.to_json

      expected_result = [
        {
          file_path: 'app/models/user.rb',
          offenses: [
            {
              message: 'Avoid using `puts`.',
              rule_name: 'Rails/Output',
              line: 5,
              column: 3
            }
          ]
        }
      ]

      assert_equal expected_result, @rubocop.send(:remap_command_result, sample_output)
    end

    def test_remap_command_result_skips_files_without_offenses
      sample_output = {
        'files' => [
          {
            'path' => '/tmp/test_repo/app/models/user.rb',
            'offenses' => []
          },
          {
            'path' => '/tmp/test_repo/app/models/post.rb',
            'offenses' => [
              {
                'message' => 'Line is too long.',
                'cop_name' => 'Metrics/LineLength',
                'location' => { 'start_line' => 10, 'start_column' => 80 }
              }
            ]
          }
        ]
      }.to_json

      expected_result = [
        {
          file_path: 'app/models/post.rb',
          offenses: [
            {
              message: 'Line is too long.',
              rule_name: 'Metrics/LineLength',
              line: 10,
              column: 80
            }
          ]
        }
      ]

      assert_equal expected_result, @rubocop.send(:remap_command_result, sample_output)
    end

    def test_repository_full_name_extracts_last_two_directories
      @rubocop.instance_variable_set(
        :@repository_path, Pathname.new('/tmp/some/path/to/repo/owner/project')
      )

      assert_equal 'owner/project', @rubocop.send(:repository_full_name)
    end

    def test_trim_file_path_removes_repository_part
      @rubocop.instance_variable_set(
        :@repository_path, Pathname.new('/tmp/some/path/to/repo/owner/project')
      )

      assert_equal 'app/models/user.rb', @rubocop.send(:trim_file_path, '/tmp/some/path/to/repo/owner/project/app/models/user.rb')
    end
  end
end
