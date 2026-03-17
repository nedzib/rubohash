# Rubohash

A ruby implementation for generating unique images based on the checksum of a given string.

## Installation

Add it to your Gemfile from GitHub:

```rb
gem 'rubohash', github: 'nedzib/rubohash', group: :development
```

For reproducible installs, prefer pinning a ref:

```rb
gem 'rubohash', github: 'nedzib/rubohash', tag: 'v0.1.0', group: :development
```

By default, generated files are written to `./output` from your current working directory.

For local development in this repository, you can use `./bin/build.sh`.

## Usage

From Ruby code:

```rb
  Rubohash.assemble!("my_test_string_here")
```

This will run the algorithm and output the file to `@robot_output_path`. You also need to have ImageMagick installed on your system.

From the command line:

```sh
rubohash my_test_string_here
rubohash my_test_string_here --output ./tmp/robots --format jpg
```

Rubohash can also be mounted inside a Rails application by setting `mounted` to `true`.

## Cleaning Up

You should be able to completely uninstall the gem by running:

```sh
  ./bin/clean.sh
```

## License and Attribution

The gem is available as open source under the terms of the [MIT License](https://opensource.org/licenses/MIT).

### Derivation Notice! :

The images are licensed under Creative Commons by attribution

> Robots lovingly provided by robohash.org

This ruby gem is a derivation of the python repository at: https://github.com/e1ven/Robohash

> The Python Code is available under the MIT/Expat license. See the LICENSE.txt file for the full text of this license. Copyright (c) 2011, Colin Davis.

> The RoboHash images are available under the CC-BY-3.0 license.
