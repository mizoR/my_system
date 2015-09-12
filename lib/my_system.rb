require 'fileutils'
require 'pathname'
require 'open3'

module MySystem
  module VimConfig
    class << self
      def install
        setup
        install_bundler
        create_vimrc
      end

      private

      def install_bundler
        cmd = 'curl https://raw.githubusercontent.com/Shougo/neobundle.vim/master/bin/install.sh | sh'
        Open3.popen3(cmd) {|i, o, e, w|
          i.close
          $stdout.puts o.read
          $stderr.puts e.read
          exit 1 if w.value.exit != 0
        }
      end

      def create_vimrc
        src = MySystem::Dir.dotfiles.join('.vimrc')
        dst = MySystem::Dir.user_home.join('.vimrc')

        FileUtils.ln_sf(src, dst)
      end

      def setup
        bundle_dir = MySystem::Dir.user_home.join('.vim', 'bundle')
        FileUtils.mkdir_p bundle_dir
      end
    end
  end

  module Dir
    class << self
      def root
        Pathname.new(__dir__, '..')
      end

      def dotfiles
        root.join('lib', 'dotfiles')
      end

      def user_home
        Pathname.new(ENV['HOME'])
      end
    end
  end

  class << self
    def install
      VimConfig.install
    end
  end
end
