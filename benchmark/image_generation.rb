#!/usr/bin/env ruby

require 'tmpdir'
require_relative '../lib/rubohash'

module Rubohash
  class BenchmarkRunner
    DEFAULT_ITERATIONS = 10
    DEFAULT_WARMUP = 2
    DEFAULT_SCENARIOS = %w[with_background without_background].freeze
    DEFAULT_BATCH_SIZES = [1, 10, 100].freeze

    def initialize(iterations:, warmup:, scenarios:, batch_sizes:)
      @iterations = iterations
      @warmup = warmup
      @scenarios = scenarios
      @batch_sizes = batch_sizes
    end

    def call
      print_header
      @scenarios.each { |scenario| run_scenario(scenario) }
    end

    private

    def run_scenario(scenario)
      use_background = scenario == 'with_background'

      with_benchmark_config(use_background: use_background) do
        @warmup.times do |index|
          image = build_image("warmup-#{scenario}-#{index}")
          image.destroy!
        end

        puts "scenario: #{scenario}"
        @batch_sizes.each do |batch_size|
          durations = benchmark_batch(scenario, batch_size)
          print_report(batch_size, durations)
        end
        puts
      end
    end

    def build_image(seed)
      Rubohash::Factory.new(seed).assemble
    end

    def benchmark_batch(scenario, batch_size)
      durations = []

      @iterations.times do |index|
        started_at = monotonic_time
        batch_size.times do |offset|
          seed = "benchmark-#{scenario}-#{batch_size}-#{index}-#{offset}"
          image = build_image(seed)
          image.destroy!
        end
        durations << ((monotonic_time - started_at) * 1000.0)
      end

      durations
    end

    def with_benchmark_config(use_background:)
      original = {
        mounted: Rubohash.mounted,
        use_background: Rubohash.use_background,
        robot_output_path: Rubohash.robot_output_path
      }

      Dir.mktmpdir('rubohash-benchmark') do |tmpdir|
        Rubohash.configure do |config|
          config.mounted = true
          config.use_background = use_background
          config.robot_output_path = tmpdir
        end

        yield
      ensure
        Rubohash.configure do |config|
          config.mounted = original[:mounted]
          config.use_background = original[:use_background]
          config.robot_output_path = original[:robot_output_path]
        end
      end
    end

    def print_header
      puts 'Rubohash image generation benchmark'
      puts "iterations: #{@iterations}"
      puts "warmup: #{@warmup}"
      puts "batch_sizes: #{@batch_sizes.join(', ')}"
      puts
    end

    def print_report(batch_size, durations)
      sorted = durations.sort
      total = durations.sum
      average = total / durations.length
      median = percentile(sorted, 50)
      p95 = percentile(sorted, 95)
      per_image_average = average / batch_size

      puts "  batch_size: #{batch_size}"
      puts format('    total:         %.2f ms', total)
      puts format('    avg_batch:     %.2f ms', average)
      puts format('    avg_per_image: %.2f ms', per_image_average)
      puts format('    median_batch:  %.2f ms', median)
      puts format('    p95_batch:     %.2f ms', p95)
      puts format('    min/max:       %.2f / %.2f ms', sorted.first, sorted.last)
    end

    def percentile(sorted_values, rank)
      return sorted_values.first if sorted_values.length == 1

      index = ((rank / 100.0) * (sorted_values.length - 1)).round
      sorted_values[index]
    end

    def monotonic_time
      Process.clock_gettime(Process::CLOCK_MONOTONIC)
    end
  end
end

iterations = Integer(ENV.fetch('ITERATIONS', Rubohash::BenchmarkRunner::DEFAULT_ITERATIONS))
warmup = Integer(ENV.fetch('WARMUP', Rubohash::BenchmarkRunner::DEFAULT_WARMUP))
scenarios = ENV.fetch('SCENARIOS', Rubohash::BenchmarkRunner::DEFAULT_SCENARIOS.join(',')).split(',').map(&:strip)
batch_sizes = ENV.fetch('BATCH_SIZES', Rubohash::BenchmarkRunner::DEFAULT_BATCH_SIZES.join(',')).split(',').map { |value| Integer(value.strip) }

unknown_scenarios = scenarios - Rubohash::BenchmarkRunner::DEFAULT_SCENARIOS
abort("Unknown scenarios: #{unknown_scenarios.join(', ')}") unless unknown_scenarios.empty?
abort('BATCH_SIZES must only contain positive integers') unless batch_sizes.all?(&:positive?)

Rubohash::BenchmarkRunner.new(
  iterations: iterations,
  warmup: warmup,
  scenarios: scenarios,
  batch_sizes: batch_sizes
).call
