require 'fileutils'
require 'pathname'
require 'open3'

module MySystem
  class Error < StandardError
  end

  class InstallError
  end

  module VimConfig
    class << self
      def install
        install_bundler
        create_vimrc
      end

      private

      def install_bundler
        # mkdir ~/.vim/bundle
        bundle_dir = MySystem::Dir.user_home.join('.vim', 'bundle')
        FileUtils.mkdir_p bundle_dir

        # git clone, or git pull
        neobundle_dir = bundle_dir.join('neobundle.vim')
        if ::File.directory?(neobundle_dir)
          cmd = "cd #{neobundle_dir} && git pull origin master"
        else
          cmd = "git clone https://github.com/Shougo/neobundle.vim #{neobundle_dir}"
        end

        if !system(cmd)
          raise MySystem::InstallError
        end
      end

      def create_vimrc
        src = MySystem::Dir.dotfiles.join('.vimrc')
        dst = MySystem::Dir.user_home.join('.vimrc')

        FileUtils.ln_sf(src, dst)
      end
    end
  end

  module Dir
    class << self
      def root
        Pathname.new(File.join(File.dirname(__FILE__), '..'))
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
