# frozen_string_literal: true

module Web::RepositoriesHelper
  def link_to_github_commit(full_name, commit_id, options = {})
    url = "https://github.com/#{full_name}/commit/#{commit_id}"

    link_to commit_id.first(7), url, target: '_blank', rel: 'noopener', **options
  end

  def link_to_github_repository_file(full_name, commit_id, file_path, options = {})
    url = "https://github.com/#{full_name}/tree/#{commit_id}/#{file_path}"

    link_to file_path, url, target: '_blank', rel: 'noopener', **options
  end
end
