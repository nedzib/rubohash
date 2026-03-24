require 'bundler/gem_tasks'
require 'rspec/core/rake_task'

RSpec::Core::RakeTask.new(:spec)

namespace :benchmark do
  desc 'Benchmark image generation'
  task :image_generation do
    ruby 'benchmark/image_generation.rb'
  end
end

task default: :spec
