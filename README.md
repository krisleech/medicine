# Medicine

[![Gem Version](https://badge.fury.io/rb/medicine.png)](http://badge.fury.io/rb/medicine)
[![Code Climate](https://codeclimate.com/github/krisleech/medicine.png)](https://codeclimate.com/github/krisleech/medicine)
[![Build Status](https://travis-ci.org/krisleech/medicine.png?branch=master)](https://travis-ci.org/krisleech/medicine)
[![Coverage Status](https://coveralls.io/repos/krisleech/medicine/badge.png?branch=master)](https://coveralls.io/r/krisleech/medicine?branch=master)

Simple Dependency Injection for Ruby

Find yourself injecting dependencies via the initalizer or a setter method?

Medicine makes this declarative.

## Usage

Include the Medicine module and declare the dependencies with `dependency`.

```ruby
class CastVote
  include Medicine.di

  dependency :votes_repo, default: -> { Vote }

  def call
    votes_repo # => Vote
  end
end
```

For each dependency declared a private method is defined which returns the
dependency.

### Without injection

```ruby
command = CastVote.new
```

In the above case the `votes_repo` method will return `Vote`.

If no dependency is injected the default will be used.

Specifying a default is optional and if a dependency is not injected and
there is no default an error will be raised if the dependencies method is
invoked.

### Injecting via initializer


```ruby
command = CastVote.new(votes_repo: double)
```

In the above case `votes_repo` will return the double.

### Inejcting via a setter

```ruby
command = CastVote.new
command.inject(:vote_repo, double)
```

In the above case `votes_repo` will return the double.

### Required dependencies

```ruby
dependency :vote_repo
```

When no default is specified the dependency must be injected via the
constructor or setter an otherwise an exception will be raised.

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
