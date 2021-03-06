# encoding: utf-8

module BitBucket
  class Client::Repos::Following < API
    @version = '1.0'

    # List repo followers
    #
    # = Examples
    #  bitbucket = BitBucket.new :user => 'user-name', :repo => 'repo-name'
    #  bitbucket.repos.following.followers
    #  bitbucket.repos.following.followers { |watcher| ... }
    #
    def followers(user_name, repo_name, params={})
      _update_user_repo_params(user_name, repo_name)
      _validate_user_repo_params(user, repo) unless user? && repo?
      normalize! params

      response = get_request("/repositories/#{user}/#{repo.downcase}/followers/", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

    # List repos being followed by the authenticated user
    #
    # = Examples
    #  bitbucket = BitBucket.new :oauth_token => '...', :oauth_secret => '...'
    #  bitbucket.repos.following.followed
    #
    def followed(*args)
      params = args.extract_options!
      normalize! params

      response = get_request("/user/follows", params)
      return response unless block_given?
      response.each { |el| yield el }
    end

  end # Repos::Watching
end # BitBucket
