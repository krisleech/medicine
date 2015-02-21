# Medicine

[![Gem Version](https://badge.fury.io/rb/medicine.png)](http://badge.fury.io/rb/medicine)
[![Code Climate](https://codeclimate.com/github/krisleech/medicine.png)](https://codeclimate.com/github/krisleech/medicine)
[![Build Status](https://travis-ci.org/krisleech/medicine.png?branch=master)](https://travis-ci.org/krisleech/medicine)
[![Coverage Status](https://coveralls.io/repos/krisleech/medicine/badge.png?branch=master)](https://coveralls.io/r/krisleech/medicine?branch=master)

Simple Dependency Injection for Ruby

Find yourself passing dependencies in to the initalizer? Medicine makes this
declarative.

## Usage

Include the Medicine module and declare the dependencies with `dependency`.

```ruby
class CastVote
  include Medicine.di

  dependency :votes_repo, default: -> { Vote }

  def call(candidate_id)
    votes_repo.create(candidate_id: candidate_id)
    # ...
  end
end
```

The above adds an initializer to `CastVote` which accepts an optional hash of
dependencies.

For each dependency declared it adds a private method which returns the value
injected via the initializer, otherwise the default value.

```ruby
command = CastVote.new
```

In the above case `votes_repo` will return `Vote`.

```ruby
votes_repo = double('Vote')

command = CastVote.new(votes_repo: vote_repo)
```

In the above case `votes_repo` will return a double.

### Required dependencies

```ruby
dependency :vote_repo
```

When no default is specified the dependency must be injected via the
constructor otherwise an exception is raised.

### Default dependencies

```ruby
dependency :vote_repo, default: Vote
dependency :vote_repo, default: :vote
dependency :vote_repo, default: :Vote
dependency :vote_repo, default: 'Vote'
dependency :vote_repo, default: -> { Vote }
```

All the above examples will expose a method called `vote_repo` which returns the
`Vote` class as the default dependency.

### Already got an initializer?

If you want to pass arguments other than the dependencies in to the constructor
don't forget to invoke `super`:

```ruby
def initialize(arg1, arg2, dependencies = {})
  @arg1 = arg1
  @arg2 = arg2
  super(dependencies)
end
```

## Compatibility

Tested with MRI 2.1+ and Rubinius.

See the [build status](https://travis-ci.org/krisleech/medicine) for details.

## Running Specs

```
rspec spec
```
