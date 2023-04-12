# frozen_string_literal: true

require 'tempfile'

require 'net/ssh'

module Hosts
  module Remote # rubocop:disable Style/Documentation
    private

    def remote_execute(cmd)
      stdout = ''.dup
      stderr = ''.dup
      status = {}
      remote_run(cmd, stdout, stderr, status)

      raise StandardError, stderr.strip if status[:exit_code].nonzero?

      stdout
    end

    def remote_run(cmd, stdout, stderr, status)
      Net::SSH.start(remote_user_host[:host], remote_user_host[:user]) do |ssh|
        ssh.exec!(cmd, status:) do |_, stream, data|
          stdout << data if stream == :stdout
          stderr << data if stream == :stderr
        end
      end
    end

    def remote_user_host
      user, host = @remote.split('@') if @remote.include?('@')
      user ||= ENV.fetch('USER')
      host ||= @remote

      { user:, host: }
    end

    def remote_parse
      return if @remote.nil?

      content = remote_execute("cat #{@file}")

      tempfile = Tempfile.new('hosts')
      tempfile.write(content)
      tempfile.close

      @tempfile = tempfile.path
    end

    def remote_save
      return if @remote.nil?

      remote_execute("echo '#{render_table(list)}' > #{@file}")
    end
  end
end
